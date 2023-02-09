//
//  EndGameView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 08.02.2023.
//

import SwiftUI

struct listItemModel: Identifiable {
    
    let id = UUID()
    let name: String
    let answers: [Answer]
    
}

struct Answer {
    
    let question: String
    let playerAnswer: String
    let correctAnswer: String
}

struct GameEndView: View {

    @Environment(\.dismiss) var dismissCurrentView
    
    let players: [Player]
    let questions: [Question]
    let playerAnswers: [String: String]

    private let onFinish: () -> Void

    init(
        players: [Player],
        questions: [Question],
        answers: [String: String],
        onFinish: @escaping () -> Void
    ) {

        self.players = players
        self.questions = questions
        self.playerAnswers = answers
        self.onFinish = onFinish
    }

    var body: some View {
        
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            VStack {
                
                ForEach(questions, id: \.text) { question in
                    
                    ForEach(players) { player in
                        
                        let answerId = playerAnswers[player.id]
                        let playerAnswer = question.answers.first(where: { $0.id == answerId })
                        
                        HStack {
                            
                            Text(playerAnswer!.value)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text(question.text)
                                .foregroundColor(.white)
                        }
                        
                    }
                }
                
                List(players) { player in
                    
                    HStack {
                        
                        Text(player.name)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(String(player.score))
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                
                Button("Okay") {

                    onFinish()
                    dismissCurrentView()
                }
            }
        }
        .interactiveDismissDisabled()
    }
}
//
//private extension GameEndView {
//
//    func generateListItems() -> [listItemModel] {
//
//        let listItem: [listItemModel] = []
//
//        ForEach(players) { player in
//
//            let answers = pla
//        }
//
//        return listItem
//    }
//}
