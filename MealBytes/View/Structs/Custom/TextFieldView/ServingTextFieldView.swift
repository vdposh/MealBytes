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
    var inputMode: InputMode = .decimal
    var titleColor: Color = .secondary
    var textColor: Color = .primary
    var opacity: Double = 1.0
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
                .onChange(of: isFocused) {
                    if !isFocused {
                        finalizeInput(&text)
                    }
                }
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .opacity(opacity)
                        .foregroundColor(isFocused ? .customGreen : .secondary),
                    alignment: .bottom
                )
        }
    }
    
    private func validateInput(_ input: inout String) {
        switch inputMode {
        case .decimal:
            input = input.preparedForLocaleDecimal
            let components = input.split(separator: ",")
            
            if let intPart = components.first,
               intPart.count > maxIntegerDigits {
                input = String(intPart.prefix(maxIntegerDigits))
                return
            }
            
            if components.count > 1 {
                let fracPart = components.last ?? ""
                input = "\(components.first!),\(fracPart.prefix(maxFractionalDigits))"
            }
            
            let sanitized = input.sanitizedForDouble
            if let doubleVal = Double(sanitized),
               doubleVal > Double(maxInteger) {
                input = "\(maxInteger)".preparedForLocaleDecimal
            }
            
        case .integer:
            let separators: [Character] = [",", "."]
            if let separatorIndex = input.firstIndex(where: { separators.contains($0) }) {
                input = String(input[..<separatorIndex])
            }
            
            input = input.filter { $0.isNumber }
            
            if input.count > maxIntegerDigits {
                input = String(input.prefix(maxIntegerDigits))
            }
            
            if let intVal = Int(input),
               intVal > maxInteger {
                input = "\(maxInteger)"
            }
        }
    }
    
    private func finalizeInput(_ input: inout String) {
        switch inputMode {
        case .decimal:
            if input.hasSuffix(",") || input.hasSuffix(".") {
                input.removeLast()
                return
            }

            let suffixesToTrim = [",00", ".00", ",0", ".0"]
            for suffix in suffixesToTrim {
                if input.hasSuffix(suffix) {
                    input.removeLast(suffix.count)
                    return
                }
            }

            if let commaIndex = input.firstIndex(of: ",") {
                let fractional = input[commaIndex...]
                if fractional.hasSuffix("0") && fractional.count == 3 {
                    input.removeLast()
                }
            }

        case .integer:
            break
        }
    }
}

enum InputMode {
    case decimal
    case integer
}

#Preview {
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel(),
        goalsViewModel: GoalsViewModel()
    )
    .environmentObject(ThemeManager())
}
