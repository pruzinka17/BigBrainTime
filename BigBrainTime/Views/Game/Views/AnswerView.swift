//
//  AnswerView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 30.01.2023.
//

import SwiftUI

struct AnswerView: View {
    
    let answer: Question.Answer
    
    let isSelected: Bool
    
    let onTap: () -> Void
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.clear)
            .padding()
            .overlay {
                Text(answer.value)
                    .foregroundColor(.white)
            }
            .background {
                
                isSelected ? Color.red : Color.black
            }
            .scaleEffect(isSelected ? 1.05 : 1)
            .animation(.default, value: isSelected)
            .onTapGesture {
                
                onTap()
            }
    }
}
