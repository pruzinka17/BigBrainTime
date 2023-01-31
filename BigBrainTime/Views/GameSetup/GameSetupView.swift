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
    @State private var category = Categories.sport
    
    var body: some View {
        
        ZStack {
            
            Color("color-background")
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                
                VStack {
                    
                    makeTopBar()
                    
                    ScrollView {
                        
                        makePlayerSetup(proxy: proxy)
                        
                        makeCategoryChooser()
                    }
                    
                    Spacer()
                    
                    makeBottomBar(proxy: proxy)
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
                    .foregroundColor(Color("color-secondary"))
                    .fontWeight(.bold)
            }
            .padding(.leading)
            
            Spacer()
        }
    }
    
    @ViewBuilder func makePlayerSetup(proxy: GeometryProxy) -> some View {
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        let frame = proxy.frame(in: .local)
        let spacing = frame.width / Constants.spacingDivider
        
        switch playerNames.isEmpty {
            
            case true:
            
                Text("no players")
                    .font(.system(size: 54, weight: .bold, design: .rounded))
                    .opacity(0.3)
                    .padding()
            
            case false:
            
                LazyVGrid(columns: columns, spacing: spacing) {
                    
                    ForEach(playerNames.indices, id: \.self) { index in
                        
                        let name = playerNames[index]
                            
                        PlayerBubbleView(name: name)
                            .padding(5)
                    }
                }
                .padding()
                .animation(.default, value: playerNames)
        }

        TextField("add player", text: $playerName)
            .textFieldStyle(AddPlayerTextFieldStyle(proxy: proxy))
            .focused($inFocus)
            .onSubmit {
                
                inFocus = true
                addPlayer()
            }
    }
    
    @ViewBuilder func makeCategoryChooser() -> some View {
        
//        Picker(selection: $category) {
//
//            ForEach(categories, id: \.self) { category in
//
//                Text(category)
//            }
//        }

    }
    
    @ViewBuilder func makeBottomBar(proxy: GeometryProxy) -> some View {
        
        let disabled = playerNames.count < 1
        let buttonWidth = proxy.frame(in: .local).width / 2
        
        Button(Constants.startGameButtonTitle) {
            
            isPresentingGame = true
        }
        .buttonStyle(MainButtonStyle(width: buttonWidth))
        .disabled(disabled)
        .opacity(disabled ? 0.3 : 1)
        .animation(.default, value: disabled)
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
    
    enum Categories: String, CaseIterable, Identifiable {
        
        case sport
        case science
        case general
        
        var id: String { self.rawValue }
    }
    
    enum Constants {
        
        static let startGameButtonTitle: String = "Start Game"
        
        static let spacingDivider: CGFloat = 40
        static let itemSizeDivider: CGFloat = 14
    }
}

// MARK: - Preview

struct GameSetupView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GameSetupView()
    }
}
