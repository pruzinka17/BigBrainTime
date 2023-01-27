//
//  AddPlayerTextFieldStyle.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 27.01.2023.
//

import SwiftUI

struct AddPlayerTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        
        configuration
            .multilineTextAlignment(.center)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .foregroundColor(.black)
            .padding()
            .overlay(content: {
                
                GeometryReader { proxy in
                    
                    let frame = proxy.frame(in: .local)
                    
                    Path { path in
                        
                        path.move(to: CGPoint(x: 0, y: frame.height))
                        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
                    }
                    .stroke(.black, lineWidth: 1)
                }
            })
            .shadow(radius: 3)
            .padding()
            .submitLabel(.next)
    }
}
