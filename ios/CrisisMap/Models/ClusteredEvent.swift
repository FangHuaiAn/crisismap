import Foundation

struct ClusteredEvent: Identifiable, Sendable {
    let event: CrisisEvent
    let clusterId: String
    let clusterLabel: String
    let regions: [Region]
    let topics: [String]

    var id: String { event.id }

    var mentionKey: String {
        "\(event.source.lowercased())::\(clusterId)"
    }
}
