//
//  QuestionModel.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 03.02.2023.
//

import Foundation

struct Question {
    
    let text: String
    let category: String
    
    let answers: [Answer]
    
    struct Answer: Identifiable {
        
        let id: String
        let value: String
        let isCorrect: Bool
    }
    
    static let questionLimit: ClosedRange<Double> = (2...20)
}
