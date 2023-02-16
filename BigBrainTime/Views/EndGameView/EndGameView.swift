//
//  EndGameView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 08.02.2023.
//

import SwiftUI
import Charts

struct EndGameView: View {

    @Environment(\.dismiss) var dismissCurrentView
    
    @ObservedObject var presenter: EndGameViewPresenter

    private let onFinish: () -> Void

    init(
        context: EndGameContext,
        onFinish: @escaping () -> Void
    ) {

        self.presenter = EndGameViewPresenter(context: context)
        self.onFinish = onFinish
    }

    var body: some View {
        
        ZStack {
            
            Color.Shared.background
                .ignoresSafeArea()
                
            GeometryReader { proxy in
                
                let frame = proxy.frame(in: .local)
                let frameWidth = frame.width
                let frameHeight = frame.height
             
                TabView {
                    
                    VStack {
                        
                        ScrollView(showsIndicators: false) {
                            
                            makePlayers(frameWidth: frameWidth)
                        }
                        
                        makeCharts(frameWidth: frameWidth, frameHeight: frameHeight)
                        
                        makeReturnButton(proxy: proxy)
                    }
                    
                    makeAllQuestions()
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .interactiveDismissDisabled()
        .onAppear {
            
            presenter.present()
        }
    }
}

private extension EndGameView {
    
    //MARK: - AllQuestions
    
    @ViewBuilder func makeQuestionTab(question: Question) -> some View {
        
        VStack {
            
            HStack {
                
                Text(question.category)
                    .font(.Shared.allQuestionsCategory)
                    .foregroundColor(.white)
                
                Spacer()
            }

            HStack {
                
                Text(question.text)
                    .font(.Shared.allQuestionsText)
                    .foregroundColor(.white)

                Spacer()
            }
            
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
            
            LazyVGrid(columns: columns, spacing: 20) {
                
                ForEach(question.answers) { answer in
                    
                    Text(answer.value)
                        .minimumScaleFactor(Constants.allQuestionsAnswersMinimulScaleFactor)
                        .lineLimit(Constants.allQuestionsAnswersLineLimit)
                        .multilineTextAlignment(.leading)
                        .fontWeight(.bold)
                        .foregroundColor(answer.isCorrect ? Color.Shared.correctQuestion : .red)
                }
            }
            .padding(.top)
        }
        .padding()
        .background {
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color.Shared.secondary)
        }
    }
    
    @ViewBuilder func makeAllQuestions() -> some View {
        
        let questions = presenter.viewModel.gameQuestions
            
        VStack {
            
            ScrollView(showsIndicators: false) {
                
                ForEach(questions, id: \.text) { question in
                    
                    makeQuestionTab(question: question)
                }
            }
        }
        .padding()
    }
    
    //MARK: - Players
    
    @ViewBuilder func makePlayers(frameWidth: CGFloat) -> some View {
        
        let players =  presenter.viewModel.players.sorted(by: { $0.score > $1.score } )
        let itemWidth = frameWidth * Constants.playerAnswersWidthMultiplier
        
        VStack {
            
            ForEach(players.indices, id: \.self) { index in
                
                let player = players[index]
                
                DisclosureGroup {
                    
                    ScrollView(showsIndicators: false) {
                        
                        VStack(spacing: 15) {
                            
                            ForEach(player.questions, id: \.text ) { question in
                                
                                makePlayerAnswers(question: question, width: itemWidth)
                            }
                        }
                        .padding(.top)
                    }
                } label: {
                    
                    HStack {
                        
                        Text("#\(player.place)")
                            .foregroundColor(.Shared.secondary)
                            .fontWeight(.bold)
                        
                        Text(player.name)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text(String(player.score))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
                .foregroundColor(.black)
            }
        }
        .padding()
    }
    
    @ViewBuilder func makePlayerAnswers(question: EndGameViewModel.Player.Question, width: CGFloat) -> some View{
        
        VStack(spacing: 10) {
            
            HStack {
                
                Text(question.text)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Text(Constants.playerAnswerText + question.value)
                .minimumScaleFactor(Constants.playerAnswersMinimumScaleFactor)
                .lineLimit(Constants.playerAnswersLineLimit)
                .foregroundColor(.red)
                .fontWeight(.bold)
            
            Text(Constants.correctAnswerText + question.correct)
                .minimumScaleFactor(Constants.playerAnswersMinimumScaleFactor)
                .lineLimit(Constants.playerAnswersLineLimit)
                .foregroundColor(Color.Shared.correctQuestion)
                .fontWeight(.bold)
        }
        .padding()
        .frame(width: width)
        .background {
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color.Shared.secondary)
        }
    }
    
    //MARK: - Charts
    
    @ViewBuilder func makeCharts(frameWidth: CGFloat, frameHeight: CGFloat) -> some View {
        
        let chartsHeight = frameHeight * Constants.chatstHeightMultiplier
        
        VStack {
            
            Text("Charts")
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            TabView {
                
                VStack {
                    
                    //MARK: - scoreChart
                    
                    Chart(presenter.viewModel.players, id: \.name) {
                        
                        BarMark(x: .value("Player", $0.name), y: .value("Score", $0.score ))
                            .foregroundStyle(by: .value("Player", $0.name))
                            .opacity(0.3)
                        
                        RuleMark(y: .value("Average", presenter.viewModel.averageScore))
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            .annotation(position: .top, alignment: .leading) {
                                
                                Text("Average \(presenter.viewModel.averageScore, format: .number)")
                                    .foregroundColor(.black)
                            }
                        
                    }
                    .chartYScale(domain: 0...presenter.viewModel.gameQuestions.count * Constants.score)
                }
                .padding()
                .frame(width: frameWidth * Constants.chartWidthMultiplier)
                .background {
                    
                    Color.white
                }
                
                VStack {
                    
                    //MARK: - correctAnswersChart
                    
                    Chart(presenter.viewModel.players, id: \.name) {
                        
                        BarMark(x: .value("Player", $0.name), y: .value("Questions Right", $0.score / 100))
                            .foregroundStyle(by: .value("Player", $0.name))
                    }
                }
                .padding()
                .frame(width: frameWidth * Constants.chartWidthMultiplier)
                .background {
                    
                    Color.white
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .frame(height: chartsHeight)
    }
    
    //MARK: - Return to game setup button
    
    @ViewBuilder func makeReturnButton(proxy: GeometryProxy) -> some View {
        
        let itemWidth = proxy.frame(in: .local).width * 0.5
        let itemHeight = proxy.frame(in: .local).height * 0.04
        
        Button(Constants.returnButtonTitle) {
            
            onFinish()
            dismissCurrentView()
        }
        .buttonStyle(MainButtonStyle(width: itemWidth, height: itemHeight))
        .fontWeight(.bold)
        .foregroundColor(Color.white)
        .padding(.top)
    }
}

private extension EndGameView {
    
    enum Constants {
        
        static let playerAnswerText: String = "Your answer: "
        static let correctAnswerText: String = "Correct Answer: "
        
        static let returnButtonTitle: String = "Return To Game Setup"
        
        static let score: Int = 100
        
        static let chartWidthMultiplier: CGFloat = 0.9
        
        static let playerAnswersMinimumScaleFactor: CGFloat = 0.6
        static let playerAnswersLineLimit: Int = 4
        
        static let allQuestionsAnswersMinimulScaleFactor: CGFloat = 0.7
        static let allQuestionsAnswersLineLimit: Int = 5
        
        static let playerAnswersWidthMultiplier: CGFloat = 0.9
        static let chatstHeightMultiplier: CGFloat = 0.3
    }
}
