import XCTest

final class NavigationUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
    }

    func testHomeTopicsAndQuizStartWithExpectedFocus() {
        let explore = app.buttons["letsExploreButton"]
        XCTAssertTrue(explore.waitForExistence(timeout: 5))
        XCTAssertTrue(explore.hasFocus)

        XCUIRemote.shared.press(.select)

        let animals = app.buttons["topic_animals"]
        XCTAssertTrue(animals.waitForExistence(timeout: 5))
        XCTAssertTrue(animals.hasFocus)

        XCUIRemote.shared.press(.select)

        let firstAnswer = app.buttons["answer_Dog"]
        XCTAssertTrue(firstAnswer.waitForExistence(timeout: 5))
        XCTAssertTrue(firstAnswer.hasFocus)
        XCTAssertTrue(app.staticTexts["What is this?"].exists)
        XCTAssertFalse(app.buttons["nextPictureButton"].isEnabled)
        XCTAssertEqual(element("pictureProgress").label, "Picture 1 of 5")
    }

    func testWrongAnswerDisablesChoiceAndMovesFocus() {
        openAnimalsQuiz()
        XCUIRemote.shared.press(.select)

        XCTAssertTrue(feedbackContains("Good try"))
        XCTAssertFalse(app.buttons["answer_Dog"].isEnabled)
        XCTAssertTrue(app.buttons["answer_Cat"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["answer_Cat"].hasFocus)
        XCTAssertTrue(element("starsLabel").label.contains("0 of 5"))
    }

    func testFirstCorrectAnswerMovesFocusToNextPicture() {
        openAnimalsQuiz()
        XCUIRemote.shared.press(.down)
        XCUIRemote.shared.press(.select)

        XCTAssertTrue(feedbackContains("Well done"))
        let next = app.buttons["nextPictureButton"]
        XCTAssertTrue(next.waitForExistence(timeout: 3))
        XCTAssertTrue(next.isEnabled)
        XCTAssertTrue(next.hasFocus)
        XCTAssertTrue(element("starsLabel").label.contains("1 of 5"))
    }

    func testLeaveConfirmationCanBeCancelled() {
        openAnimalsQuiz()
        XCUIRemote.shared.press(.menu)

        let keepPlaying = app.buttons["Keep Playing"]
        XCTAssertTrue(keepPlaying.waitForExistence(timeout: 4))
        if keepPlaying.hasFocus {
            XCUIRemote.shared.press(.select)
        } else {
            _ = XCTWaiter.wait(for: [XCTestExpectation(description: "menu gap")], timeout: 0.6)
            XCUIRemote.shared.press(.menu)
        }

        XCTAssertTrue(app.staticTexts["What is this?"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.buttons["Keep Playing"].exists)
        XCTAssertTrue(app.buttons["answer_Dog"].exists)
    }

    func testFinishQuizThenPlayAgainAndSeeSavedScore() {
        openAnimalsQuiz()
        for picture in 1...5 {
            let progress = element("pictureProgress")
            XCTAssertTrue(progress.waitForExistence(timeout: 4))
            XCTAssertEqual(progress.label, "Picture \(picture) of 5")
            XCUIRemote.shared.press(.down)
            XCUIRemote.shared.press(.select)
            XCTAssertTrue(app.buttons["nextPictureButton"].waitForExistence(timeout: 3))
            XCUIRemote.shared.press(.select)
        }

        XCTAssertTrue(app.staticTexts["Wonderful exploring!"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["playAgainButton"].hasFocus)
        XCTAssertTrue(elementContaining("This adventure: 5 of 5 first-try stars"))

        XCUIRemote.shared.press(.right)
        XCUIRemote.shared.press(.right)
        XCUIRemote.shared.press(.select)

        let grownUps = app.buttons["grownUpsButton"]
        XCTAssertTrue(grownUps.waitForExistence(timeout: 4))
        var guardMoves = 0
        while !grownUps.hasFocus && guardMoves < 4 {
            XCUIRemote.shared.press(.right)
            guardMoves += 1
        }
        XCUIRemote.shared.press(.select)

        XCTAssertTrue(app.staticTexts["For Grown-ups"].waitForExistence(timeout: 4))
        XCTAssertTrue(elementContaining("Finished adventures: 1"))
        XCTAssertTrue(elementContaining("Best: 5 of 5"))
    }

    private func openAnimalsQuiz() {
        XCTAssertTrue(app.buttons["letsExploreButton"].waitForExistence(timeout: 5))
        XCUIRemote.shared.press(.select)
        XCTAssertTrue(app.buttons["topic_animals"].waitForExistence(timeout: 5))
        XCUIRemote.shared.press(.select)
        XCTAssertTrue(app.buttons["answer_Dog"].waitForExistence(timeout: 5))
    }

    private func element(_ identifier: String) -> XCUIElement {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        return app.descendants(matching: .any).matching(predicate).firstMatch
    }

    private func elementContaining(_ snippet: String) -> Bool {
        let predicate = NSPredicate(format: "label CONTAINS %@", snippet)
        return app.descendants(matching: .any).matching(predicate).firstMatch.waitForExistence(timeout: 4)
    }

    private func feedbackContains(_ snippet: String) -> Bool {
        let other = app.otherElements["feedbackText"]
        if other.waitForExistence(timeout: 3), other.label.contains(snippet) {
            return true
        }
        let text = app.staticTexts["feedbackText"]
        return text.waitForExistence(timeout: 3) && text.label.contains(snippet)
    }
}
