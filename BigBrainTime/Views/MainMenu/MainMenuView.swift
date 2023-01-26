//
//  MainMenuView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 25.01.2023.
//

import SwiftUI

struct MainMenuView: View {
    
    @State var isPresentingGameSetup = false
    
    var body: some View {
        
        ZStack {
            
            Color.cyan
            
            VStack {
                
                Spacer()
                
                makeTitle()
                
                Spacer()
                
                makeButtons()
                
                Spacer()
            }
            .padding()
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $isPresentingGameSetup) {
            
            GameSetupView()
        }
    }
}

//MARK: - MainMenu methods

private extension MainMenuView {
    
    @ViewBuilder func makeTitle() -> some View {
        
        HStack {
                    
            Text("BIG\nBRAIN\nTIME")
                .font(.Shared.logo)
        }
    }
    
    @ViewBuilder func makeButtons() -> some View {
        
        HStack {
            
            Spacer()
            
            Button("New Game") {
                
                isPresentingGameSetup = true
            }
            .buttonStyle(MainMenuButtonStyle())
            
            Spacer()
            
            Button("settings") {
                
            }
            .buttonStyle(MainMenuButtonStyle())
            
            Spacer()
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        MainMenuView()
    }
}
