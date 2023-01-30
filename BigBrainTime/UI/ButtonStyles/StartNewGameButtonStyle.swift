//
//  StartNewGameButtonStyle.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 27.01.2023.
//

import SwiftUI

struct StartNewGameButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .padding()
            .foregroundColor(.black)
            .fontWeight(.bold)
    }
}
