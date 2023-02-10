//
//  EndGameViewPresenter.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 10.02.2023.
//

import Foundation

final class EndGameViewPresenter: ObservableObject {
    
    @Published var viewModel: EndGameViewModel
    
    init() {
        
        self.viewModel = EndGameViewModel(averageScore: 0, maxScore: 0, players: [])
    }
}

extension EndGameViewPresenter {
    
    func Present(context: EndGameContext) {
        
        generateView(context: context)
    }
}

private extension EndGameViewPresenter {
    
    func generateView(context: EndGameContext) {
        
        let game = context.game
        let playerAnswers = context.playerAnswers
        
        let playerScores = context.game.players.map( { $0.score } )
        let totalScore = playerScores.reduce(0, +)
        let average = totalScore / context.game.players.count
        let maxScore = context.game.questions.count * 100
        
        var model: EndGameViewModel = EndGameViewModel(averageScore: average, maxScore: maxScore, players: [])
        
        for player in game.players {
            
            var questions: [EndGameViewModel.Player.Question] = []
            
            for question in game.questions {
                
                let correctAnswer = question.answers.first(where: { $0.isCorrect == true })?.value
                let text = question.text
                var playerAnswer = ""
                
                for (key, value) in playerAnswers {
                    
                    if key == player.id {
                        
                        for answer in question.answers {
                            
                            if value == answer.id {
                                
                                playerAnswer = answer.value
                            }
                        }
                    }
                }
                
                questions.append(EndGameViewModel.Player.Question(text: text, correct: correctAnswer ?? "null", value: playerAnswer))
            }
            
            model.players.append(EndGameViewModel.Player(name: player.name, score: player.score, questions: questions, answersShown: false))
        }
        
        viewModel = model
    }
}
