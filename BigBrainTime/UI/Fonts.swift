//
//  Fonts.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 25.01.2023.
//

import SwiftUI

extension Font {

    struct Shared {
        
        static let logo = Font.system(size: 50, weight: .bold, design: .rounded)
        
        static let gameSetupTitleFont = Font.system(size: 24, weight: .bold, design: .rounded)
        
        static let newGameButton = Font.system(size: 24, weight: .bold, design: .rounded)
        
        static let playerName = Font.system(size: 14, weight: .thin, design: .rounded)
        static let playerScore = Font.system(size: 13, weight: .bold, design: .rounded)
        static let playerBubbleFont = Font.system(size: 23, weight: .bold, design: .rounded)
        static let noPlayers = Font.system(size: 48, weight: .bold, design: .rounded)
        
        static let segmentTitle = Font.system(size: 16, weight: .bold, design: .rounded)
        
        static let question = Font.system(size: 23, weight: .thin, design: .rounded)
        static let answer = Font.system(size: 23, weight: .semibold, design: .rounded)
        static let answerTitle = Font.system(size: 18, weight: .bold, design: .rounded)
        
        static let allQuestionsCategory = Font.system(size: 18, weight: .bold, design: .rounded)
        static let allQuestionsText = Font.system(size: 14, weight: .regular, design: .rounded)
    }
}
