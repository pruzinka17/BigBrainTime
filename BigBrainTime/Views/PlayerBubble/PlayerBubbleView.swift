//
//  PlayerBubbleView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 31.01.2023.
//

import SwiftUI

struct PlayerBubbleView: View {
    
    let name: String
    let score: Int?
    
    let highlited: Bool
    let canBeDeleted: Bool
    
    let onTap: () -> Void
    
    var body: some View {
         
//        ZStack {
            
            VStack {
                
                Circle()
                    .foregroundColor(Color("color-playerbubble"))
                    .background(content: {
                        
                        if highlited {
                            
                            Circle()
                                .foregroundColor(Color("color-secondary"))
                                .scaleEffect(1.15)
                        }
                    })
                    .overlay {
                        Text(String(name.prefix(1).uppercased()))
                            .font(.Shared.playerBubbleFont)
                    }
                
                Text(name)
                    .foregroundColor(.white)
                    .font(.Shared.playerName)
                
                if score != nil {
                    
                    Text(String(score!))
                        .foregroundColor(.white)
                        .font(.Shared.playerName)
                }
            }
            
//            if canBeDeleted {
//
//                Circle()
//                    .offset(x: 33, y: -33)
//                    .frame(width: 20, height: 20)
//                    .onTapGesture {
//
//                        onTap()
//                    }
//            }
//        }
    }
}

//struct PlayerBubbleView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        PlayerBubbleView(name: "mirek", score: 100, highlited: false, canBeDeleted: true, proxy: Geo) {
//
//        }
//    }
//}
