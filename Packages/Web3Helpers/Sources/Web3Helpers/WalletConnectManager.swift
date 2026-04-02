import Foundation
import Combine

/// Connection states for a WalletConnect v2 session.
public enum WalletConnectState: Sendable {
    case disconnected
    case proposalReceived(topic: String)
    case connected(account: String, chainId: Int)
    case rejected
}

/// Manages WalletConnect v2 session lifecycle.
public actor WalletConnectManager {

    // MARK: - Public state

    private(set) public var connectionState: WalletConnectState = .disconnected
    private let stateSubject: PassthroughSubject<WalletConnectState, Never>
    public nonisolated let statePublisher: AnyPublisher<WalletConnectState, Never>

    // MARK: - Init

    public init() {
        let subject = PassthroughSubject<WalletConnectState, Never>()
        stateSubject = subject
        statePublisher = subject.eraseToAnyPublisher()
    }

    // MARK: - Session management

    /// Simulates receiving a session proposal from a dApp.
    public func receiveProposal(topic: String) {
        updateState(.proposalReceived(topic: topic))
    }

    /// Approves a pending session proposal.
    /// - Throws: `Web3Error.walletNotConnected` if no proposal is pending.
    public func approveSession(account: String, chainId: Int) throws {
        guard case .proposalReceived = connectionState else {
            throw Web3Error.walletNotConnected
        }
        updateState(.connected(account: account, chainId: chainId))
    }

    /// Rejects a pending session proposal.
    public func rejectSession() {
        updateState(.rejected)
    }

    /// Disconnects the active session.
    public func disconnect() {
        updateState(.disconnected)
    }

    // MARK: - Private helpers

    private func updateState(_ newState: WalletConnectState) {
        connectionState = newState
        stateSubject.send(newState)
    }
}
