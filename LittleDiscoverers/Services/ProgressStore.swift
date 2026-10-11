import Foundation

/// Stores a small progress record on this Apple TV.
/// UserDefaults is enough for a few scores, picture IDs, dates, and one preference.
/// Unreadable data is replaced with an empty record so the app can keep running.
final class ProgressStore {
    static let storageKey = "littlediscoverers.progress.v1"

    private let defaults: UserDefaults
    private let key: String

    init(defaults: UserDefaults = .standard, key: String = ProgressStore.storageKey) {
        self.defaults = defaults
        self.key = key
    }

    func load() -> SavedProgress {
        guard let data = defaults.data(forKey: key) else { return .empty }
        do {
            let decoded = try Self.decoder.decode(SavedProgress.self, from: data)
            return decoded.sanitized()
        } catch {
            let fresh = SavedProgress.empty
            save(fresh)
            return fresh
        }
    }

    @discardableResult
    func save(_ progress: SavedProgress) -> Bool {
        guard let data = try? Self.encoder.encode(progress.sanitized()) else { return false }
        defaults.set(data, forKey: key)
        return true
    }

    func resetKeepingNarration() -> SavedProgress {
        let fresh = SavedProgress(topics: [:], narrationEnabled: load().narrationEnabled)
        save(fresh)
        return fresh
    }

    private static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }

    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
