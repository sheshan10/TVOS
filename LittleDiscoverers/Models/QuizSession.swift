import Foundation

struct QuizSession: Equatable {
    let topic: TopicID
    let questions: [Question]
    private(set) var index: Int
    private(set) var stars: Int
    private(set) var wrongChoices: Set<String>
    private(set) var solved: Bool
    private(set) var attemptCount: Int
    private(set) var completed: Bool
    private(set) var resultCommitted: Bool

    init(topic: TopicID, questions: [Question]) {
        self.topic = topic
        self.questions = questions
        self.index = 0
        self.stars = 0
        self.wrongChoices = []
        self.solved = false
        self.attemptCount = 0
        self.completed = false
        self.resultCommitted = false
    }

    var currentQuestion: Question? {
        guard !completed, questions.indices.contains(index) else { return nil }
        return questions[index]
    }

    var pictureNumber: Int {
        min(index + 1, max(questions.count, 1))
    }

    var solvedPictureCount: Int {
        if completed { return questions.count }
        return index + (solved ? 1 : 0)
    }

    var canAdvance: Bool {
        solved && !completed
    }

    enum SelectionResult: Equatable {
        case correctFirstTry
        case correctAfterRetry
        case incorrect
        case ignored
    }

    enum AdvanceResult: Equatable {
        case blocked
        case nextQuestion
        case finished
    }

    mutating func select(_ choice: String) -> SelectionResult {
        guard !completed, !solved, let question = currentQuestion else { return .ignored }
        guard question.choices.contains(choice) else { return .ignored }
        guard !wrongChoices.contains(choice) else { return .ignored }

        attemptCount += 1
        if choice == question.correctAnswer {
            solved = true
            if attemptCount == 1 {
                stars += 1
                return .correctFirstTry
            }
            return .correctAfterRetry
        }

        wrongChoices.insert(choice)
        return .incorrect
    }

    mutating func advance() -> AdvanceResult {
        guard solved, !completed else { return .blocked }
        if index + 1 >= questions.count {
            completed = true
            return .finished
        }
        index += 1
        wrongChoices = []
        solved = false
        attemptCount = 0
        return .nextQuestion
    }

    mutating func markResultCommitted() {
        resultCommitted = true
    }

    var encouragement: String {
        switch stars {
        case 5:
            return "You knew every picture on the first try."
        case 3, 4:
            return "You are becoming a careful explorer."
        case 1, 2:
            return "You kept trying, and that is how we learn."
        default:
            return "You finished the adventure. Trying again will help these pictures stick."
        }
    }
}
