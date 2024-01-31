//
//  XDismissButton.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 13/01/24.
//

import SwiftUI

struct XDismissButton: View {
    
    @Binding var isShowingAddRecipeView: Bool
    
    var body: some View {
        HStack() {
            Spacer()
            
            Button {
                isShowingAddRecipeView = false
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(Color(.label))
                    .imageScale(.large)
                    .frame(width: 44, height: 44)
            }
        }
        .padding()
    }
}

#Preview {
    XDismissButton(isShowingAddRecipeView: .constant(false))
}
