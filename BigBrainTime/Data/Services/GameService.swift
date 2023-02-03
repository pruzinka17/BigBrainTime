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
            
            for value in response.artsAndLiterarature {
                
                let category = Category(
                    name: value.capitalized,
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
        
        return []
    }
}
