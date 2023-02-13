//
//  GameService.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 03.02.2023.
//

import Foundation

final class GameService {
    
    private let networkClient: NetworkService
    
    init(networkClient: NetworkService) {
        
        self.networkClient = networkClient
    }
    
    func fetchCateogires() async -> [Category] {
        
        let result: Result<CategoriesDTO, Error> = await networkClient.fetch(path: "categories")
        
        switch result {
        case let .success(response):
            
            var categories: [Category] = []
            
            
            for value in provideAllCategories(dto: response) {
                
                let category = Category(
                    name: value.capitalized.replacingOccurrences(of: "_", with: " "),
                    value: value
                )
                
                categories.append(category)
            }
                        
            return categories
        case let .failure(error):
         
            print(error)
            return []
        }
    }
    
    func fetchQuestions(
        for categories: [String],
        and difficulty: Difficulties,
        limit: Int
    ) async -> [Question] {
        
        let categoriesQuery = categories.joined(separator: ",")
        let path = "questions?categories=\(categoriesQuery)&limit=\(limit)&\(Constants.region)&difficulty=\(difficulty)"
        
        let result: Result<[QuestionDTO], Error> = await networkClient.fetch(path: path)
        
        switch result {
        case let .success(questionDtos):
            
            var questions: [Question] = []
                
            for questionDto in questionDtos {
                
                var answers: [Question.Answer] = []
                
                for answerDto in questionDto.incorrectAnswers {
                    
                    let answer = Question.Answer(
                        id: UUID().uuidString,
                        value: answerDto,
                        isCorrect: false
                    )
                    
                    answers.append(answer)
                }
                
                let correctAnswer = Question.Answer(
                    id: UUID().uuidString,
                    value: questionDto.correctAnswer,
                    isCorrect: true
                )
                
                answers.append(correctAnswer)
                
                let question = Question(
                    text: questionDto.question,
                    category: questionDto.category,
                    answers: answers.shuffled()
                )
                
                questions.append(question)
            }
            
            return questions
        case let .failure(error):
            
            print(error)
            return []
        }
    }
}

// MARK: - Cateogires helper

private extension GameService {
    
    func provideAllCategories(dto: CategoriesDTO) -> [String] {
            
        var allCategories: [String] = []
            
        allCategories.append(contentsOf: dto.artsAndLiterarature)
        allCategories.append(contentsOf: dto.filmAndTv)
        allCategories.append(contentsOf: dto.foodAndDrink)
        allCategories.append(contentsOf: dto.generalKnowledge)
        allCategories.append(contentsOf: dto.geography)
        allCategories.append(contentsOf: dto.history)
        allCategories.append(contentsOf: dto.music)
        allCategories.append(contentsOf: dto.science)
        allCategories.append(contentsOf: dto.societyAndCulture)
        allCategories.append(contentsOf: dto.sportAndLeisure)
            
        return allCategories
    }
}

// MARK: - Constants

private extension GameService {
    
    enum Constants {
        
        static let region: String = "region=CZ"
    }
}
