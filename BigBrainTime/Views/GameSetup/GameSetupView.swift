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
    
    @Namespace var namespace
    
    @State var isPresentingGame: Bool = false
    
    @State var playerName: String = ""
    @State var selectedPlayer: String?
    @State var playerNames: [String] = []
    @State var selectedCategories: [String] = []
    
    @State private var selectedDifficulty: Constants.Difficulties = Constants.Difficulties.Medium
    
    @State var numberOfQuestions: Double = 2
    
    var body: some View {
        
        ZStack {
            
            Color.Shared.background
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                
                VStack {
                    
                    makeTopBar(proxy: proxy)
                        
                    ScrollView(showsIndicators: false) {
                        
                        makePlayers(proxy: proxy)
                        
                        makeCategories(proxy: proxy)
                        
//                        makeQuestionCount()
                        
                        makeDifficulties()
                    }
                    .padding(.top)
                    
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
    
    @ViewBuilder func makePlayers(proxy: GeometryProxy) -> some View {
        
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
                    .font(.Shared.noPlayers)
                    .opacity(0.3)
                    .padding()
                    .frame(height: frame.height / Constants.playersFrameDivider)
                    
                case false:
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
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
                .frame(height: frame.height / Constants.playersFrameDivider)
            }

            TextField(Constants.placeholderTextField, text: $playerName)
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
    
    @ViewBuilder func makeCategories(proxy: GeometryProxy) -> some View {
        
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
    
//    @ViewBuilder func makeQuestionCount() -> some View {
//
//        VStack {
//
//            HStack {
//
//                Text(Constants.Sections.questionCount)
//                    .font(.Shared.segmentTitle)
//                    .padding(.leading)
//                    .foregroundColor(.white)
//
//                Spacer()
//            }
//
//            Text(String(Int(numberOfQuestions)) + "/" + String(20))
//                .foregroundColor(.white)
//                .fontWeight(.bold)
//                .padding(.top)
//
//            Slider(value: $numberOfQuestions, in: 2...20)
//                .padding()
//        }
//    }
    
    @ViewBuilder func makeDifficulties() -> some View {
        
        VStack {
            
            HStack {
                
                Text(Constants.Sections.difficulty)
                    .font(.Shared.segmentTitle)
                    .padding(.leading)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            HStack {
                
                ForEach(Constants.Difficulties.allCases, id: \.hashValue) { difficulty in
                    
                    let isSelected = isDifficultySelected(difficulty: difficulty)
                    
                    Button(difficulty.rawValue) {
                        
                        withAnimation(.default) {
                            
                            selectDificulty(difficulty: difficulty)
                        }
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background {
                        
                        if isSelected {
                            
                            RoundedRectangle(cornerRadius: 20)
                                .matchedGeometryEffect(id: "difficulty", in: namespace, isSource: isSelected)
                                .foregroundColor(Color.Shared.secondary)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder func makeStartGame(proxy: GeometryProxy) -> some View {
        
        let disabled = playerNames.count < 1 || selectedCategories.isEmpty
        let buttonWidth = proxy.frame(in: .local).width / Constants.startGameDivider
        
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
    
    func isDifficultySelected(difficulty: Constants.Difficulties) -> Bool {
        
        return difficulty == selectedDifficulty
    }
    
    func selectDificulty(difficulty: Constants.Difficulties) {
        
        selectedDifficulty = difficulty
    }
    
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
        static let placeholderNoPlayers: String = "No players"
        static let placeholderTextField: String = "Add player"
        
        static let spacingDivider: CGFloat = 40
        static let itemSizeDivider: CGFloat = 14
        
        static let playersFrameDivider: CGFloat = 6
        static let startGameDivider: CGFloat = 2
        
        enum Sections {
            
            static let players: String = "Players"
            static let catgories: String = "Categories"
            static let difficulty: String = "Difficulty"
            static let questionCount: String = "Number of questions"
        }
        
        enum Difficulties: String, CaseIterable {
            
            case Easy
            case Medium
            case Hard
        }
    }
}

// MARK: - Preview

struct GameSetupView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GameSetupView(categories: CategoriesProvider().provideCategories())
    }
}
