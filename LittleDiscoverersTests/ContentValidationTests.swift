import XCTest
@testable import LittleDiscoverers

final class ContentValidationTests: XCTestCase {
    private let assets = IllustrationAsset.names

    private func question(
        id: String = "animals-cat",
        topic: String = "animals",
        imageName: String = "animal_cat",
        correctAnswer: String = "Cat",
        choices: [String] = ["Dog", "Cat", "Rabbit"],
        fact: String = "Cats are mammals."
    ) -> Question {
        Question(id: id, topic: topic, imageName: imageName, correctAnswer: correctAnswer, choices: choices, fact: fact)
    }

    private func validBank() -> QuestionBank {
        let topics = [
            ("animals", ["Cat", "Dog", "Elephant", "Rabbit", "Fish"], ["animal_cat", "animal_dog", "animal_elephant", "animal_rabbit", "animal_fish"]),
            ("fruits", ["Apple", "Banana", "Orange", "Grapes", "Watermelon"], ["fruit_apple", "fruit_banana", "fruit_orange", "fruit_grapes", "fruit_watermelon"]),
            ("vehicles", ["Car", "Bus", "Train", "Boat", "Airplane"], ["vehicle_car", "vehicle_bus", "vehicle_train", "vehicle_boat", "vehicle_airplane"])
        ]
        var questions: [Question] = []
        for (topic, names, images) in topics {
            for index in names.indices {
                let correct = names[index]
                let other = names[(index + 1) % names.count]
                let third = names[(index + 2) % names.count]
                questions.append(question(
                    id: "\(topic)-\(index)",
                    topic: topic,
                    imageName: images[index],
                    correctAnswer: correct,
                    choices: [other, correct, third],
                    fact: "Fact about \(correct)."
                ))
            }
        }
        return QuestionBank(questions: questions)
    }

    private func data(for bank: QuestionBank) throws -> Data {
        try JSONEncoder().encode(bank)
    }

    func testValidBankPasses() throws {
        let result = QuestionBankLoader.load(data: try data(for: validBank()), availableAssets: assets)
        guard case .success(let bank) = result else {
            return XCTFail("Expected a valid bank")
        }
        XCTAssertEqual(bank.questions.count, 15)
    }

    func testBundledBankAndAssetNamesMatch() throws {
        let bundle = Bundle(for: AppBundleMarker.self)
        let url = try XCTUnwrap(bundle.url(forResource: "questions", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let result = QuestionBankLoader.load(data: data, availableAssets: IllustrationAsset.names)
        guard case .success(let bank) = result else {
            return XCTFail("Bundled questions failed validation")
        }
        let imageNames = Set(bank.questions.map(\.imageName))
        XCTAssertEqual(imageNames, IllustrationAsset.names)
        XCTAssertEqual(Set(bank.questions.map(\.id)).count, 15)
    }

    func testBundledIllustrationsExistInTheAppBundle() throws {
        let present = QuestionBankLoader.catalogAssetNames()
        XCTAssertEqual(present, IllustrationAsset.names)
    }

    func testMalformedJSONIsReported() {
        let result = QuestionBankLoader.load(data: Data("{".utf8), availableAssets: assets)
        guard case .failure(let problem) = result else {
            return XCTFail("Expected failure")
        }
        XCTAssertTrue(problem.summary.contains("could not be read"))
    }

    func testDuplicateIDsAndWrongTopicCountsFail() throws {
        var questions = validBank().questions
        questions[1] = question(id: questions[0].id)
        let result = QuestionBankLoader.load(data: try data(for: QuestionBank(questions: questions)), availableAssets: assets)
        guard case .failure(let problem) = result else {
            return XCTFail("Expected failure")
        }
        XCTAssertTrue(problem.messages.contains { $0.contains("duplicated") })
    }

    func testMissingAssetEmptyFactAndWrongChoiceShapeFail() throws {
        let broken = QuestionBank(questions: [
            question(id: "", fact: "   "),
            question(id: "animals-dog", imageName: "missing_dog", correctAnswer: "Dog", choices: ["Dog", "Dog", ""], fact: "Fact")
        ])
        let messages = QuestionBankLoader.validate(broken, availableAssets: assets)
        XCTAssertTrue(messages.contains { $0.contains("missing its id") })
        XCTAssertTrue(messages.contains { $0.contains("missing an educational fact") })
        XCTAssertTrue(messages.contains { $0.contains("missing illustration") })
        XCTAssertTrue(messages.contains { $0.contains("exactly three choices") || $0.contains("distinct") })
        XCTAssertTrue(messages.contains { $0.contains("exactly 15") })
        XCTAssertTrue(messages.contains { $0.contains("exactly five") })
    }

    func testCorrectAnswerMustAppearOnce() {
        let missing = question(correctAnswer: "Cat", choices: ["Dog", "Fish", "Rabbit"])
        let doubled = question(correctAnswer: "Cat", choices: ["Cat", "Cat", "Dog"])
        let messages = QuestionBankLoader.validate(QuestionBank(questions: [missing, doubled]), availableAssets: assets)
        XCTAssertTrue(messages.contains { $0.contains("exactly once") })
    }
}
