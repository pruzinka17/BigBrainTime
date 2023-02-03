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

enum Difficulties: String, CaseIterable {
    
    case Easy
    case Medium
    case Hard
}
