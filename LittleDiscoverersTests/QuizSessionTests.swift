import XCTest
@testable import LittleDiscoverers

final class QuizSessionTests: XCTestCase {
    private func makeQuestions() -> [Question] {
        (0..<5).map { index in
            Question(
                id: "animals-\(index)",
                topic: TopicID.animals.rawValue,
                imageName: "animal_cat",
                correctAnswer: "Right",
                choices: ["Wrong A", "Right", "Wrong B"],
                fact: "A short fact."
            )
        }
    }

    private func session() -> QuizSession {
        QuizSession(topic: .animals, questions: makeQuestions())
    }

    func testFirstTryAwardsOneStar() {
        var quiz = session()
        XCTAssertEqual(quiz.select("Right"), .correctFirstTry)
        XCTAssertEqual(quiz.stars, 1)
        XCTAssertTrue(quiz.solved)
        XCTAssertEqual(quiz.select("Right"), .ignored)
        XCTAssertEqual(quiz.stars, 1)
        XCTAssertEqual(quiz.attemptCount, 1)
    }

    func testWrongThenCorrectAwardsNoStar() {
        var quiz = session()
        XCTAssertEqual(quiz.select("Wrong A"), .incorrect)
        XCTAssertEqual(quiz.stars, 0)
        XCTAssertEqual(quiz.select("Right"), .correctAfterRetry)
        XCTAssertEqual(quiz.stars, 0)
        XCTAssertTrue(quiz.solved)
        XCTAssertEqual(quiz.attemptCount, 2)
    }

    func testRepeatedWrongChoiceIsIgnored() {
        var quiz = session()
        XCTAssertEqual(quiz.select("Wrong A"), .incorrect)
        XCTAssertEqual(quiz.select("Wrong A"), .ignored)
        XCTAssertEqual(quiz.attemptCount, 1)
        XCTAssertEqual(quiz.stars, 0)
        XCTAssertFalse(quiz.solved)
    }

    func testInvalidChoiceIsIgnored() {
        var quiz = session()
        XCTAssertEqual(quiz.select("Banana"), .ignored)
        XCTAssertEqual(quiz.attemptCount, 0)
        XCTAssertEqual(quiz.stars, 0)
        XCTAssertEqual(quiz.advance(), .blocked)
        XCTAssertEqual(quiz.index, 0)
    }

    func testUnansweredQuestionCannotBeSkipped() {
        var quiz = session()
        XCTAssertEqual(quiz.advance(), .blocked)
        XCTAssertEqual(quiz.index, 0)
        XCTAssertFalse(quiz.completed)
    }

    func testAdvanceClearsAttempts() {
        var quiz = session()
        _ = quiz.select("Wrong B")
        _ = quiz.select("Right")
        XCTAssertEqual(quiz.advance(), .nextQuestion)
        XCTAssertEqual(quiz.index, 1)
        XCTAssertTrue(quiz.wrongChoices.isEmpty)
        XCTAssertEqual(quiz.attemptCount, 0)
        XCTAssertFalse(quiz.solved)
        XCTAssertEqual(quiz.stars, 0)
    }

    func testFiveQuestionCompletionCountsOnlyFirstTries() {
        var quiz = session()
        var firstTries = 0
        for index in 0..<5 {
            if index.isMultiple(of: 2) {
                XCTAssertEqual(quiz.select("Right"), .correctFirstTry)
                firstTries += 1
            } else {
                XCTAssertEqual(quiz.select("Wrong A"), .incorrect)
                XCTAssertEqual(quiz.select("Right"), .correctAfterRetry)
            }
            let result = quiz.advance()
            if index < 4 {
                XCTAssertEqual(result, .nextQuestion)
            } else {
                XCTAssertEqual(result, .finished)
            }
        }
        XCTAssertTrue(quiz.completed)
        XCTAssertEqual(quiz.stars, firstTries)
        XCTAssertEqual(quiz.stars, 3)
        XCTAssertEqual(quiz.select("Right"), .ignored)
        XCTAssertEqual(quiz.advance(), .blocked)
    }

    func testEncouragementFollowsStarCount() {
        var quiz = session()
        XCTAssertEqual(quiz.encouragement, "You finished the adventure. Trying again will help these pictures stick.")
        _ = quiz.select("Right")
        XCTAssertEqual(quiz.encouragement, "You kept trying, and that is how we learn.")
    }
}
