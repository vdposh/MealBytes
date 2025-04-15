//
//  ServingTextFieldView.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

import SwiftUI

struct ServingTextFieldView: View {
    @Binding var text: String
    let title: String
    var placeholder: String = "Enter value"
    var keyboardType: UIKeyboardType = .decimalPad
    var titleColor: Color = .secondary
    var textColor: Color = .primary
    var maxInteger: Int = 99999
    var maxFractionalDigits: Int = 1
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
                .foregroundColor(titleColor) + Text("*")
                .foregroundColor(.customRed)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .frame(height: 35)
                .lineLimit(1)
                .foregroundColor(textColor)
                .onChange(of: text) {
                    validateInput(&text)
                }
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.secondary),
                    alignment: .bottom
                )
        }
    }
    
    private func validateInput(_ input: inout String) {
        input = input.replacingOccurrences(of: ".", with: ",")
        let components = input.split(separator: ",")
        
        if let intPart = components.first, intPart.count > 5 {
            input = String(intPart.prefix(5))
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
        
        if input.hasSuffix(",0") {
            input.removeLast(2)
        }
    }
}
