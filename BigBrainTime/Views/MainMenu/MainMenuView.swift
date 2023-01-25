//
//  MainMenuView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 25.01.2023.
//

import SwiftUI

struct MainMenuView: View {
    
    let fonts = Fonts()
    
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
    }
}

//MARK: - MainMenu methods

private extension MainMenuView {
    
    @ViewBuilder func makeTitle() -> some View {
        
        HStack {
                    
            Text("BIG\nBRAIN\nTIME")
                .font(fonts.logoFont())
        }
    }
    
    @ViewBuilder func makeButtons() -> some View {
        
        HStack {
            
            Spacer()
            
            Button("New Game") {
                
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
