//
//  GameView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 26.01.2023.
//

import SwiftUI

struct GameView: View {
    
    @Environment(\.dismiss) var dismissCurrentView
    
    @ObservedObject var presenter: GamePresenter
    
    @Namespace var namespace
    
    init(
        game: Game
    ) {

        self.presenter = GamePresenter(game: game)
    }
    
    var body: some View {
        
        ZStack {
            
            Color.Shared.background
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                
                VStack {
                    
                    makeTopBar(proxy: proxy)
                    
                    makeQuestion(proxy: proxy)
                    
                    Spacer()
                    
                    makePlayerList(proxy: proxy)
                }
            }
        }
        .sheet(isPresented: $presenter.viewModel.showEndGame, content: {
            
            EndGameView(
                
                context: EndGameContext(game: presenter.game, playerAnswers: presenter.playersAnswers)
            ) {

                dismissCurrentView()
            }
        })
        .onAppear {
            
            presenter.present()
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
                
                Text(presenter.viewModel.progress)
                    .foregroundColor(Color.Shared.secondary)
                    .padding(.trailing)
                    .fontWeight(.bold)
            }
        }
        .frame(height: proxy.safeAreaInsets.top)
    }
}

// MARK: - Questions

private extension GameView {
    
    @ViewBuilder func makeQuestion(proxy: GeometryProxy) -> some View {
        
        let width = proxy.frame(in: .local).width
        
        let currentQuestion = presenter.viewModel.currentQuestion
        let answers = presenter.viewModel.answers
        
        ScrollView {
            
            VStack {
                
                Text(currentQuestion.category)
                    .lineLimit(1)
                    .font(.Shared.answerTitle)
                    .minimumScaleFactor(0.3)
                    .foregroundColor(.white)
                    .animation(.default, value: currentQuestion.category)
                    .padding(.bottom)
                
                Text(currentQuestion.text)
                    .font(.Shared.question)
                    .minimumScaleFactor(0.3)
                    .foregroundColor(.white)
                    .animation(.default, value: currentQuestion.text)
                    .padding(.bottom)
                    
                ForEach(answers, id: \.id) { answer in
                    
                    Text(answer.text)
                        .font(.Shared.answer)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: width * 0.9)
                        .background {
                            
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.Shared.secondary)
                        }
                        .onTapGesture {
                            
                            presenter.handleAnswer(for: answer.id)
                        }
                        .animation(.default, value: answer.text)
                }
            }
            .padding()
        }
    }
}

// MARK: - Players

private extension GameView {
    
    @ViewBuilder func makePlayerList(proxy: GeometryProxy) -> some View {
        
        let frame = proxy.frame(in: .local)
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(alignment: .center) {
                
                Spacer()
                
                ForEach(presenter.viewModel.players.indices, id: \.self) { index in
                    
                    let player = presenter.viewModel.players[index]
                    
                    PlayerBubbleView(
                        name: player.name,
                        score: player.score,
                        highlited: player.isPlaying,
                        canBeDeleted: false,
                        onTap: { }
                    )
                    .frame(height: frame.height / 7.5)
                    .animation(.default, value: player.isPlaying)
                }
            }
            .frame(height: frame.height / 7)
            .padding([.leading, .trailing])
        }
    }
}

// MARK: - End game

//private extension GameView {
//
//    @ViewBuilder func makeGameEnd() -> some View {
//
//        ZStack {
//
//            Color.Shared.background
//                .ignoresSafeArea()
//
//
//            VStack {
//
//                HStack {
//
//                    Button {
//
//                        dismissCurrentView()
//                    } label: {
//
//                        Label("", systemImage: "return")
//                            .foregroundColor(.black)
//                            .fontWeight(.bold)
//                    }
//                    .padding(.leading)
//
//                    Spacer()
//                }
//
//                ScrollView {
//
//                    VStack {
//
//                        makePlayersScore()
//
//                        makeQuestionAnswers()
//                    }
//                }
//            }
//        }
//    }
//
//    @ViewBuilder func makePlayersScore() -> some View {
//
//        let playerScores = presenter.sortPlayersByScore()
//
//        LazyVGrid(columns: [GridItem(.flexible())]) {
//
//            ForEach(playerScores) { playerScore in
//
//                HStack {
//
//                    Text(playerScore.name)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding(.leading)
//                        .padding(.bottom)
//
//                    Spacer()
//
//                    Text("\(playerScore.score)")
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding(.trailing)
//                }
//            }
//        }
//        .padding()
//    }
//
//    @ViewBuilder func makeQuestionAnswers() -> some View {
//
//        let questions = presenter.viewModel.game.questions
//
//        LazyVGrid(columns: [GridItem(.flexible())]) {
//
//            ForEach(questions, id: \.text) { question in
//
//                VStack {
//
//                    Text(question.text)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding(.bottom)
//
//                    ForEach(question.answers) { answer in
//
//                        if answer.isCorrect {
//
//                            Text("Correct answer: " + answer.value)
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.Shared.secondary)
//                        }
//                    }
//                }
//                .padding(.bottom)
//            }
//        }
//        .padding()
//    }
//}
