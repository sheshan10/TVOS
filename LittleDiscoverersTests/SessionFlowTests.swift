import XCTest
@testable import LittleDiscoverers

@MainActor
final class SessionFlowTests: XCTestCase {
    private var suiteName = ""
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "littlediscoverers.flow.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    private func model(now: @escaping () -> Date = { Date(timeIntervalSince1970: 1_700_000_000) }) throws -> AppViewModel {
        let bundle = Bundle(for: AppBundleMarker.self)
        let url = try XCTUnwrap(bundle.url(forResource: "questions", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let content = QuestionBankLoader.load(data: data, availableAssets: IllustrationAsset.names)
        return AppViewModel(
            content: content,
            progressStore: ProgressStore(defaults: defaults),
            narration: NarrationService(),
            fixedOrder: true,
            silenceNarration: true,
            now: now
        )
    }

    func testUnansweredQuestionDoesNotAdvanceOrSave() throws {
        let model = try model()
        model.startQuiz(topic: .animals)
        model.nextPicture()
        XCTAssertEqual(model.route, .quiz)
        XCTAssertEqual(model.session?.index, 0)
        XCTAssertEqual(model.progress.progress(for: .animals).completedSessionCount, 0)
    }

    func testLeavingAnUnfinishedSessionDiscardsIt() throws {
        let model = try model()
        model.startQuiz(topic: .fruits)
        model.choose("Apple")
        model.confirmLeave()
        XCTAssertEqual(model.route, .topics)
        XCTAssertNil(model.session)
        XCTAssertEqual(model.progress.progress(for: .fruits).completedSessionCount, 0)
        XCTAssertTrue(model.progress.progress(for: .fruits).exploredPictureIDs.isEmpty)
    }

    func testCompletedSessionSavesOnceAndASecondAdventureSavesAgain() throws {
        let moment = Date(timeIntervalSince1970: 1_710_000_000)
        let model = try model(now: { moment })
        try finishAnimals(model, firstTry: true)
        let saved = model.progress.progress(for: .animals)
        XCTAssertEqual(model.route, .results)
        XCTAssertEqual(saved.bestFirstTryScore, 5)
        XCTAssertEqual(saved.completedSessionCount, 1)
        XCTAssertEqual(saved.exploredCount, 5)
        XCTAssertEqual(saved.lastCompletionDate, moment)
        model.nextPicture()
        XCTAssertEqual(model.progress.progress(for: .animals).completedSessionCount, 1)

        model.playAgain()
        try finishAnimals(model, firstTry: false)
        let second = model.progress.progress(for: .animals)
        XCTAssertEqual(second.completedSessionCount, 2)
        XCTAssertEqual(second.bestFirstTryScore, 5)
        XCTAssertEqual(second.exploredCount, 5)
    }

    func testNarrationQuestionDoesNotCallOutTheCorrectChoice() throws {
        let model = try model()
        model.startQuiz(topic: .animals)
        let question = try XCTUnwrap(model.session?.currentQuestion)
        let spoken = NarrationScript.question(question)
        XCTAssertTrue(spoken.hasPrefix("What is this?"))
        XCTAssertFalse(spoken.localizedCaseInsensitiveContains("correct answer"))
        XCTAssertFalse(spoken.contains(question.fact))
        for choice in question.choices {
            XCTAssertTrue(spoken.contains(choice))
        }
        let success = NarrationScript.success(question)
        XCTAssertTrue(success.contains(question.correctAnswer))
        XCTAssertTrue(success.contains(question.fact))
        XCTAssertEqual(NarrationScript.retry(), "Good try! Choose another answer.")
    }

    func testBrokenContentPreventsQuizStart() {
        let broken = QuestionBankLoader.load(data: Data("[]".utf8), availableAssets: [])
        let model = AppViewModel(
            content: broken,
            progressStore: ProgressStore(defaults: defaults),
            narration: NarrationService(),
            fixedOrder: true,
            silenceNarration: true
        )
        XCTAssertFalse(model.canStartQuiz)
        XCTAssertNotNil(model.contentProblem)
        model.startQuiz(topic: .animals)
        XCTAssertNotEqual(model.route, .quiz)
    }

    private func finishAnimals(_ model: AppViewModel, firstTry: Bool) throws {
        for _ in 0..<5 {
            let question = try XCTUnwrap(model.session?.currentQuestion)
            if !firstTry {
                let wrong = try XCTUnwrap(question.choices.first { $0 != question.correctAnswer })
                model.choose(wrong)
            }
            model.choose(question.correctAnswer)
            model.nextPicture()
        }
    }
}
