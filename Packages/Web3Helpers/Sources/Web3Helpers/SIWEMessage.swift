import Foundation

/// An EIP-4361 Sign-In With Ethereum message.
public struct SIWEMessage: Sendable, Equatable {
    public let domain: String
    public let address: String
    public let statement: String
    public let uri: String
    public let version: String
    public let chainId: Int
    public let nonce: String
    public let issuedAt: String

    public init(
        domain: String,
        address: String,
        statement: String = "Sign in with Ethereum.",
        uri: String,
        version: String = "1",
        chainId: Int,
        nonce: String,
        issuedAt: String
    ) {
        self.domain = domain
        self.address = address
        self.statement = statement
        self.uri = uri
        self.version = version
        self.chainId = chainId
        self.nonce = nonce
        self.issuedAt = issuedAt
    }

    /// Returns the canonical EIP-4361 plaintext representation.
    public func formatted() -> String {
        """
        \(domain) wants you to sign in with your Ethereum account:
        \(address)

        \(statement)

        URI: \(uri)
        Version: \(version)
        Chain ID: \(chainId)
        Nonce: \(nonce)
        Issued At: \(issuedAt)
        """
    }
}
