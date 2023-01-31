//
//  PlayerTabView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 30.01.2023.
//

import SwiftUI

struct PlayerTabView: View {
    
    let namespace: Namespace.ID
    let name: String
    let score: Int
    let isCurrentlyPlaying: Bool
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    
    var body: some View {
         
        RoundedRectangle(cornerRadius: 10)
            .frame(width: itemWidth, height: itemHeight)
            .overlay {
                
                VStack {
                    
                    Text(name)
                        .font(.Shared.playerName)
                        .foregroundColor(.white)
                        .animation(.default, value: score)
                    
                    Text("\(score)")
                        .font(.Shared.playerScore)
                        .foregroundColor(.white)
                        .animation(.default, value: score)
                    
                }
            }
            .foregroundColor(.clear)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("playertab-color"))
                    .matchedGeometryEffect(id: "background", in: namespace, isSource: isCurrentlyPlaying)
                    .animation(.default, value: isCurrentlyPlaying)
            }
    }
}
