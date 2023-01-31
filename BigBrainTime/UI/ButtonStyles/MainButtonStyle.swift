//
//  MainButtonStyle.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 25.01.2023.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    
    let width: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .font(.Shared.newGameButton)
            .frame(width: width)
            .foregroundColor(.white)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("color-secondary"))
            }
    }
}
