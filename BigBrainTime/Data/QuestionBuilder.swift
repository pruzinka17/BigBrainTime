//
//  QuestionBuilder.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 26.01.2023.
//

import Foundation

final class QuestionsBuilder {
    
    func buildQuestions() -> [Question] {
        
        var questions: [Question] = []
        
        var answer: [Question.Answer] = []
        answer.append(Question.Answer(value: "ahoj", isCorrect: false))
        answer.append(Question.Answer(value: "cau", isCorrect: false))
        answer.append(Question.Answer(value: "ne", isCorrect: true))
        answer.append(Question.Answer(value: "hoj", isCorrect: false))
        
        questions.append(Question(text: "question1", answers: answer))
        
        answer.removeAll()
        answer.append(Question.Answer(value: "ne", isCorrect: true))
        answer.append(Question.Answer(value: "ahoj", isCorrect: false))
        answer.append(Question.Answer(value: "cau", isCorrect: false))
        answer.append(Question.Answer(value: "pip", isCorrect: false))
        
        questions.append(Question(text: "question2", answers: answer))
        
        return questions.shuffled()
    }
}
