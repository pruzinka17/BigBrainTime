//
//  GameSetupPresenter.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 06.02.2023.
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

final class GameSetupPresenter: ObservableObject {
    
    private let gameService: GameService
    
    @Published var viewModel: GameSetupViewModel
    @Published var game: Game?
    
    init(gameService: GameService) {
        
        self.gameService = gameService
        
        self.viewModel = GameSetupViewModel(
            currentPlayerName: "",
            playerNames: [],
            isLoadingCategories: false,
            categories: [],
            selectedCategories: [],
            numberOfQuestions: Question.questionLimit.lowerBound,
            selectedDifficulty: .medium,
            isGeneratingGame: false
        )
        
        self.game = nil
    }
}

extension GameSetupPresenter {
    
    //MARK: - fetch questions
    
    func generate(
        playerNames: [String],
        categories: [String],
        difficulty: Difficulties,
        limit: Int
    ) async {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.viewModel.isGeneratingGame = true
        }
        
        let questions = await gameService.fetchQuestions(
            for: categories,
            and: difficulty,
            limit: limit
        )
        
        let players = playerNames.map { Player(id: UUID().uuidString, name: $0) }
        
        DispatchQueue.main.async { [weak self] in
        
            self?.game = Game(questions: questions, players: players)
            self?.viewModel.isGeneratingGame = false
        }
    }
    
    //MARK: - fetch categories
    
    func fetchCategories() async {
        
        DispatchQueue.main.async { [weak self] in
         
            self?.viewModel.isLoadingCategories = true
        }

        let categories = await gameService.fetchCateogires()
        
        DispatchQueue.main.async { [weak self] in
            
            self?.viewModel.categories = categories
            self?.viewModel.isLoadingCategories = false
        }
    }
    
    // MARK: - Player functions
        
    func addPlayer() {
        
        guard !viewModel.currentPlayerName.isEmpty && !viewModel.playerNames.contains(viewModel.currentPlayerName) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            
            self?.viewModel.playerNames.append((self?.viewModel.currentPlayerName)!)
            self?.viewModel.currentPlayerName = ""
        }
    }
    
    func removePlayer(name: String) {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.viewModel.playerNames.removeAll { $0 == name }
        }
    }
    
    //MARK: - Category functions
    
    func handleCategorySelection(_ value: String) {
        
        switch isCategorySelected(value) {
        case true:
            
            DispatchQueue.main.async { [weak self] in
                
                self?.viewModel.selectedCategories.removeAll(where: { $0 == value } )
            }
        case false:
            
            DispatchQueue.main.async { [weak self] in
                
                self?.viewModel.selectedCategories.append(value)
            }
        }
    }
    
    func isCategorySelected(_ value: String) -> Bool {
        
        return viewModel.selectedCategories.contains(value)
    }
    
    //MARK: - Difficulty functions
    
    func isDifficultySelected(difficulty: Difficulties) -> Bool {
        
        return difficulty == viewModel.selectedDifficulty
    }
    
    func selectDificulty(difficulty: Difficulties) {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.viewModel.selectedDifficulty = difficulty
        }
    }
    
    //MARK: - generate game
    
    func generateGame() async {
        
        await generate(
            playerNames: viewModel.playerNames,
            categories: viewModel.selectedCategories,
            difficulty: viewModel.selectedDifficulty,
            limit: Int(viewModel.numberOfQuestions)
        )
    }
}
