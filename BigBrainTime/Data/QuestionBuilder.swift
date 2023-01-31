//
//  QuestionBuilder.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 26.01.2023.
//

import Foundation
import SwiftUI

struct questionFetched: Codable {
    
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
}

final class QuestionsBuilder {
    
    var questions: [Question] = []
    var results: [questionFetched] = []
    
    func fetch() -> [Question] {
        
        guard let url = URL(string: "https://the-trivia-baasdnsjnaw.com/api/questions?limit=20")
        else {
            print("invalid url")
            return []
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let response = try? JSONDecoder().decode([questionFetched].self, from: data) {
                    DispatchQueue.main.async {
                        self.results = response
                    }
                    return
                }
            }
        }.resume()
        
        var answers: [Question.Answer] = []
        
        for result in results {
            
            for incorrectAnswer in result.incorrectAnswers {
                
                answers.append(Question.Answer(id: UUID().uuidString, value: incorrectAnswer, isCorrect: false))
            }
            answers.append(Question.Answer(id: UUID().uuidString, value: result.correctAnswer, isCorrect: true))
            
            questions.append(Question(text: result.question, answers: answers))
        }
        
        return questions
    }
}
