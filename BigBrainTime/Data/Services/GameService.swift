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
        
        return []
    }
    
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
