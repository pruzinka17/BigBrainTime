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
    
    @State var players: [Player] = []
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
        
        let game: Game = Game(questions: QuestionsBuilder().buildQuestions(), players: players)
        
        return game
    }
    
    func removePlayer(id: String) {
        
        players.removeAll { $0.id == id }
    }
    
    func addPlayer() {
        
        players.append(Player(id: UUID().uuidString, name: playerName, score: 0))
        playerName = ""
    }
    
    func isPlayerSelected(id: String) -> Bool {
        
        return id == selectedPlayer
    }
    
    func handleSelection(for id: String) {
        
        if selectedPlayer == id {
            
            players.removeAll { $0.id == id }
            return
        }
        
        selectedPlayer = id
    }
    
    func isLobbyFull() -> Bool {
        
        if players.count > 12 {
            return true
        }
        return false
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
            
            ForEach(players) { player in
                
                let deletePlayer = isPlayerSelected(id: player.id)
                
                PlayerSetupTabView(
                    player: player,
                    deletePlayer: deletePlayer,
                    onTap: {
                        
                        handleSelection(for: player.id)
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
                if !(players.count >= 12) && playerName.isEmpty {
                    addPlayer()
                }
            }
            .padding()
        
        Button("add player") {
            
            addPlayer()
        }
        //tahle picovina nefunguje nvm proc
        .buttonStyle(AddPlayerButtonStyle(isInputValid: !playerName.isEmpty, isLobbyFull: isLobbyFull()))
    }
    
    @ViewBuilder func makeBottomBar() -> some View {
        
        Button("Start game") {
            
            isPresentingGame = true
        }
        .buttonStyle(StartNewGameButtonStyle(notEnoughPlayers: players.count < 1))
    }
}

struct GameSetupView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GameSetupView()
    }
}
