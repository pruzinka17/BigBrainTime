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
    
    @State var playerNames: [String] = []
    @State var selectedPlayer: String?
    
    var body: some View {
        
        ZStack {
            
            Color.cyan
                .ignoresSafeArea()
            
            VStack {
                
                makeTopBar()
                
                makePlayerSetup()
                
                Spacer()
                
                makeBottomBar()
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

//MARK: - Helper functions

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
    
    @ViewBuilder func makePlayerSetup() -> some View {
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

        LazyVGrid(columns: columns, spacing: 15) {
            
            ForEach(playerNames.indices, id: \.self) { index in
                
                let playerName = playerNames[index]
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 55)
                    .overlay {
                        
                        Text(playerName)
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
        
        Button("Start game") {
            
            isPresentingGame = true
        }
        .buttonStyle(StartNewGameButtonStyle())
        .disabled(disabled)
        .opacity(disabled ? 0.3 : 1)
    }
}

struct GameSetupView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GameSetupView()
    }
}
