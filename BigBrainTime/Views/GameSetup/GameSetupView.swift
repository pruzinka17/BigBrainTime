//
//  GameSetupView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 25.01.2023.
//

import SwiftUI

struct GameSetupView: View {
    
    private let gameService: GameService
    
    @Environment(\.dismiss) private var dismissCurrentView
    
    @State var isPresentingGame: Bool = false
    
    // MARK: - Players
    
    @FocusState private var isPlayerTextFieldFocus: Bool
    
    @State var playerName: String = ""
    @State var playerNames: [String] = []
    
    // MARK: - Categories
    
    @State var categories: [Category] = []
    @State var selectedCategories: [String] = []
    
    @State private var isFetchingCategories: Bool = true
    
    // MARK: - Questions
    
    @State var numberOfQuestions: Double = 2
    
    // MARK: - Difficulties
    
    @State private var selectedDifficulty: Difficulties = .Medium
    
    @Namespace var difficulatiesNamespace
    
    init(gameService: GameService) {
        
        self.gameService = gameService
    }
    
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
                        
                        makeQuestions(proxy: proxy)
                        
                        makeDifficulties()
                            .padding(.bottom)
                        
                        makeStartGame(proxy: proxy)
                    }
                }
            }
        }
        .task {
            
            let categories = await gameService.fetchCateogires()
            isFetchingCategories = false
            self.categories = categories
        }
        .onAppear {
            
            isPlayerTextFieldFocus = true
        }
        .fullScreenCover(isPresented: $isPresentingGame) {
            
            GameView(game: generateGame())
        }
    }
}

// MARK: - Top bar

private extension GameSetupView {
    
    @ViewBuilder func makeTopBar(proxy: GeometryProxy) -> some View {
        
        ZStack {
            
            HStack {
                
                Button {
                    
                    dismissCurrentView()
                } label: {
                    
                    Image(systemName: "return")
                        .foregroundColor(Color.Shared.secondary)
                        .fontWeight(.bold)
                }
                .padding(.leading)
                
                Spacer()
            }
            
            HStack {
                
                Text(Constants.gameSetupTitle)
                    .foregroundColor(.white)
                    .font(.Shared.gameSetupTitleFont)
            }
        }
        .frame(height: proxy.safeAreaInsets.top)
    }
}

// MARK: - Players

private extension GameSetupView {
    
    @ViewBuilder func makePlayers(proxy: GeometryProxy) -> some View {
        
        let frame = proxy.frame(in: .local)
        let height = frame.height + proxy.safeAreaInsets.top + proxy.safeAreaInsets.bottom
        let textFieldSize = CGSize(width: frame.width * 0.75, height: height * 0.05)
        
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
                    .frame(height: height / Constants.playersFrameDivider)
                
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
                .frame(height: height / Constants.playersFrameDivider)
            }
            
            TextField(Constants.placeholderTextField, text: $playerName)
                .textFieldStyle(AddPlayerTextFieldStyle(size: textFieldSize))
                .focused($isPlayerTextFieldFocus)
                .onSubmit {
                    
                    isPlayerTextFieldFocus = true
                    
                    addPlayer()
                }
        }
    }
}

// MARK: - Categories

private extension GameSetupView {
    
    @ViewBuilder func makeCategories(proxy: GeometryProxy) -> some View {
        
        VStack {
            
            HStack {
                
                Text(Constants.Sections.catgories)
                    .font(.Shared.segmentTitle)
                    .padding(.leading)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            if !isFetchingCategories {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack {
                    
                        ForEach(categories, id: \.name) { category in
                            
                            let isSelected = isCategorySelected(category.value)
                            
                            Button(category.name) {
                                
                                handleCategorySelection(category.value)
                            }
                            .padding()
                            .background {
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(Color.Shared.secondary)
                            }
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .opacity(isSelected ? 1 : 0.3)
                        }
                    }
                    .padding()
                }
            } else {
                
                HStack {
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.Shared.secondary))
                }
            }
            

        }
    }
}
    
// MARK: - Questions

private extension GameSetupView {
    
    @ViewBuilder func makeQuestions(proxy: GeometryProxy) -> some View {
        
        let frame = proxy.frame(in: .local)
        
        VStack {
            
            HStack {
                
                Text(Constants.Sections.questionCount)
                    .font(.Shared.segmentTitle)
                    .padding(.leading)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            HStack(alignment: .center) {
                
                Slider(value: $numberOfQuestions, in: Question.questionLimit)
                    .accentColor(.orange)
                    .padding(.trailing)
                
                Text("\(Int(numberOfQuestions)) / \(Int(Question.questionLimit.upperBound))")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .frame(width: frame.width * 0.2)
            }
            .padding()
        }
    }
}

// MARK: - Difficulties

private extension GameSetupView {
    
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
                
                ForEach(Difficulties.allCases, id: \.hashValue) { difficulty in
                    
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
                                .foregroundColor(Color.Shared.secondary)
                                .matchedGeometryEffect(
                                    id: "difficulty",
                                    in: difficulatiesNamespace,
                                    isSource: isSelected
                                )
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Start game

private extension GameSetupView {
    
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
    
    func addPlayer() {
        
        guard !playerName.isEmpty && !playerNames.contains(playerName) else {
            return
        }
        
        playerNames.append(playerName)
        playerName = ""
    }
    
    func removePlayer(name: String) {
        
        playerNames.removeAll { $0 == name }
    }
    
    func handleCategorySelection(_ value: String) {
        
        switch isCategorySelected(value) {
        case true:
            
            selectedCategories.removeAll(where: { $0 == value } )
        case false:
            
            selectedCategories.append(value)
        }
    }
    
    func isCategorySelected(_ value: String) -> Bool {
        
        return selectedCategories.contains(value)
    }
    
    func isDifficultySelected(difficulty: Difficulties) -> Bool {
        
        return difficulty == selectedDifficulty
    }
    
    func selectDificulty(difficulty: Difficulties) {
        
        selectedDifficulty = difficulty
    }
    
    func generateGame() -> Game {

        let players = playerNames.map { Player(id: UUID().uuidString, name: $0) }

        let game: Game = Game(
            questions: [
                Question(text: "bla", category: "asd", answers: [
                    Question.Answer(id: UUID().uuidString, value: "balls", isCorrect: false)
                ])
            ],
            players: players
        )

        return game
    }
}

//MARK: - Constants

private extension GameSetupView {
    
    enum Constants {
        
        static let startGameButtonTitle: String = "Start Game"
        static let placeholderNoPlayers: String = "No players"
        static let placeholderTextField: String = "Add player"
        static let gameSetupTitle: String = "Game Setup"
        
        static let spacingDivider: CGFloat = 40
        static let itemSizeDivider: CGFloat = 14
        
        static let playersFrameDivider: CGFloat = 7
        static let startGameDivider: CGFloat = 2
        
        enum Sections {
            
            static let players: String = "Players"
            static let catgories: String = "Categories"
            static let difficulty: String = "Difficulty"
            static let questionCount: String = "Number of questions"
        }
    }
}

// MARK: - Preview

//struct GameSetupView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        
//        GameSetupView(categories: CategoriesProvider().provideCategories())
//    }
//}
