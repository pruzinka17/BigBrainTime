//
//  EndGameViewModel.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 10.02.2023.
//

import Foundation

struct EndGameViewModel {
    
    let averageScore: Int
    let maxScore: Int
    
    var players: [Player]
    
    struct Player {
        
        let name: String
        let score: Int
        let questions: [Question]
        var answersShown: Bool
        
        struct Question {
            
            let text: String
            let correct: String
            let value: String
        }
    }
}
