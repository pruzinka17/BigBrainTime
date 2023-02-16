//
//  EndGameViewPresenter.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 10.02.2023.
//

import Foundation

final class EndGameViewPresenter: ObservableObject {
    
    private let context: EndGameContext
    
    @Published var viewModel: EndGameViewModel
    
    init(context: EndGameContext) {
        
        self.context = context
        self.viewModel = EndGameViewModel(averageScore: 0, maxScore: 0, players: [], gameQuestions: [])
    }
}

extension EndGameViewPresenter {
    
    func present() {
        
        updateView()
    }
}

private extension EndGameViewPresenter {
    
    func updateView() {
        
        let game = context.game
        let playerAnswers = context.playerAnswers
        
        let allPlayerScores = game.players.map( { $0.score } )
        let totalScore = allPlayerScores.reduce(0, +)
        let averageScore = totalScore / game.players.count
        let maxScore = game.questions.count * 100
        
        var players: [EndGameViewModel.Player] = []
        
        var playerScores: [Int] = []
        
        for score in allPlayerScores {
            
            if !playerScores.contains(score) {
                playerScores.append(score)
            }
        }
        
        playerScores = playerScores.sorted(by: { $0 > $1 } )
        
        for (playerId, anwswerIds) in playerAnswers {
            
            guard
                let gamePlayer = game.players.first(where: { $0.id == playerId })
            else {
                continue
            }
            
            var playerQuestions: [EndGameViewModel.Player.Question] = []
            
            for answerId in anwswerIds {
                
                let question = game.questions.first(where: { question in
                    
                    return question.answers.contains(where: { $0.id == answerId })
                })!
                
                guard
                    let correctAnswer = question.answers.first(where: { $0.isCorrect })
                else { continue }
                
                guard
                    let playerAnswer = question.answers.first(where: { $0.id == answerId })
                else { continue }
                
                if playerAnswer.value != correctAnswer.value {
                    
                    let playerQuestion = EndGameViewModel.Player.Question(
                        text: question.text,
                        correct: correctAnswer.value,
                        value: playerAnswer.value
                    )
                    
                    playerQuestions.append(playerQuestion)
                } else {
                    continue
                }
            }
            
            guard
             let playerPlace = playerScores.firstIndex(where: { $0 == gamePlayer.score } )
            else {
                continue
            }
            
            let player = EndGameViewModel.Player(
                name: gamePlayer.name,
                score: gamePlayer.score,
                place: playerPlace + 1,
                questions: playerQuestions
            )
            
            players.append(player)
        }
        
        viewModel.maxScore = maxScore
        viewModel.averageScore = averageScore
        viewModel.players = players
        viewModel.gameQuestions = game.questions
    }
}
