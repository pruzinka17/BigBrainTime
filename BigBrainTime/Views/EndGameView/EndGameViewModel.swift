//
//  EndGameViewModel.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 10.02.2023.
//

import Foundation

struct EndGameViewModel {
    
    var averageScore: Int
    var maxScore: Int
    var players: [Player]
    var gameQuestions: [Question]
    
    struct Player {
        
        let name: String
        let score: Int
        let place: Int
        let questions: [Question]
        
        struct Question {
            
            let text: String
            let correct: String
            let value: String
        }
    }
}
