import Foundation

/// Builds and verifies Sign-In With Ethereum (EIP-4361) authentication flows.
public actor SIWEAuthManager {

    private var pendingMessage: SIWEMessage?

    public init() {}

    /// Constructs a `SIWEMessage` for the given wallet address and domain.
    /// - Returns: A populated `SIWEMessage` ready to be signed by the wallet.
    public func buildMessage(
        domain: String,
        address: String,
        uri: String,
        chainId: Int
    ) -> SIWEMessage {
        let nonce = UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(16).lowercased()
        let issuedAt = ISO8601DateFormatter().string(from: Date())
        let message = SIWEMessage(
            domain: domain,
            address: address,
            uri: uri,
            version: "1",
            chainId: chainId,
            nonce: String(nonce),
            issuedAt: issuedAt
        )
        pendingMessage = message
        return message
    }

    /// Verifies that a received signature corresponds to the pending SIWE message.
    ///
    /// In production this would call an ecrecover / verification service.
    /// Here we validate the structural integrity only.
    /// - Throws: `Web3Error.authFailed` if verification fails.
    public func verifySignature(_ signature: String, for message: SIWEMessage) throws {
        guard !signature.isEmpty,
              signature.hasPrefix("0x"),
              signature.count == 132   // 65-byte signature in hex
        else {
            throw Web3Error.authFailed
        }
        // Verify the message matches what we issued.
        guard message == pendingMessage else {
            throw Web3Error.authFailed
        }
        pendingMessage = nil
    }
}
