import Foundation

@MainActor
@Observable
final class MarketsViewModel {
    var indicators: [MarketIndicator] = []
    var contracts: [PolymarketContract] = []
    var isLoading = false
    var error: String?

    private var pollingTask: Task<Void, Never>?

    // MARK: - Polling

    func startPolling() {
        guard pollingTask == nil else { return }
        pollingTask = Task {
            while !Task.isCancelled {
                await refresh()
                try? await Task.sleep(for: .seconds(300))
            }
        }
    }

    func stopPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }

    func refresh() async {
        if indicators.isEmpty { isLoading = true }
        do {
            async let fetchedIndicators = APIClient.shared.fetchIndicators()
            async let fetchedContracts = APIClient.shared.fetchMarkets()

            indicators = try await fetchedIndicators
            contracts = try await fetchedContracts
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
