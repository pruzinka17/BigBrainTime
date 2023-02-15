//
//  MainButtonStyle.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 25.01.2023.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    
    let width: CGFloat
    let height: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .font(.Shared.newGameButton)
            .minimumScaleFactor(0.6)
            .frame(width: width, height: height)
            .foregroundColor(.white)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color.Shared.secondary)
            }
    }
}
