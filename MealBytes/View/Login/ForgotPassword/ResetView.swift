//
//  ResetView.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI

struct ResetView: View {
    @StateObject private var resetViewModel = ResetViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Reset password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                LoginTextFieldView(text: $resetViewModel.email,
                                   placeholder: "Enter your email")
                
                LoginButtonView(title: "Send reset link on email", action: {
                    Task {
                        await resetViewModel.resetPassword()
                    }
                })
            }
            .padding()
            
            .alert(isPresented: $resetViewModel.showAlert) {
                resetViewModel.getAlert()
            }
        }
        .accentColor(.customGreen)
    }
}

#Preview {
    NavigationStack {
        ResetView()
    }
    .accentColor(.customGreen)
}
