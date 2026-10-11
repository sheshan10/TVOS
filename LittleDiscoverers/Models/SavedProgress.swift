import Foundation

struct TopicProgress: Codable, Equatable {
    var bestFirstTryScore: Int
    var completedSessionCount: Int
    var exploredPictureIDs: [String]
    var lastCompletionDate: Date?

    static let empty = TopicProgress(
        bestFirstTryScore: 0,
        completedSessionCount: 0,
        exploredPictureIDs: [],
        lastCompletionDate: nil
    )

    var exploredCount: Int {
        Set(exploredPictureIDs).count
    }
}

struct SavedProgress: Codable, Equatable {
    var topics: [String: TopicProgress]
    var narrationEnabled: Bool

    static let empty = SavedProgress(topics: [:], narrationEnabled: true)

    func progress(for topic: TopicID) -> TopicProgress {
        topics[topic.rawValue] ?? .empty
    }

    mutating func recordCompletion(topic: TopicID, stars: Int, pictureIDs: [String], date: Date) {
        var item = progress(for: topic)
        let boundedStars = min(5, max(0, stars))
        item.bestFirstTryScore = max(item.bestFirstTryScore, boundedStars)
        item.completedSessionCount += 1
        var explored = Set(item.exploredPictureIDs)
        pictureIDs.forEach { explored.insert($0) }
        item.exploredPictureIDs = explored.sorted()
        item.lastCompletionDate = date
        topics[topic.rawValue] = item
    }

    func sanitized() -> SavedProgress {
        var copy = self
        copy.topics = topics.mapValues { item in
            var cleaned = item
            cleaned.bestFirstTryScore = min(5, max(0, item.bestFirstTryScore))
            cleaned.completedSessionCount = max(0, item.completedSessionCount)
            cleaned.exploredPictureIDs = Array(Set(item.exploredPictureIDs)).sorted()
            return cleaned
        }
        return copy
    }
}
