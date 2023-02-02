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
                
                GameSetupView(categories: CategoriesProvider().provideCategories())
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
        
        let buttonWidth: CGFloat = proxy.frame(in: .local).width / 2
        
        HStack {
            
            Spacer()
            
            Button(Constants.newGameButtonText) {
                
                isPresentingGameSetup = true
            }
            .buttonStyle(MainButtonStyle(width: buttonWidth))
            
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

// MARK: - Preview

struct MainMenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        MainMenuView()
    }
}
