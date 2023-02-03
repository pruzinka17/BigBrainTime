//
//  QuestionBuilder.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 26.01.2023.
//

import Foundation
import SwiftUI

final class QuestionsBuilder {
    
    func buildQuestions() -> [Question] {
        
        let test: [Question.Answer] = [
            Question.Answer(id: UUID().uuidString, value: "nevim", isCorrect: false),
            Question.Answer(id: UUID().uuidString, value: "jo", isCorrect: false),
            Question.Answer(id: UUID().uuidString, value: "cau", isCorrect: true),
            Question.Answer(id: UUID().uuidString, value: "fakt nevim", isCorrect: false)
        ]
        
        let questions: [Question] = [
            Question(text: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam posuere lacus quis dolor. Nunc tincidunt ante vitae massa.", category: "Science", answers: test.shuffled()),
            Question(text: "Etiam posuere lacus quis dolor. Aenean id metus id velit ullamcorper pulvinar. Nullam eget nisl. Pellentesque arcu. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", category: "Biology", answers: test.shuffled()),
            Question(text: "Etiam ligula pede, sagittis quis, interdum ultricies, scelerisque eu. Quisque tincidunt scelerisque libero.", category: "General Knowledge", answers: test.shuffled()),
            Question(text: "Duis risus. In enim a arcu imperdiet malesuada. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.", category: "Music", answers: test.shuffled())
        ]
        
        return questions
    }
}
