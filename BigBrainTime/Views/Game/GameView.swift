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
            
            Color.Shared.background
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                
                VStack {
                    
                    makeTopBar(proxy: proxy)
                    
                    makeQuestion()
                    
                    Spacer()
                    
                    makePlayerList(proxy: proxy)
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

//MARK: - Top bar

private extension GameView {
    
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
                
                Text("question: \(currentQuestionIndex + 1) / \(game.questions.count)")
                    .foregroundColor(Color.Shared.secondary)
                    .padding(.trailing)
                    .fontWeight(.bold)
            }
        }
        .frame(height: proxy.safeAreaInsets.top)
    }
}

// MARK: - Players

private extension GameView {
    
    @ViewBuilder func makePlayerList(proxy: GeometryProxy) -> some View {
        
        let frame = proxy.frame(in: .local)
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(alignment: .center) {
                
                Spacer()
                
                ForEach(game.players.indices, id: \.self) { index in
                    
                    let player = game.players[index]
                    let isCurrentlyPlaying = currentPlayerIndex == index
                    
                    PlayerBubbleView(
                        name: player.name,
                        score: player.score,
                        highlited: isCurrentlyPlaying,
                        canBeDeleted: false,
                        onTap: { }
                    )
                    .frame(height: frame.height / 7.5)
                    .animation(.default, value: isCurrentlyPlaying)
                }
            }
            .frame(height: frame.height / 7)
        }
    }
}

// MARK: - Questions

private extension GameView {
    
    @ViewBuilder func makeQuestion() -> some View {
        
        let columns = [
            GridItem(.flexible())
        ]
        
        let currentQuestion = game.questions[currentQuestionIndex]
        
        ScrollView {
            
            VStack {
                
                Text(currentQuestion.category)
                    .font(.Shared.answerTitle)
                    .foregroundColor(.white)
                    .animation(.default, value: currentQuestion.category)
                    .padding(.bottom)
                
                Text(currentQuestion.text)
                    .font(.Shared.question)
                    .foregroundColor(.white)
                    .animation(.default, value: currentQuestion.text)
                    .padding(.bottom)
                
                LazyVGrid(columns: columns) {
                    
                    ForEach(currentQuestion.answers) { answer in
                        
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.clear)
                            .frame(height: 55)
                            .overlay {
                                
                                Text(answer.value)
                                    .font(.Shared.answer)
                                    .foregroundColor(.white)
                            }
                            .background(content: {
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.Shared.secondary)
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
    }
}

// MARK: - End game

private extension GameView {
    
    @ViewBuilder func makeGameEnd() -> some View {
        
        ZStack {
            
            Color.Shared.background
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
                
                ScrollView {
                    
                    VStack {
                        
                        makePlayersScore()
                        
                        makeQuestionAnswers()
                    }
                }
            }
        }
    }
    
    @ViewBuilder func makePlayersScore() -> some View {
        
        let playerScores = getSortedPlayers()
        
        LazyVGrid(columns: [GridItem(.flexible())]) {
            
            ForEach(playerScores) { playerScore in
                
                HStack {
                    
                    Text(playerScore.name)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading)
                        .padding(.bottom)
                    
                    Spacer()
                    
                    Text("\(playerScore.score)")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.trailing)
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder func makeQuestionAnswers() -> some View {
        
        let questions = game.questions
        
        LazyVGrid(columns: [GridItem(.flexible())]) {
            
            ForEach(questions, id: \.text) { question in
                
                VStack {
                    
                    Text(question.text)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom)
                    
                    ForEach(question.answers) { answer in
                        
                        if answer.isCorrect {
                            
                            Text("Correct answer: " + answer.value)
                                .fontWeight(.bold)
                                .foregroundColor(Color.Shared.secondary)
                        }
                    }
                }
                .padding(.bottom)
            }
        }
        .padding()
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

// MARK: - Preview

//struct GameView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        GameView(game: Game(
//            questions: QuestionsBuilder().buildQuestions(),
//            players: [
//                Player(id: UUID().uuidString, name: "mirek"),
//                Player(id: UUID().uuidString, name: "ahoj"),
//                Player(id: UUID().uuidString, name: "ne"),
//                Player(id: UUID().uuidString, name: "prosim")
//                ]
//            )
//        )
//    }
//}
