import Foundation
import UIKit

enum QuestionBankLoader {
    static let requiredTopics = TopicID.allCases.map(\.rawValue)
    static let questionsPerTopic = 5

    static func loadBundled() -> Result<QuestionBank, ContentProblem> {
        let bundle = Bundle(for: AppBundleMarker.self)
        guard let url = bundle.url(forResource: "questions", withExtension: "json") else {
            return .failure(ContentProblem(messages: ["The question file is missing from the app."]))
        }
        do {
            let data = try Data(contentsOf: url)
            return load(data: data, availableAssets: catalogAssetNames())
        } catch {
            return .failure(ContentProblem(messages: ["The question file could not be read."]))
        }
    }

    static func catalogAssetNames() -> Set<String> {
        let bundle = Bundle(for: AppBundleMarker.self)
        return Set(IllustrationAsset.allCases.map(\.rawValue).filter { name in
            UIImage(named: name, in: bundle, compatibleWith: nil) != nil
        })
    }

    static func load(data: Data, availableAssets: Set<String>) -> Result<QuestionBank, ContentProblem> {
        let bank: QuestionBank
        do {
            bank = try JSONDecoder().decode(QuestionBank.self, from: data)
        } catch {
            return .failure(ContentProblem(messages: ["The question file could not be read as a question bank."]))
        }

        let messages = validate(bank, availableAssets: availableAssets)
        if messages.isEmpty {
            return .success(bank)
        }
        return .failure(ContentProblem(messages: messages))
    }

    static func validate(_ bank: QuestionBank, availableAssets: Set<String>) -> [String] {
        var messages: [String] = []
        var seenIDs = Set<String>()
        var counts: [String: Int] = [:]

        for question in bank.questions {
            let label = question.id.isEmpty ? "(blank id)" : question.id
            if question.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                messages.append("A question is missing its id.")
            } else if !seenIDs.insert(question.id).inserted {
                messages.append("Question id \(question.id) is duplicated.")
            }

            if !requiredTopics.contains(question.topic) {
                messages.append("Question \(label) has an unknown topic.")
            } else {
                counts[question.topic, default: 0] += 1
            }

            if question.imageName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                messages.append("Question \(label) is missing an image name.")
            } else if !availableAssets.contains(question.imageName) {
                messages.append("Question \(label) is missing illustration \(question.imageName).")
            }

            if question.correctAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                messages.append("Question \(label) is missing a correct answer.")
            }
            if question.fact.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                messages.append("Question \(label) is missing an educational fact.")
            }

            if question.choices.count != 3 {
                messages.append("Question \(label) must have exactly three choices.")
            }
            if Set(question.choices).count != question.choices.count || question.choices.contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
                messages.append("Question \(label) must have three distinct, nonempty choices.")
            }
            let matches = question.choices.filter { $0 == question.correctAnswer }.count
            if matches != 1 {
                messages.append("Question \(label) must include its correct answer exactly once.")
            }
        }

        if bank.questions.count != requiredTopics.count * questionsPerTopic {
            messages.append("The question bank must contain exactly 15 questions.")
        }
        for topic in requiredTopics where counts[topic, default: 0] != questionsPerTopic {
            messages.append("Topic \(topic) must contain exactly five questions.")
        }

        return messages
    }
}
