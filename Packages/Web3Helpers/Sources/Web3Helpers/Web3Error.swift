import Foundation

/// Errors thrown by the Web3 subsystem.
public enum Web3Error: Error, Sendable, Equatable {
    case walletNotConnected
    case authFailed
    case rpcError(String)
    case insufficientFunds
    case quoteUnavailable
}

extension Web3Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .walletNotConnected:
            return "No wallet is currently connected."
        case .authFailed:
            return "Sign-In With Ethereum authentication failed."
        case .rpcError(let message):
            return "JSON-RPC error: \(message)"
        case .insufficientFunds:
            return "Insufficient funds to complete the transaction."
        case .quoteUnavailable:
            return "A swap quote is not available for the requested token pair."
        }
    }
}
