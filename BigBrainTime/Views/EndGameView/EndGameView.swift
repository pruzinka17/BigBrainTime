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
            
            Color.white
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                
                VStack {
                    
                    makePlayers()
                    
                    Spacer()
                    
                    makeCharts(proxy: proxy)
                }
                .padding()
            }
        }
        .interactiveDismissDisabled()
        .onAppear {
            
            presenter.present()
        }
    }
}

private extension EndGameView {
    
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
                        
                        Spacer()
                        
                        Text(String(player.score))
                    }
                }
                .foregroundColor(.black)
            }
        }
    }
    
    //MARK: - Charts
    
    @ViewBuilder func makeCharts(proxy: GeometryProxy) -> some View {
        
        VStack {
            
            Chart(presenter.viewModel.players, id: \.name) {
                
                BarMark(x: .value("Player", $0.name), y: .value("Score", $0.score ))
                    .foregroundStyle(by: .value("Player", $0.name))
                    .opacity(0.3)
                
                RuleMark(y: .value("Average", presenter.viewModel.averageScore))
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    .annotation(position: .top, alignment: .leading) {
                        
                        Text("Average \(presenter.viewModel.averageScore, format: .number)")
                    }
            }
            .chartYScale(domain: 0...presenter.viewModel.maxScore)
            .frame(height: proxy.frame(in: .local).height * 0.3)
        }
    }
}
