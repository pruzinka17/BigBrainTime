//
//  AddPlayerButtonStyle.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 27.01.2023.
//

import SwiftUI

struct AddPlayerButtonStyle: ButtonStyle {
    
    var isInputValid: Bool
    var isLobbyFull: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .foregroundColor(.black)
            .fontWeight(.bold)
            .opacity(isInputValid ? 1 : 0.3)
            .disabled(isInputValid)
    }
}
