//
//  GameModels.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 26.01.2023.
//

import Foundation

final class Game {
    
    let questions: [Question]
    let players: [Player]
    
    init(questions: [Question], players: [Player]) {
        
        self.questions = questions
        self.players = players
    }
}

final class Player: Identifiable {
    
    let id: String
    let name: String
    
    var score: Int
    
    init(id: String, name: String) {
        
        self.id = id
        self.name = name
        self.score = 0
    }
}

struct Question {
    
    let text: String
    let category: String
    
    let answers: [Answer]
    
    struct Answer: Identifiable {
        
        let id: String
        let value: String
        let isCorrect: Bool
    }
}
