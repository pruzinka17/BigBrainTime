//
//  GameModels.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 26.01.2023.
//

import Foundation

struct Question {
    
    let text: String
    
    let answers: [Answer]
    
    struct Answer {
        
        let value: String
        let isCorrect: Bool
    }
}

struct Player: Identifiable {
    
    let id: String
    
    let name: String
    
    var score: Int
}

struct Game {
    
    let questions: [Question]
    let players: [Player]
}
