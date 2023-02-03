//
//  AddPlayerTextFieldStyle.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 27.01.2023.
//

import SwiftUI

struct AddPlayerTextFieldStyle: TextFieldStyle {
    
    let size: CGSize
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        
        configuration
            .multilineTextAlignment(.center)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .foregroundColor(.black)
            .frame(width: size.width, height: size.height)
            .padding()
            .background {
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: size.width, height: size.height)
                    .foregroundColor(.white)
            }
            .padding()
            .submitLabel(.next)
    }
}
