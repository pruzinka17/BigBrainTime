//
//  GameSetupView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 25.01.2023.
//

import SwiftUI

struct GameSetupView: View {
    
    @Environment(\.dismiss) private var dismissCurrentView
    
    let categories: [String]
    
    @FocusState private var inFocus: Bool
    
    @State var isPresentingGame: Bool = false
    
    @State var playerName: String = ""
    @State var selectedPlayer: String?
    @State var playerNames: [String] = []
    @State private var category = Categories.sport
    @State var selectedCategories: [String] = []
    
    @State private var diffiecuties: [String] = ["easy", "medium", "hard"]
    @State private var selectedDifficulty: String = "medium"
    
    var body: some View {
        
        ZStack {
            
            Color("color-background")
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                
                VStack {
                    
                    makeTopBar()
                    
                    ScrollView(showsIndicators: false) {
                        
                        VStack {
                         
                            makePlayerSetup(proxy: proxy)
                            
                            makeCategoryChooser(proxy: proxy)
                            
                            makeDifficulties()
                            
                            makeStartGame(proxy: proxy)
                        }
                    }
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
        .padding(.bottom)
    }
    
    @ViewBuilder func makePlayerSetup(proxy: GeometryProxy) -> some View {
        
        let frame = proxy.frame(in: .local)
        
        VStack {
            
            HStack {
                
                Text("players:")
                    .font(.Shared.playerName)
                    .padding(.leading)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            switch playerNames.isEmpty {
                
                case true:
                    
                    Text("no players")
                        .font(.system(size: 54, weight: .bold, design: .rounded))
                        .opacity(0.3)
                        .padding()
                    
                case false:
                
                    ScrollView(.horizontal) {
                        
                        HStack {
                            
                            ForEach(playerNames.indices, id: \.self) { index in
                                
                                let name = playerNames[index]
                                
                                PlayerBubbleView(
                                    name: name,
                                    score: nil,
                                    highlited: false
                                )
                            }
                        }
                        .padding()
                        .animation(.default, value: playerNames)
                    }
                    .frame(height: frame.height / 6)
            }

            TextField("add player", text: $playerName)
                .textFieldStyle(AddPlayerTextFieldStyle(proxy: proxy))
                .focused($inFocus)
                .onSubmit {
                    
                    inFocus = true
                    addPlayer()
                }
        }
    }
    
    @ViewBuilder func makeCategoryChooser(proxy: GeometryProxy) -> some View {
        
        VStack {
            
            HStack {
                
                Text("categories:")
                    .font(.Shared.playerName)
                    .padding(.leading)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack {
                    
                    ForEach(categories, id: \.self) { category in
                        
                        let isSelected = isCategorySelected(categoryName: category)
                        
                        Button(category) {
                            
                            handleCategorySelection(categoryName: category)
                        }
                        .padding()
                        .background {
                            
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color("color-secondary"))
                        }
                        .foregroundColor(.white)
                        .opacity(isSelected ? 1 : 0.3)
                    }
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder func makeDifficulties() -> some View {
        
        VStack {
            
            HStack {
                
                Text("difficulty:")
                    .font(.Shared.playerName)
                    .padding(.leading)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Picker("pick a difficulty", selection: $selectedDifficulty) {
                
                ForEach(diffiecuties, id: \.self) { difficulty in
                    
                    Text(difficulty)
                }
            }
            .pickerStyle(.segmented)
            .padding()
        }
    }
    
    @ViewBuilder func makeStartGame(proxy: GeometryProxy) -> some View {
        
        let disabled = playerNames.count < 1
        let buttonWidth = proxy.frame(in: .local).width / 2
        
        Button(Constants.startGameButtonTitle) {
            
            isPresentingGame = true
        }
        .buttonStyle(MainButtonStyle(width: buttonWidth))
        .disabled(disabled)
        .opacity(disabled ? 0.3 : 1)
        .animation(.default, value: disabled)
        .padding()
    }
}

//MARK: - Helper methods

private extension GameSetupView {
    
    func handleCategorySelection(categoryName: String) {
        
        if isCategorySelected(categoryName: categoryName) {
            
            selectedCategories.removeAll(where: { $0 == categoryName } )
        } else {
            
            selectedCategories.append(categoryName)
        }
    }
    
    func isCategorySelected(categoryName: String) -> Bool {
        
        return selectedCategories.contains(categoryName)
    }
    
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
        
        GameSetupView(categories: CategoriesProvider().provideCategories())
    }
}
