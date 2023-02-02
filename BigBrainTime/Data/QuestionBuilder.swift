//
//  QuestionBuilder.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 26.01.2023.
//

import Foundation
import SwiftUI

//struct questionFetched: Codable {
//
//    let question: String
//    let correctAnswer: String
//    let incorrectAnswers: [String]
//}

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
    
//    let test: [Question.Answer] = [
//        Question.Answer(id: UUID().uuidString, value: "nevim", isCorrect: false),
//        Question.Answer(id: UUID().uuidString, value: "jo", isCorrect: false),
//        Question.Answer(id: UUID().uuidString, value: "cau", isCorrect: true),
//        Question.Answer(id: UUID().uuidString, value: "fakt nevim", isCorrect: false)
//    ]
//
//    var questions: [Question] = []
//    var results: [questionFetched] = []
//
//    func fetch() -> [Question] {
//
//        questions.append(Question(text: "balls question", answers: test))
//
//        guard let url = URL(string: "https://the-trivia-api.com/api/questions?categories=film_and_tv,food_and_drink,geography&limit=20&region=CZ&difficulty=medium&tags=chemistry,1600s,bodies_of_water,1700's,1950's"
//        )
//        else {
//            print("invalid url")
//            return []
//        }
//
//        let request = URLRequest(url: url)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//
//            if let data = data {
//                if let response = try? JSONDecoder().decode([questionFetched].self, from: data) {
//                    DispatchQueue.main.async {
//                        self.results = response
//                    }
//                    return
//                }
//            }
//        }.resume()
//
//        var answers: [Question.Answer] = []
//
//        for result in results {
//
//            for incorrectAnswer in result.incorrectAnswers {
//
//                answers.append(Question.Answer(id: UUID().uuidString, value: incorrectAnswer, isCorrect: false))
//            }
//            answers.append(Question.Answer(id: UUID().uuidString, value: result.correctAnswer, isCorrect: true))
//
//            questions.append(Question(text: result.question, answers: answers))
//        }
//
//        return questions
//    }
}
