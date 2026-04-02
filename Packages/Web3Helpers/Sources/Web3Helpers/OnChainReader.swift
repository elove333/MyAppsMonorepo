import Foundation

/// Executes raw JSON-RPC `eth_call` requests against an EVM node.
public actor OnChainReader {

    private let rpcURL: URL
    private let session: URLSession

    public init(rpcURL: URL, session: URLSession = .shared) {
        self.rpcURL = rpcURL
        self.session = session
    }

    /// Calls a smart-contract method by sending an `eth_call` JSON-RPC request.
    /// - Parameters:
    ///   - contractAddress: Hex-encoded contract address (`0x…`).
    ///   - data: ABI-encoded calldata.
    /// - Returns: ABI-encoded return data from the contract.
    /// - Throws: `Web3Error.rpcError` on any RPC-level failure.
    public func call(contractAddress: String, data: Data) async throws -> Data {
        let callObject: [String: Any] = [
            "to": contractAddress,
            "data": "0x" + data.map { String(format: "%02x", $0) }.joined()
        ]
        let payload: [String: Any] = [
            "jsonrpc": "2.0",
            "method": "eth_call",
            "params": [callObject, "latest"],
            "id": 1
        ]

        var request = URLRequest(url: rpcURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let (responseData, _) = try await session.data(for: request)

        guard let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any] else {
            throw Web3Error.rpcError("Malformed JSON-RPC response")
        }

        if let errorObj = json["error"] as? [String: Any],
           let message = errorObj["message"] as? String {
            throw Web3Error.rpcError(message)
        }

        guard let resultHex = json["result"] as? String,
              resultHex.hasPrefix("0x") else {
            throw Web3Error.rpcError("Missing result in JSON-RPC response")
        }

        let hex = String(resultHex.dropFirst(2))
        let bytes = stride(from: 0, to: hex.count, by: 2).compactMap { i -> UInt8? in
            let start = hex.index(hex.startIndex, offsetBy: i)
            let end = hex.index(start, offsetBy: 2, limitedBy: hex.endIndex) ?? hex.endIndex
            return UInt8(hex[start..<end], radix: 16)
        }
        return Data(bytes)
    }
}
