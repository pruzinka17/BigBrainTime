//
//  AddPlayerTextFieldStyle.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 27.01.2023.
//

import SwiftUI

struct AddPlayerTextFieldStyle: TextFieldStyle {
    
    let proxy: GeometryProxy
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        
        let frame = proxy.frame(in: .local)
        
        configuration
            .multilineTextAlignment(.center)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .foregroundColor(.black)
            .padding()
            .background {
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: frame.width / 1.5, height: frame.height / 15)
                    .foregroundColor(.white)
            }
            .padding()
            .submitLabel(.continue)
    }
}
