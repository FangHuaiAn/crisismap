import Foundation

@MainActor
@Observable
final class ActorsViewModel {
    var actors: [ActorStatus] = []
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
        if actors.isEmpty { isLoading = true }
        do {
            actors = try await APIClient.shared.fetchActors()
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
