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
        static let newGameButton = Font.system(size: 23, weight: .bold, design: .rounded)
        static let playerName = Font.system(size: 13, weight: .semibold, design: .rounded)
        static let playerScore = Font.system(size: 13, weight: .bold, design: .rounded)
    }
}
