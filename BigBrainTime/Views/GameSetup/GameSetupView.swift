//
//  GameSetupView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 25.01.2023.
//

import SwiftUI

struct GameSetupView: View {
    
    @ObservedObject var presenter: GameSetupPresenter
    
    @Environment(\.dismiss) private var dismissCurrentView
    
    @State var isPresentingGame: Bool = false
    
    @FocusState private var isPlayerTextFieldFocus: Bool
    
    @Namespace var difficulatiesNamespace
    
    init(gameService: GameService) {
        
        self.presenter = GameSetupPresenter(
            gameService: gameService
        )
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
            
            await self.presenter.fetchCategories()
        }
        .onAppear {
            
            isPlayerTextFieldFocus = false
        }
        .fullScreenCover(isPresented: $isPresentingGame) {
            
            GameView(game: presenter.game!)
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
            
            switch presenter.viewModel.playerNames.isEmpty {
                
            case true:
                
                Text(Constants.placeholderNoPlayers)
                    .font(.Shared.noPlayers)
                    .opacity(0.3)
                    .padding()
                    .frame(height: height / Constants.playersFrameDivider)
                
            case false:
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack {
                        
                        ForEach(presenter.viewModel.playerNames.indices, id: \.self) { index in
                            
                            let name = presenter.viewModel.playerNames[index]
                            
                            PlayerBubbleView(
                                name: name,
                                score: nil,
                                highlited: false,
                                canBeDeleted: true,
                                onTap: {
                                    
                                    presenter.removePlayer(name: name)
                                }
                            )
                        }
                    }
                    .padding()
                    .animation(.default, value: presenter.viewModel.playerNames)
                }
                .frame(height: height / Constants.playersFrameDivider)
            }
            
            TextField(Constants.placeholderTextField, text: $presenter.viewModel.currentPlayerName)
                .textFieldStyle(AddPlayerTextFieldStyle(size: textFieldSize))
                .focused($isPlayerTextFieldFocus)
                .onSubmit {
                    
                    isPlayerTextFieldFocus = true
                    
                    presenter.addPlayer()
                }
        }
    }
}

// MARK: - Categories

private extension GameSetupView {
    
    @ViewBuilder func makeCategories(proxy: GeometryProxy) -> some View {
        
        let frameHeight = proxy.frame(in: .local).height
        
        VStack {
            
            HStack {
                
                Text(Constants.Sections.catgories)
                    .font(.Shared.segmentTitle)
                    .padding(.leading)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            VStack {
                
                switch presenter.viewModel.isLoadingCategories {
                    
                case false:
                    
                    if !presenter.viewModel.categories.isEmpty {
                        
                        makeCategorySelection()
                    } else {
                        
                        Text(Constants.categoryLoadFailed)
                            .foregroundColor(Color.red)
                    }
                    
                case true:
                        
                    HStack {

                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.Shared.secondary))
                    }
                }
            }
            .frame(height: frameHeight * 0.1)
        }
    }
    
    @ViewBuilder func makeCategorySelection() -> some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack {
            
                ForEach(presenter.viewModel.categories, id: \.name) { category in
                    
                    let isSelected = presenter.isCategorySelected(category.value)
                    
                    Button(category.name) {
                        
                        presenter.handleCategorySelection(category.value)
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
                
                Slider(value: $presenter.viewModel.numberOfQuestions, in: Question.questionLimit)
                    .accentColor(.orange)
                    .padding(.trailing)
                
                Text("\(Int(presenter.viewModel.numberOfQuestions)) / \(Int(Question.questionLimit.upperBound))")
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
                    
                    let isSelected = presenter.isDifficultySelected(difficulty: difficulty)
                    
                    Button(difficulty.rawValue.capitalized) {
                        
                        withAnimation(.default) {
                            
                            presenter.selectDificulty(difficulty: difficulty)
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
        
        let disabled = presenter.viewModel.playerNames.count < 1 || presenter.viewModel.selectedCategories.isEmpty
        let buttonWidth = proxy.frame(in: .local).width / Constants.startGameDivider
        let buttonHeight: CGFloat = proxy.frame(in: .local).height * 0.04
        
        Button {
            
            Task {
                
                await presenter.generateGame()
                if presenter.game != nil {
                    isPresentingGame = true
                }
            }
        } label: {
            
            if !presenter.viewModel.isGeneratingGame {
                
                Text(Constants.startGameButtonTitle)
                
            } else {
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
            }
        }
        .buttonStyle(MainButtonStyle(width: buttonWidth, height: buttonHeight))
        .disabled(disabled)
        .opacity(disabled ? 0.3 : 1)
        .animation(.default, value: disabled)
        .padding()
    }
}

//MARK: - Constants

private extension GameSetupView {
    
    enum Constants {
        
        static let startGameButtonTitle: String = "Start Game"
        static let placeholderNoPlayers: String = "No players"
        static let placeholderTextField: String = "Add player"
        static let gameSetupTitle: String = "Game Setup"
        static let categoryLoadFailed: String = "Categories couldn't be loaded"
        
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
