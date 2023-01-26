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
    
    @State var isPresentingGame = false
    
    @State var playerName: String = ""
    @State var players: [Player] = []
    
    var body: some View {
        
        ZStack {
            
            Color.cyan
                .ignoresSafeArea()
            
            VStack {
                
                makeTopBar()
                
                makePlayerSetup()
                
                Spacer()
                
                Button("Start game") {
                    
                    isPresentingGame = true
                }
                .padding()
                .foregroundColor(.black)
                .fontWeight(.bold)
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
    
    func addPlayer() {
        
        players.append(Player(id: UUID().uuidString, name: playerName, score: 0))
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
            .padding()
            
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
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 55)
                    .overlay {
                        VStack {
                            Text("name: \(player.name)")
                                .foregroundColor(.white)
                            Text("score: \(player.score)")
                                .foregroundColor(.white)
                        }
                    }
            }
        }
        .padding()
        
        TextField("", text: $playerName)
            .foregroundColor(.white)
            .padding()
            .background(content: {
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray)
            })
            .shadow(radius: 6)
            .padding()
            .focused($inFocus)
            .submitLabel(.next)
            .onSubmit {
                
                inFocus = true
                addPlayer()
            }
        
        Button("add player") {
            
            addPlayer()
        }
        .foregroundColor(.black)
        .fontWeight(.bold)
    }
}

struct GameSetupView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GameSetupView()
    }
}
