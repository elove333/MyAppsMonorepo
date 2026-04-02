import Foundation
import Combine
import Web3Helpers
import CoreAnalytics

@MainActor
final class WalletViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var isConnected = false
    @Published private(set) var account: String = ""
    @Published private(set) var chainId: Int = 1
    @Published private(set) var balance: String = "0 ETH"
    @Published var showError = false
    @Published private(set) var errorMessage: String?

    var truncatedAddress: String {
        guard account.count > 10 else { return account }
        return "\(account.prefix(6))…\(account.suffix(4))"
    }

    // MARK: - Private

    private let walletManager = WalletConnectManager()
    private var cancellables = Set<AnyCancellable>()

    init() {
        walletManager.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func connect() async {
        await walletManager.receiveProposal(topic: UUID().uuidString)
        do {
            try await walletManager.approveSession(
                account: "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045",
                chainId: 1
            )
        } catch {
            showError(error)
        }
    }

    func disconnect() async {
        await walletManager.disconnect()
    }

    // MARK: - Private helpers

    private func handleStateChange(_ state: WalletConnectState) {
        switch state {
        case .connected(let addr, let chain):
            isConnected = true
            account = addr
            chainId = chain
            balance = "1.234 ETH"
            Task {
                await AnalyticsManager.shared.track(WalletConnectedEvent(address: addr))
            }
        case .disconnected, .rejected:
            isConnected = false
            account = ""
            balance = "0 ETH"
        default:
            break
        }
    }

    private func showError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}

// MARK: - Analytics

private struct WalletConnectedEvent: AnalyticsEvent {
    let name = "wallet_connected"
    let address: String
    var parameters: [String: any Sendable] { ["address": address] }
}
