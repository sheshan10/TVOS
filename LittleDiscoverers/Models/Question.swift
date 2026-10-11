import Foundation

struct Question: Codable, Equatable, Identifiable {
    let id: String
    let topic: String
    let imageName: String
    let correctAnswer: String
    let choices: [String]
    let fact: String

    func shufflingChoices() -> Question {
        Question(
            id: id,
            topic: topic,
            imageName: imageName,
            correctAnswer: correctAnswer,
            choices: choices.shuffled(),
            fact: fact
        )
    }
}

struct QuestionBank: Codable, Equatable {
    let questions: [Question]

    func questions(for topic: TopicID, shuffle: Bool) -> [Question] {
        let matching = questions.filter { $0.topic == topic.rawValue }
        guard shuffle else { return matching }
        return matching.shuffled().map { $0.shufflingChoices() }
    }
}

struct ContentProblem: Equatable, Error {
    var messages: [String]

    var summary: String {
        messages.joined(separator: "\n")
    }
}
