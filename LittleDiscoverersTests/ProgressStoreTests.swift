import XCTest
@testable import LittleDiscoverers

final class ProgressStoreTests: XCTestCase {
    private var suiteName = ""
    private var defaults: UserDefaults!
    private var store: ProgressStore!

    override func setUp() {
        super.setUp()
        suiteName = "littlediscoverers.tests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
        store = ProgressStore(defaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    func testRoundTripAndNarrationPreference() {
        var progress = SavedProgress.empty
        progress.narrationEnabled = false
        progress.recordCompletion(topic: .fruits, stars: 4, pictureIDs: ["fruits-apple"], date: Date(timeIntervalSince1970: 1_700_000_000))
        XCTAssertTrue(store.save(progress))
        let loaded = store.load()
        XCTAssertFalse(loaded.narrationEnabled)
        XCTAssertEqual(loaded.progress(for: .fruits).bestFirstTryScore, 4)
        XCTAssertEqual(loaded.progress(for: .fruits).exploredPictureIDs, ["fruits-apple"])
        XCTAssertEqual(loaded.progress(for: .fruits).lastCompletionDate, Date(timeIntervalSince1970: 1_700_000_000))
    }

    func testBestScoreIsPreservedWhenLaterScoreIsLower() {
        var progress = SavedProgress.empty
        progress.recordCompletion(topic: .animals, stars: 4, pictureIDs: ["animals-cat"], date: Date(timeIntervalSince1970: 10))
        progress.recordCompletion(topic: .animals, stars: 1, pictureIDs: ["animals-dog"], date: Date(timeIntervalSince1970: 20))
        XCTAssertEqual(progress.progress(for: .animals).bestFirstTryScore, 4)
        XCTAssertEqual(progress.progress(for: .animals).completedSessionCount, 2)
        XCTAssertEqual(progress.progress(for: .animals).exploredPictureIDs, ["animals-cat", "animals-dog"])
        XCTAssertEqual(progress.progress(for: .animals).lastCompletionDate, Date(timeIntervalSince1970: 20))
    }

    func testHigherScoreUpdatesBestAndUniqueIDsStayUnique() {
        var progress = SavedProgress.empty
        progress.recordCompletion(topic: .vehicles, stars: 2, pictureIDs: ["vehicles-car", "vehicles-bus"], date: Date(timeIntervalSince1970: 10))
        progress.recordCompletion(topic: .vehicles, stars: 5, pictureIDs: ["vehicles-bus", "vehicles-train"], date: Date(timeIntervalSince1970: 30))
        let item = progress.progress(for: .vehicles)
        XCTAssertEqual(item.bestFirstTryScore, 5)
        XCTAssertEqual(item.exploredPictureIDs, ["vehicles-bus", "vehicles-car", "vehicles-train"])
        XCTAssertEqual(item.exploredCount, 3)
    }

    func testResetClearsProgressAndKeepsNarration() {
        var progress = SavedProgress.empty
        progress.narrationEnabled = false
        progress.recordCompletion(topic: .animals, stars: 3, pictureIDs: ["animals-cat"], date: Date())
        store.save(progress)
        let reset = store.resetKeepingNarration()
        XCTAssertFalse(reset.narrationEnabled)
        XCTAssertEqual(reset.progress(for: .animals).completedSessionCount, 0)
        XCTAssertEqual(reset.progress(for: .animals).bestFirstTryScore, 0)
        XCTAssertTrue(reset.progress(for: .animals).exploredPictureIDs.isEmpty)
        XCTAssertNil(reset.progress(for: .animals).lastCompletionDate)
    }

    func testUnreadableDataDoesNotCrashAndBecomesEmpty() {
        defaults.set(Data("not-json".utf8), forKey: ProgressStore.storageKey)
        let loaded = store.load()
        XCTAssertEqual(loaded, .empty)
        let loadedAgain = store.load()
        XCTAssertEqual(loadedAgain, .empty)
    }

    func testOutOfRangeStoredScoreIsClamped() {
        let raw = """
        {"narrationEnabled":true,"topics":{"animals":{"bestFirstTryScore":99,"completedSessionCount":-4,"exploredPictureIDs":["animals-cat","animals-cat"],"lastCompletionDate":null}}}
        """
        defaults.set(Data(raw.utf8), forKey: ProgressStore.storageKey)
        let loaded = store.load()
        XCTAssertEqual(loaded.progress(for: .animals).bestFirstTryScore, 5)
        XCTAssertEqual(loaded.progress(for: .animals).completedSessionCount, 0)
        XCTAssertEqual(loaded.progress(for: .animals).exploredPictureIDs, ["animals-cat"])
    }
}
