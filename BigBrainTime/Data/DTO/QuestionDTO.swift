//
//  QuestionsDTO.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 04.02.2023.
//

import Foundation

struct QuestionsDTO: Codable {
    
    let questions: [QuestionDTO]
    
    init(from decoder: Decoder) throws {
        
        var container = try decoder.unkeyedContainer()
        
        let questionWrapper = try container.decode(questionDTOWrapper.self)
        
        self.questions = questionWrapper.questions
    }
}

struct questionDTOWrapper: Codable {
    
    let questions: [QuestionDTO]
}

struct QuestionDTO: Codable {
    
    let category: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    let question: String
    
    enum CodingsKeys: String, CodingKey, CaseIterable {
        
        case category = "category"
        case correctAnswer = "correctAnswer"
        case incorrectAnswers = "incorrectAnswers"
        case question = "question"
    }
}
