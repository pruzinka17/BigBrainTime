//
//  MainMenuButtonStyle.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 25.01.2023.
//

import SwiftUI

struct MainMenuButtonStyle: ButtonStyle {
    
    let width: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .frame(width: width)
            .foregroundColor(.white)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray)
            }
    }
}
