import Foundation
struct TarotCardResponse: Codable {
    static func format() -> String {
        Self(cardName: "random card name", cardDescription: "interpretation").json()
    }
 
    let cardName: String
    let cardDescription: String
}

struct SituationResponse: Codable {
    static func format() -> String {
        Self(generatedSituation: "Generated situation", variants: ["variant one", "variant two"]).json()
    }
 
    let generatedSituation: String
    let variants: [String]
}

struct CharacterResponse: Codable {
    static func format() -> String {
        Self(characteristics: "emotional characteristics and advantages").json()
    }
 
    let characteristics: String
}

struct CastomQuestionResponse: Codable {
    static func format() -> String {
        Self(answer: "gpt answer for the question").json()
    }
 
    let answer: String
}

struct QuizKnowYourselfResponse: Codable {
    static func format() -> String {
        Self(generatedQuestion: "Generated question by gpt",
             variants: ["variant of answer one", "variant of answer two", "other variants..."]).json()
    }
 
    let generatedQuestion: String
    let variants: [String]
}
