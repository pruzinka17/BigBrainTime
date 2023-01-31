//
//  GameView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 26.01.2023.
//

import SwiftUI

struct GameView: View {
    
    @Environment(\.dismiss) var dismissCurrentView
    
    let game: Game
    
    @Namespace var namespace
    
    @State var gameEnded: Bool = false
    @State var currentPlayerIndex: Int = 0
    @State var currentQuestionIndex: Int = 0
    @State var currentAnswers: [Player.ID: Question.Answer.ID] = [:]
    
    var body: some View {
        
        ZStack {
            
            Color("background-color")
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                
                VStack {
                    
                    makeTopBar()
                    
                    makePlayerList(proxy: proxy)
                    
                    Spacer()
                    
                    makeQuestion()
                    
                    Spacer()
                }
                    
                makeGameEnd()
                    .animation(.default, value: gameEnded)
                    .opacity(gameEnded ? 1 : 0)
            }
        }
        .onAppear {
            
            guard !gameEnded else {
                return
            }
            
            currentPlayerIndex = 0
            currentQuestionIndex = 0
            currentAnswers = [:]
        }
    }
}

//MARK: - Game methods

private extension GameView {
    
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
    
    @ViewBuilder func makePlayerList(proxy: GeometryProxy) -> some View {
        
        let frame = proxy.frame(in: .local)
        let itemHeight = frame.height / 12
        let itemWidth = frame.width / 5
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack {
                
                ForEach(game.players.indices, id: \.self) { index in

                    let player = game.players[index]
                    let isCurrentlyPlaying = currentPlayerIndex == index
                    
                        
                    PlayerTabView(
                        namespace: namespace.self,
                        name: player.name,
                        score: player.score,
                        isCurrentlyPlaying: isCurrentlyPlaying,
                        itemWidth: itemWidth,
                        itemHeight: itemHeight
                    )
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder func makeQuestion() -> some View {
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        let currentQuestion = game.questions[currentQuestionIndex]
        
        VStack {
            
            Text(currentQuestion.text)
                .font(.Shared.answerTitle)
                .padding()
                .animation(.default, value: currentQuestion.text)
            
            LazyVGrid(columns: columns) {
                
                ForEach(currentQuestion.answers) { answer in
                    
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.clear)
                        .frame(height: 55)
                        .overlay {
                            
                            Text(answer.value)
                                .font(.Shared.answer)
                        }
                        .background(content: {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.gray)
                        })
                        .onTapGesture {
                            
                            handleAnswer(for: answer)
                        }
                        .animation(.default, value: answer.value)
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder func makeGameEnd() -> some View {
        
        let playerScores = getSortedPlayers()
        
        ZStack {
            
            Color.gray
                .ignoresSafeArea()
            
            VStack {
                
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
                
                Spacer()
                
                List {
                    
                    ForEach(playerScores) { playerScore in
                        
                        HStack {
                            Text(playerScore.name)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text("\(playerScore.score)")
                                .fontWeight(.bold)
                        }
                        .listRowBackground(Color.gray)
                    }
                }
                .listStyle(.plain)
                .padding()
                
                Spacer()
            }
        }
    }
}

// MARK: - Helper methods

private extension GameView {
    
    func getSortedPlayers() -> [Player] {
        
        let players = game.players
        return players.sorted { $0.score > $1.score }
    }
    
    func handleAnswer(for answer: Question.Answer) {
        
        let currentPlayerIndex = self.currentPlayerIndex
        let currentPlayer = game.players[currentPlayerIndex]
        
        let currentQuestionIndex = self.currentQuestionIndex
        let currentQuestion = game.questions[currentQuestionIndex]
        
        let maxPlayerIndex = game.players.count - 1
        let maxQuestionIndex = game.questions.count - 1
        
        currentAnswers[currentPlayer.id] = answer.id
        
        let isLastPlayerToAnswer = currentPlayerIndex == maxPlayerIndex
        let isLastQuestionToAnswer = currentQuestionIndex == maxQuestionIndex
        
        switch isLastPlayerToAnswer {
        case true:
            
            self.currentPlayerIndex = 0
            
            for player in game.players {
                
                let answerId = currentAnswers[player.id]!
                let isCorrectAnswer = currentQuestion.answers.first(where: { $0.id == answerId })!.isCorrect
                player.score += isCorrectAnswer ? 100 : 0
            }
                
            switch isLastQuestionToAnswer {
            case true:
                
                self.gameEnded = true
            case false:
                
                self.currentQuestionIndex += 1
            }
        case false:
            
            self.currentPlayerIndex += 1
        }
    }
}
