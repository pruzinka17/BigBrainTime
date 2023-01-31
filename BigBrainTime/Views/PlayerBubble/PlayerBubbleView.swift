//
//  PlayerBubbleView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 31.01.2023.
//

import SwiftUI

struct PlayerBubbleView: View {
    
    let name: String
    
    var body: some View {
        
        VStack {
            
            Circle()
                .foregroundColor(Color("color-playerbubble"))
                .overlay {
                    Text(String(name.prefix(1).uppercased()))
                        .font(.Shared.playerBubbleFont)
                }
            
            Text(name)
                .foregroundColor(.white)
                .font(.Shared.playerName)
        }
    }
}

struct PlayerBubbleView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        PlayerBubbleView(name: "mirek")
    }
}
