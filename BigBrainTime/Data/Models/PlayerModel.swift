//
//  PlayerModel.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 03.02.2023.
//

import Foundation

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
