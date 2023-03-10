//
//  MainMenuView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 25.01.2023.
//

import SwiftUI

struct MainMenuView: View {
    
    private let gameService: GameService
    
    @State var isPresentingGameSetup = false
    
    init(gameService: GameService) {
        
        self.gameService = gameService
    }
    
    var body: some View {
        
        GeometryReader { proxy in
            
            ZStack {
                
                Color.Shared.background
                    .ignoresSafeArea()
                    
                    VStack {
                        
                        Spacer()
                        
                        makeTitle(proxy: proxy)
                        
                        Spacer()
                        
                        makeButton(proxy: proxy)
                    }
                    .padding()
            }
            .fullScreenCover(isPresented: $isPresentingGameSetup) {
                
                GameSetupView(gameService: gameService)
            }
        }
    }
}

//MARK: - MainMenu methods

private extension MainMenuView {
    
    @ViewBuilder func makeTitle(proxy: GeometryProxy) -> some View {
        
        let frame = proxy.frame(in: .local)
        
        HStack {
            
            Rectangle()
                .foregroundColor(Color.Shared.secondary)
                .frame(width: frame.width / 5, height: frame.height / 4)
            
            Text(Constants.logoText)
                .foregroundColor(Color.Shared.title)
                .font(.Shared.logo)
        }
    }
    
    @ViewBuilder func makeButton(proxy: GeometryProxy) -> some View {
        
        let buttonWidth: CGFloat = proxy.frame(in: .local).width * 0.5
        let buttonHeight: CGFloat = proxy.frame(in: .local).height * 0.04
        
        HStack {
            
            Spacer()
            
            Button(Constants.newGameButtonText) {
                
                isPresentingGameSetup = true
            }
            .buttonStyle(MainButtonStyle(width: buttonWidth, height: buttonHeight))
            
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
