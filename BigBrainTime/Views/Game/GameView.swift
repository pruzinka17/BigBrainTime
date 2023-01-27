//
//  GameView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 26.01.2023.
//

import SwiftUI

struct GameView: View {
    
    @Environment(\.dismiss) var dismissCurrentView
    
    @FocusState private var inFocus: Bool

    let game: Game
    
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
            }
        }
        .onAppear {
            
            inFocus = true
        }
    }
}

//MARK: - Game methods

private extension GameView {
    
    @ViewBuilder func makeQuestion() -> some View {
        
//        let columns = [
//            GridItem(.flexible()),
//            GridItem(.flexible())
//        ]
        
        VStack {
            
            
        }
        .padding()
    }
    
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
                
                ForEach(game.players, id: \.name) { player in
                    
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
                }
            }
            .padding()
        }
    }
}

struct GameView_Previews: PreviewProvider {

    static var previews: some View {
        
        let questions: [Question] = QuestionsBuilder().buildQuestions()

        GameView(
            game: Game(
                questions: questions,
                players: [
                    Player(id: UUID().uuidString, name: "haha", score: 0),
                    Player(id: UUID().uuidString, name: "cau", score: 80),
                    Player(id: UUID().uuidString, name: "ne", score: 100),
                    Player(id: UUID().uuidString, name: "haha", score: 0),
                    Player(id: UUID().uuidString, name: "cau", score: 80),
                    Player(id: UUID().uuidString, name: "ne", score: 100),
                    Player(id: UUID().uuidString, name: "haha", score: 0),
                    Player(id: UUID().uuidString, name: "cau", score: 80),
                    Player(id: UUID().uuidString, name: "ne", score: 100),
                    Player(id: UUID().uuidString, name: "haha", score: 0),
                    Player(id: UUID().uuidString, name: "cau", score: 80),
                    Player(id: UUID().uuidString, name: "haha", score: 0)
                ]
            )
        )
    }
}
