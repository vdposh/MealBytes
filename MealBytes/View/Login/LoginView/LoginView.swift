//
//  LoginView.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to MealBytes")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.customGreen, lineWidth: 1)
                )
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.customGreen, lineWidth: 1)
                )
            
            Button(action: {
                Task {
                    await viewModel.signIn()
                    showAlert = viewModel.error != nil
                }
            }) {
                Text("Login")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customGreen)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error?.errorDescription ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
    .accentColor(.customGreen)
}
