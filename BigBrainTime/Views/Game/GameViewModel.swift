//
//  GameViewModel.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 07.02.2023.
//

import Foundation

struct GameViewModel {
    
    var progress: String
    var currentQuestion: Question
    var answers: [Answer]
    var players: [Player]
    
    var showEndGame: Bool
    
    struct Player {
        
        let name: String
        let score: Int
        let isPlaying: Bool
    }
    
    struct Question {
        
        let category: String
        let text: String
    }
    
    struct Answer {
        
        let id: String
        let text: String
    }
}
