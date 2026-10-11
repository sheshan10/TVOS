import Foundation

enum NarrationScript {
    static func question(_ question: Question) -> String {
        "What is this? The choices are \(spokenList(question.choices))."
    }

    static func retry() -> String {
        "Good try! Choose another answer."
    }

    static func success(_ question: Question) -> String {
        "Well done! This is \(article(for: question.correctAnswer)) \(question.correctAnswer). \(question.fact)"
    }

    static func spokenList(_ items: [String]) -> String {
        switch items.count {
        case 0:
            return ""
        case 1:
            return items[0]
        case 2:
            return "\(items[0]) and \(items[1])"
        default:
            guard let last = items.last else { return "" }
            let head = items.dropLast().joined(separator: ", ")
            return "\(head), and \(last)"
        }
    }

    static func article(for word: String) -> String {
        guard let first = word.lowercased().first else { return "a" }
        return ["a", "e", "i", "o", "u"].contains(first) ? "an" : "a"
    }
}
