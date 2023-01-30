//
//  GameSetupView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 25.01.2023.
//

import SwiftUI

struct GameSetupView: View {
    
    @Environment(\.dismiss) private var dismissCurrentView
    
    @FocusState private var inFocus: Bool
    
    @State var isPresentingGame: Bool = false
    
    @State var playerName: String = ""
    @State var selectedPlayer: String?
    @State var playerNames: [String] = []
    
    var body: some View {
        
        ZStack {
            
            Color.cyan
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                
                VStack {
                    
                    makeTopBar()
                    
                    makePlayerSetup(proxy: proxy)
                    
                    Spacer()
                    
                    makeBottomBar()
                }
            }
        }
        .onAppear {
            
            inFocus = true
        }
        .ignoresSafeArea(.keyboard)
        .fullScreenCover(isPresented: $isPresentingGame) {
            
            GameView(game: generateGame())
        }
    }
}

//MARK: - GameSetup methods

private extension GameSetupView {
    
    @ViewBuilder func makeTopBar() -> some View {
        
        HStack {
            
            Button {
                
                dismissCurrentView()
            } label: {
                
                Label("", systemImage: "return")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
            }
            .padding(.leading)
            
            Spacer()
        }
    }
    
    @ViewBuilder func makePlayerSetup(proxy: GeometryProxy) -> some View {
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        let frame = proxy.frame(in: .local)
        let spacing = frame.width / Constants.spacingDivider
        let itemHeight = frame.height / Constants.itemSizeDivider

        LazyVGrid(columns: columns, spacing: spacing) {
            
            ForEach(playerNames.indices, id: \.self) { index in
                
                let playerName = playerNames[index]
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: itemHeight)
                    .overlay {
                        
                        Text(playerName)
                            .font(.Shared.playerName)
                            .foregroundColor(.white)
                    }
            }
        }
        .padding()
        
        TextField("", text: $playerName)
            .textFieldStyle(AddPlayerTextFieldStyle())
            .focused($inFocus)
            .onSubmit {
                
                inFocus = true
                addPlayer()
            }
    }
    
    @ViewBuilder func makeBottomBar() -> some View {
        
        let disabled = playerNames.count < 1
        
        Button(Constants.startGameButtonTitle) {
            
            isPresentingGame = true
        }
        .buttonStyle(StartNewGameButtonStyle())
        .disabled(disabled)
        .opacity(disabled ? 0.3 : 1)
    }
}

//MARK: - Helper methods

private extension GameSetupView {
    
    func generateGame() -> Game {
        
        let players = playerNames.map { Player(id: UUID().uuidString, name: $0) }
        let game: Game = Game(
            questions: QuestionsBuilder().buildQuestions(),
            players: players
        )
        
        return game
    }
    
    func removePlayer(name: String) {
        
        playerNames.removeAll { $0 == name }
    }
    
    func addPlayer() {
        
        playerNames.append(playerName)
        playerName = ""
    }
}

//MARK: - Constants

private extension GameSetupView {
    
    enum Constants {
        
        static let startGameButtonTitle: String = "Start Game"
        
        static let spacingDivider: CGFloat = 40
        static let itemSizeDivider: CGFloat = 14
    }
}
