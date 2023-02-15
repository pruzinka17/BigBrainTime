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
                
                let frame = proxy.frame(in: .local)
                let frameWidth = frame.width
                let frameHeight = frame.height
                
                VStack {
                    
                    makeTopBar(proxy: proxy)
                    
                    makeQuestion(frameWidth: frameWidth)
                    
                    Spacer()
                    
                    makePlayerList(frameHeight: frameHeight)
                }
            }
        }
        .sheet(isPresented: $presenter.viewModel.showEndGame, content: {
            
            EndGameView(context: presenter.generateEndGameContext()) {
                
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
    
    @ViewBuilder func makeQuestion(frameWidth: CGFloat) -> some View {
        
        let currentQuestion = presenter.viewModel.currentQuestion
        let answers = presenter.viewModel.answers
        
        ScrollView {
                
            VStack {
                
                Text(currentQuestion.category)
                    .lineLimit(1)
                    .font(.Shared.answerTitle)
                    .minimumScaleFactor(Constants.questionTextMinumumScaleFactor)
                    .foregroundColor(.white)
                    .animation(.default, value: currentQuestion.category)
                    .padding(.bottom)
                
                Text(currentQuestion.text)
                    .font(.Shared.question)
                    .minimumScaleFactor(Constants.questionTextMinumumScaleFactor)
                    .foregroundColor(.white)
                    .animation(.default, value: currentQuestion.text)
                    .padding(.bottom)
                    .frame(width: frameWidth * Constants.questionsWidthMultiplier)
                    
                ForEach(answers, id: \.id) { answer in
                    
                    Text(answer.text)
                        .font(.Shared.answer)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: frameWidth * Constants.questionsWidthMultiplier)
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
            .animation(.default, value: currentQuestion.text)
            .padding()
        }
    }
}

// MARK: - Players

private extension GameView {
    
    @ViewBuilder func makePlayerList(frameHeight: CGFloat) -> some View {
        
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
                    .frame(height: frameHeight * Constants.PlayerBubbleHeightMultiplier)
                    .animation(.default, value: player.isPlaying)
                }
            }
            .frame(height: frameHeight * Constants.playerFrameHeightMultiplier)
            .padding([.leading, .trailing])
        }
    }
}

private extension GameView {
    
    enum Constants {
        
        static let questionsWidthMultiplier: CGFloat = 0.9
        static let PlayerBubbleHeightMultiplier: CGFloat = 0.13
        static let playerFrameHeightMultiplier: CGFloat = 0.15
        
        static let questionTextMinumumScaleFactor: CGFloat = 0.3
    }
}
