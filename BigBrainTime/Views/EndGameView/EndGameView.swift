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
             
                TabView {
                    
                    VStack {
                        
                        ScrollView(showsIndicators: false) {
                            
                            makePlayers(proxy: proxy)
                        }
                        
                        makeCharts(proxy: proxy)
                            .padding()
                        
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
    }
    
    //MARK: - AllQuestions
    
    @ViewBuilder func makeQuestionTab(question: Question) -> some View {
        
        VStack {
            
            HStack {
                
                Text(question.category)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                
                Spacer()
            }

            HStack {
                
                Text(question.text)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .regular, design: .rounded))

                Spacer()
            }
            
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
            
            LazyVGrid(columns: columns, spacing: 20) {
                
                ForEach(question.answers) { answer in
                    
                    Text(answer.value)
                        .minimumScaleFactor(0.7)
                        .lineLimit(5)
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
    
    @ViewBuilder func makePlayerAnswers(question: EndGameViewModel.Player.Question, width: CGFloat) -> some View{
        
        VStack(spacing: 10) {
            
            HStack {
                
                Text(question.text)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Text(Constants.playerAnswerText + question.value)
                .minimumScaleFactor(0.6)
                .lineLimit(4)
                .foregroundColor(.red)
                .fontWeight(.bold)
            
            Text(Constants.correctAnswerText + question.correct)
                .minimumScaleFactor(0.6)
                .lineLimit(4)
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
    
    @ViewBuilder func makePlayers(proxy: GeometryProxy) -> some View {
        
        let players =  presenter.viewModel.players.sorted(by: { $0.score > $1.score } )
        let itemWidth = proxy.frame(in: .local).width * 0.9
        
        VStack {
            
            ForEach(players, id: \.name) { player in
                
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
    
    //MARK: - Charts
    
    @ViewBuilder func makeCharts(proxy: GeometryProxy) -> some View {
        
        VStack {
            
            TabView {
                
                VStack {
                    
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
                    .chartYScale(domain: 0...presenter.viewModel.gameQuestions.count * 100)
                }
                .padding()
                .background {
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.white)
                }
                
                VStack {
                    
                    Chart(presenter.viewModel.players, id: \.name) {
                        
                        BarMark(x: .value("Player", $0.name), y: .value("Questions Right", $0.score / 100))
                            .foregroundStyle(by: .value("Player", $0.name))
                    }
                }
                .padding()
                .background {
                    
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.white)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .frame(height: proxy.frame(in: .local).height * 0.3)
    }
}

private extension EndGameView {
    
    enum Constants {
        
        static let playerAnswerText: String = "Your answer: "
        static let correctAnswerText: String = "Correct Answer: "
        
        static let returnButtonTitle: String = "Return To Game Setup"
    }
}
