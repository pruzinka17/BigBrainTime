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
    
    func removePlayer(
        name: String
    ) {
        
        playerNames.removeAll { $0 == name }
    }
    
    func addPlayer() {
        
        playerNames.append(playerName)
        playerName = ""
    }
    
    func isPlayerSelected(name: String) -> Bool {
        
        return name == selectedPlayer
    }
    
    func handleSelection(for name: String) {
        
        if selectedPlayer == name {
            
            removePlayer(name: name)
            return
        }
        
        selectedPlayer = name
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
                
                let player = playerNames[index]
                let deletePlayer = isPlayerSelected(name: player)
                
                PlayerSetupTabView(
                    player: Player(id: UUID().uuidString, name: player),
                    deletePlayer: deletePlayer,
                    onTap: {
                        
                        handleSelection(for: player)
                    }
                )
            }
        }
        .padding()
        
        TextField("", text: $playerName)
            .textFieldStyle(AddPlayerTextFieldStyle())
            .focused($inFocus)
            .onSubmit {
                
                inFocus = true
                
                if !(playerNames.count >= 12) && playerName.isEmpty {
                    
                    addPlayer()
                }
            }
            .padding()
        
        Button("add player") {
            
            addPlayer()
        }
    }
    
    @ViewBuilder func makeBottomBar() -> some View {
        
        Button("Start game") {
            
            isPresentingGame = true
        }
        .buttonStyle(StartNewGameButtonStyle(notEnoughPlayers: playerNames.count < 1))
    }
}

struct GameSetupView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GameSetupView()
    }
}
