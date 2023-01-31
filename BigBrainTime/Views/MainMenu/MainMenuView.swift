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
        
        GeometryReader { proxy in
            
            ZStack {
                
                Color("background-color")
                    .ignoresSafeArea()
                    
                    VStack {
                        
                        Spacer()
                        
                        makeTitle()
                        
                        Spacer()
                        
                        makeButton(proxy: proxy)
                    }
                    .padding()
            }
            .fullScreenCover(isPresented: $isPresentingGameSetup) {
                
                GameSetupView()
            }
        }
    }
}

//MARK: - MainMenu methods

private extension MainMenuView {
    
    @ViewBuilder func makeTitle() -> some View {
        
        HStack {
                    
            Text(Constants.logoText)
                .font(.Shared.logo)
        }
    }
    
    @ViewBuilder func makeButton(proxy: GeometryProxy) -> some View {
        
        let buttonWidth: CGFloat = proxy.frame(in: .local).width / 2
        
        HStack {
            
            Spacer()
            
            Button(Constants.newGameButtonText) {
                
                isPresentingGameSetup = true
            }
            .font(.Shared.newGameButton)
            .buttonStyle(MainMenuButtonStyle(width: buttonWidth))
            
            Spacer()
        }
    }
}

//MARK: - Constants

private extension MainMenuView {
    
    enum Constants {
        
        static let logoText = "BIG\nBRAIN\nTIME"
        static let newGameButtonText = "New Game"
    }
}

struct MainMenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        MainMenuView()
    }
}
