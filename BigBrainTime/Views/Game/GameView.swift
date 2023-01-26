//
//  GameView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 26.01.2023.
//

import SwiftUI

struct GameView: View {
    
    @Environment(\.dismiss) var dismissCurrentView
    
    let game: Game
    
    var body: some View {
        
        ZStack {
            
            Color.cyan
                .ignoresSafeArea()
            
            VStack {
                
                ForEach(game.players) { player in
                    
                    Text(player.name)
                }
                
                Button {
                    
                    dismissCurrentView()
                } label: {
                    
                    Label("", systemImage: "return")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                .padding()
            }
            
            
            
        }
    }
}

//struct GameView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        GameView()
//    }
//}
