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
                            
                            makePlayers()
                        }
                        
                        Spacer()
                        
                        makeCharts(proxy: proxy)
                    }
                    .padding()
                    
                    //TODO: - add next tab with all questions
                    
                    makeAllQuestions()
                }
                .tabViewStyle(.page)
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
    
    @ViewBuilder func makeAllQuestions() -> some View {
        
        let questions = presenter.viewModel.gameQuestions
            
        VStack {
            
            ScrollView(showsIndicators: false) {
                
                ForEach(questions, id: \.text) { question in
                    
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
                        
                        LazyVGrid(columns: columns) {
                            
                            ForEach(question.answers) { answer in
                                
                                Text(answer.value)
                                    .foregroundColor(answer.isCorrect ? .green : .red)
                            }
                        }
                        .padding(.top)
                    }
                }
            }
        }
        .padding()
    }
    
    //MARK: - Players
    
    @ViewBuilder func makePlayers() -> some View {
        
        let players =  presenter.viewModel.players.sorted(by: { $0.score > $1.score } )
        
        VStack {
            
            ForEach(players, id: \.name) { player in
                
                DisclosureGroup {
                    
                    ScrollView(showsIndicators: false) {
                        
                        VStack {
                            
                            ForEach(player.questions, id: \.text) { question in
                                
                                Text(question.text)
                                    .foregroundColor(.black)
                                Text(question.value)
                                    .foregroundColor(.blue)
                                Text(question.correct)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                } label: {
                    
                    HStack {
                        
                        Text(player.name)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(String(player.score))
                            .foregroundColor(.white)
                    }
                }
                .foregroundColor(.black)
            }
        }
    }
    
    //MARK: - Charts
    
    @ViewBuilder func makeCharts(proxy: GeometryProxy) -> some View {
        
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
                                .foregroundColor(.white)
                        }
                    
                }
                //.chartYScale(domain: 0...presenter.viewModel.maxScore)
                .frame(height: proxy.frame(in: .local).height * 0.3)
            }
            
            //TODO: - add more graphs
            
            VStack {
                
            }
        }
        .tabViewStyle(.page)
    }
}
