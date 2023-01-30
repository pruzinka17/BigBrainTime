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
    
    @State var gameEnded: Bool = false
    @State var currentPlayerIndex: Int = 0
    @State var currentQuestionIndex: Int = 0
    @State var currentAnswers: [Player.ID: Question.Answer.ID] = [:]
    
    var body: some View {
        
        ZStack {
            
            Color.cyan
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                
                VStack {
                    
                    makeTopBar()
                    
                    makePlayerList(proxy: proxy)
                    
                    Spacer()
                    
                    makeQuestion()
                    
                    Spacer()
                }
                
                VStack {
                    
                    makeGameEnd()
                }
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
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: itemWidth, height: itemHeight)
                        .overlay {
                            
                            VStack {
                                
                                Text(player.name)
                                    .font(.Shared.playerName)
                                    .foregroundColor(.white)
                                
                                Text("\(player.score)")
                                    .font(.Shared.playerScore)
                                    .foregroundColor(.white)
                            }
                        }
                        .foregroundColor(.clear)
                        .background {
                            isCurrentlyPlaying ? Color.black : Color.clear
                        }
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
            
            LazyVGrid(columns: columns) {
                
                ForEach(currentQuestion.answers) { answer in
                    
                    let isSelected = false // TODO: To be deleted!
                    
                    AnswerView(
                        answer: answer,
                        isSelected: isSelected,
                        onTap: {
                            
                            handleAnswer(for: answer)
                        }
                    )
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder func makeGameEnd() -> some View {
        
        RoundedRectangle(cornerRadius: 20)
            .padding()
            .overlay {
                
                VStack {
                    
                    Text("Game ended")
                    
                    Button {
                        
                        dismissCurrentView()
                    } label: {
                        
                        Label("", systemImage: "return")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                    }
                }
            }
            .padding()
            .foregroundColor(.clear)
            .background {
                
                Color.gray
            }
    }
}

// MARK: - Helper methods

private extension GameView {
    
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

//struct GameView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        let questions: [Question] = QuestionsBuilder().buildQuestions()
//
//        GameView(
//            game: Game(
//                questions: questions,
//                players: [
//                    Player(id: UUID().uuidString, name: "haha", score: 0),
//                    Player(id: UUID().uuidString, name: "cau", score: 80),
//                    Player(id: UUID().uuidString, name: "ne", score: 100),
//                    Player(id: UUID().uuidString, name: "haha", score: 0),
//                    Player(id: UUID().uuidString, name: "cau", score: 80),
//                    Player(id: UUID().uuidString, name: "ne", score: 100),
//                    Player(id: UUID().uuidString, name: "haha", score: 0),
//                    Player(id: UUID().uuidString, name: "cau", score: 80),
//                    Player(id: UUID().uuidString, name: "ne", score: 100),
//                    Player(id: UUID().uuidString, name: "haha", score: 0),
//                    Player(id: UUID().uuidString, name: "cau", score: 80),
//                    Player(id: UUID().uuidString, name: "haha", score: 0)
//                ]
//            )
//        )
//    }
//}
