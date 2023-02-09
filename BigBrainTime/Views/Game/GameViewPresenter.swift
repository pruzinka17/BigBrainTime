//
//  GameViewPresenter.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 07.02.2023.
//

import Foundation

final class GameViewPresenter: ObservableObject {
    
    private let game: Game
    
    private var currentQuestionIndex: Int
    private var currentPlayerIndex: Int
    private var playersAnswers: [String: String]
    private var gameFinished: Bool
    
    @Published var viewModel: GameViewModel
    
    init(game: Game) {
        
        self.game = game
        self.currentQuestionIndex = 0
        self.currentPlayerIndex = 0
        self.playersAnswers = [:]
        self.gameFinished = false
        
        self.viewModel = GameViewModel(
            progress: "",
            currentQuestion: GameViewModel.Question(category: "", text: ""),
            answers: [],
            players: [],
            showEndGame: false
        )
    }
}

// MARK: - Public interface

extension GameViewPresenter {
    
    func present() {
        
        guard !gameFinished else {
            return
        }
        
        updateView()
    }
    
    func handleAnswer(for answerId: String) {
        
        let currentPlayer = game.players[currentPlayerIndex]
        let currentQuestion = game.questions[currentQuestionIndex]
        
        let maxPlayerIndex = game.players.count - 1
        let maxQuestionIndex = game.questions.count - 1
        
        playersAnswers[currentPlayer.id] = answerId
        
        let isLastPlayerToAnswer = currentPlayerIndex == maxPlayerIndex
        let isLastQuestionToAnswer = currentQuestionIndex == maxQuestionIndex
        
        switch isLastPlayerToAnswer {
        case true:
            
            currentPlayerIndex = 0
            
            for player in game.players {
                
                guard
                    let answerId = playersAnswers[player.id],
                    let playerAnswer = currentQuestion.answers.first(where: { $0.id == answerId })
                else {
                    continue
                }
                
                player.score += playerAnswer.isCorrect ? 100 : 0
            }
            
            switch isLastQuestionToAnswer {
            case true:
                
                gameFinished = true
            case false:
                
                currentQuestionIndex += 1
            }
        case false:
            
            currentPlayerIndex += 1
        }
        
        updateView()
    }
}

// MARK: - Update view methods

private extension GameViewPresenter {
    
    func updateView() {
        
        viewModel.progress = "question: \(currentQuestionIndex + 1) / \(game.questions.count)"
        
        updateQuestion()
        updatePlayers()
        
        viewModel.showEndGame = gameFinished
    }
    
    func updateQuestion() {
        
        let currentQuestion = game.questions[currentQuestionIndex]
        
        let question = GameViewModel.Question(
            category: currentQuestion.category,
            text: currentQuestion.text
        )
        
        let answers: [GameViewModel.Answer] = currentQuestion.answers.map { answer in
            
            GameViewModel.Answer(id: answer.id, text: answer.value)
        }
        
        viewModel.currentQuestion = question
        viewModel.answers = answers
    }
    
    func updatePlayers() {
        
        var players: [GameViewModel.Player] = []
        
        for (index, player) in game.players.enumerated() {
            
            let isPlaying = currentPlayerIndex == index
            
            players.append(
                GameViewModel.Player(
                    name: player.name,
                    score: player.score,
                    isPlaying: isPlaying
                )
            )
        }
        
        viewModel.players = players
    }
}
