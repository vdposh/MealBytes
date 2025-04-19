//
//  ServingTextFieldView.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

import SwiftUI

struct ServingTextFieldView: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    let title: String
    let star: String = "*"
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
            HStack(spacing: 0) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(titleColor)
                if showStar {
                    Text(star)
                        .foregroundColor(.customRed)
                }
            }
            .frame(height: 15)
            
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
