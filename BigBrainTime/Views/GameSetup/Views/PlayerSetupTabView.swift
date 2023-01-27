//
//  PlayerSetupTabView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 27.01.2023.
//

import SwiftUI

struct PlayerSetupTabView: View {
    
    let player: Player
    
    let deletePlayer: Bool
    
    let onTap: () -> Void
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 55)
            .overlay {
                
                ZStack {
                    
                    VStack {
                        Text(player.name)
                            .foregroundColor(.white)
                        Text("\(player.score)")
                            .foregroundColor(.white)
                    }
                    
                    if deletePlayer {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(red: 1, green: 0, blue: 0, opacity: 0.4))
                            .overlay {
                                
                                GeometryReader { proxy in
                                    
                                    let frame = proxy.frame(in: .local)
                                    
                                    Path { path in
                                        
                                        path.move(to: CGPoint(x: frame.width - (frame.width - 10), y: frame.height - (frame.height - 10)))
                                        path.addLine(to: CGPoint(x: frame.width - 10, y: frame.height - 10))
                                    }
                                    .stroke(.red, lineWidth: 3)
                                    
                                    Path { path in
                                        
                                        path.move(to: CGPoint(x: frame.width - 10, y: frame.height - (frame.height - 10)))
                                        path.addLine(to: CGPoint(x: frame.width - (frame.width - 10), y: frame.height - 10))
                                    }
                                    .stroke(.red, lineWidth: 2)
                                }
                            }
                    }
                }
            }
            .onTapGesture {
                
                onTap()
            }
    }
}
