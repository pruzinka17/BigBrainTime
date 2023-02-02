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
    @State var selectedCategories: [String] = []
    
    @State private var diffiecuties: [String] = ["easy", "medium", "hard"]
    @State private var selectedDifficulty: String = "medium"
    
    var body: some View {
        
        ZStack {
            
            Color.Shared.background
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                
                VStack {
                    
                    makeTopBar(proxy: proxy)
                        
                    ScrollView(showsIndicators: false) {
                        
                        makePlayerSetup(proxy: proxy)
                        
                        makeCategoryChooser(proxy: proxy)
                        
                        makeDifficulties()
                    }
                    
                    Spacer()
                    
                    makeStartGame(proxy: proxy)
                }
            }
        }
        .onAppear {
            
            inFocus = true
            selectedCategories.append(categories[0])
        }
        .ignoresSafeArea(.keyboard)
        .fullScreenCover(isPresented: $isPresentingGame) {
            
            GameView(game: generateGame())
        }
    }
}

//MARK: - GameSetup methods

private extension GameSetupView {
    
    @ViewBuilder func makeTopBar(proxy: GeometryProxy) -> some View {
        
        ZStack {
            
            Color.Shared.background2
                .ignoresSafeArea()
                .shadow(radius: 6)
            
            HStack {
                
                Button {
                    
                    dismissCurrentView()
                } label: {
                    
                    Label("", systemImage: "return")
                        .foregroundColor(Color.Shared.secondary)
                        .fontWeight(.bold)
                }
                .padding(.leading)
                
                Spacer()
            }
        }
        .frame(height: proxy.safeAreaInsets.top)
    }
    
    @ViewBuilder func makePlayerSetup(proxy: GeometryProxy) -> some View {
        
        let frame = proxy.frame(in: .local)
        
        VStack {
            
            HStack {
                
                Text(Constants.Sections.players)
                    .font(.Shared.segmentTitle)
                    .padding(.leading)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            switch playerNames.isEmpty {
                
                case true:
                    
                Text(Constants.placeholderNoPlayers)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .opacity(0.3)
                        .padding()
                        .frame(height: frame.height / 6)
                    
                case false:
                
                    ScrollView(.horizontal) {
                        
                        HStack {
                            
                            ForEach(playerNames.indices, id: \.self) { index in
                                
                                let name = playerNames[index]
                                
                                PlayerBubbleView(
                                    name: name,
                                    score: nil,
                                    highlited: false,
                                    canBeDeleted: true,
                                    onTap: {
                                        
                                        removePlayer(name: name)
                                    }
                                )
                            }
                        }
                        .padding()
                        .animation(.default, value: playerNames)
                    }
                    .frame(height: frame.height / 6)
            }

            TextField(Constants.placeholderNoPlayers, text: $playerName)
                .textFieldStyle(AddPlayerTextFieldStyle(proxy: proxy))
                .focused($inFocus)
                .onSubmit {
                    
                    inFocus = true
                    if !playerName.isEmpty {
                        addPlayer()
                    }
                }
        }
    }
    
    @ViewBuilder func makeCategoryChooser(proxy: GeometryProxy) -> some View {
        
        VStack {
            
            HStack {
                
                Text(Constants.Sections.catgories)
                    .font(.Shared.segmentTitle)
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
                                .foregroundColor(Color.Shared.secondary)
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
                
                Text(Constants.Sections.difficulty)
                    .font(.Shared.segmentTitle)
                    .padding(.leading)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Picker("", selection: $selectedDifficulty) {
                
                ForEach(diffiecuties, id: \.self) { difficulty in
                    
                    Text(difficulty)
                }
            }
            .pickerStyle(.segmented)
            .padding()
        }
    }
    
    @ViewBuilder func makeStartGame(proxy: GeometryProxy) -> some View {
        
        let disabled = playerNames.count < 1 || selectedCategories.isEmpty
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
    
    enum Constants {
        
        static let startGameButtonTitle: String = "Start Game"
        static let placeholderNoPlayers: String = "no players"
        static let placeholderTextField: String = "add player"
        
        static let spacingDivider: CGFloat = 40
        static let itemSizeDivider: CGFloat = 14
        
        enum Sections {
            
            static let players: String = "Players:"
            static let catgories: String = "Categories:"
            static let difficulty: String = "Difficulty:"
        }
    }
}

// MARK: - Preview

struct GameSetupView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GameSetupView(categories: CategoriesProvider().provideCategories())
    }
}
