//
//  ShowHideButtonView.swift
//  MealBytes
//
//  Created by Porshe on 15/03/2025.
//

import SwiftUI

struct ShowHideButtonView: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button {
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            HStack {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.customGreen)
                Text(isExpanded ? "Hide" : "Show")
                    .foregroundColor(.customGreen)
            }
            .lineLimit(1)
            .font(.footnote)
            .frame(maxWidth: .infinity)
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel()
    )
}
