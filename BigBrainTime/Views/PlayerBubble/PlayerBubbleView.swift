//
//  PlayerBubbleView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 31.01.2023.
//

import SwiftUI

struct PlayerBubbleView: View {
    
    let name: String
    let score: Int?
    
    let highlited: Bool
    let canBeDeleted: Bool
    
    let onTap: () -> Void
    
    var body: some View {
         
        ZStack(alignment: .topTrailing) {
            
            VStack {
                
                Circle()
                    .foregroundColor(Color.Shared.playerBubble)
                    .background(content: {
                        
                        if highlited {
                            
                            Circle()
                                .foregroundColor(Color.Shared.secondary)
                                .scaleEffect(1.15)
                        }
                    })
                    .overlay {
                        Text(String(name.prefix(1).uppercased()))
                            .font(.Shared.playerBubbleFont)
                    }
                
                Text(name)
                    .foregroundColor(.white)
                    .font(.Shared.playerName)
                
                if score != nil {
                    
                    Text(String(score!))
                        .foregroundColor(.white)
                        .font(.Shared.playerName)
                }
            }
            
            if canBeDeleted {
                
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .overlay(content: {
                        
                        Text("-")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    })
                    .onTapGesture {
                        
                        onTap()
                    }
            }
        }
    }
}
