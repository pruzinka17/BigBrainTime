//
//  QuestionsDTO.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 04.02.2023.
//

import Foundation

struct QuestionDTO: Codable {
    
    let category: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    let question: String
    
    enum CodingsKeys: String, CodingKey {
        
        case category = "category"
        case correctAnswer = "correctAnswer"
        case incorrectAnswers = "incorrectAnswers"
        case question = "question"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingsKeys.self)
        
        category = try container.decode(String.self, forKey: .category)
        correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)
        question = try container.decode(String.self, forKey: .question)
        
    }
}
