//
//  ServingTextFieldView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/03/2025.
//

import SwiftUI

struct ServingTextFieldView: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    let title: String
    var showStar: Bool = true
    var placeholder: String = "Enter value"
    var keyboardType: UIKeyboardType = .decimalPad
    var titleColor: Color = .secondary
    var textColor: Color = .primary
    var maxInteger: Int = 100000
    var maxFractionalDigits: Int = 2
    var maxIntegerDigits: Int = 4
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                isFocused = true
            }) {
                HStack(spacing: 0) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(titleColor)
                    if showStar {
                        Text("*")
                            .foregroundColor(.customRed)
                    }
                }
                .frame(height: 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .frame(height: 35)
                .lineLimit(1)
                .foregroundColor(textColor)
                .focused($isFocused)
                .onChange(of: text) {
                    validateInput(&text)
                }
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .opacity(isFocused ? 1 : 0.6)
                        .foregroundColor(isFocused ? .customGreen : .secondary),
                    alignment: .bottom
                )
        }
    }
    
    private func validateInput(_ input: inout String) {
        input = input.replacingOccurrences(of: ".", with: ",")
        let components = input.split(separator: ",")
        
        if let intPart = components.first, intPart.count > maxIntegerDigits {
            input = String(intPart.prefix(maxIntegerDigits))
            return
        }
        
        if components.count > 1 {
            let fracPart = components.last ?? ""
            input = "\(components.first!),\(fracPart.prefix(maxFractionalDigits))"
        }
        
        let sanitizedInput = input.replacingOccurrences(of: ",", with: ".")
        if let doubleValue = Double(sanitizedInput),
           doubleValue > Double(maxInteger) {
            input = "\(maxInteger)".replacingOccurrences(of: ".", with: ",")
        }
        
        if input.hasSuffix(",00") {
            input.removeLast(3)
        }
    }
}

#Preview {
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel(),
        goalsViewModel: GoalsViewModel()
    )
    .environmentObject(ThemeManager())
}
