//
//  EndGameView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 03.02.2023.
//

import SwiftUI

struct EndGameView: View {
    
    let playerScores: [Player]
    
    var body: some View {
        
        ZStack {
            
            Color.Shared.background
                .ignoresSafeArea()
            
            VStack {
                
                ScrollView(showsIndicators: false) {
                    
                    HStack {
                        
                        Button {
                            
                            //dismissCurrentView()
                        } label: {
                            
                            Label("", systemImage: "return")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                    
                    List {
                        
                        ForEach(playerScores) { playerScore in
                            
                            HStack {
                                Text(playerScore.name)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("\(playerScore.score)")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .listRowBackground(Color.Shared.background)
                        }
                    }
                    .listStyle(.plain)
                    .padding()
                }
            }
        }
    }
}
//
//struct EndGameView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//    }
//}
