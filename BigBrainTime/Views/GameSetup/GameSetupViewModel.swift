//
//  GameSetupViewModel.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 15.02.2023.
//

import Foundation

struct GameSetupViewModel {
    
    // MARK: - Player
    
    var currentPlayerName: String
    var playerNames: [String]
    
    // MARK: - Categories
    
    var isLoadingCategories: Bool
    var categories: [Category]
    var selectedCategories: [String]
    
    // MARK: - Questions
    
    var numberOfQuestions: Double
    
    // MARK: - Difficulty
    
    var selectedDifficulty: Difficulties
    
    // MARK: - Game
    
    var isGeneratingGame: Bool
}
