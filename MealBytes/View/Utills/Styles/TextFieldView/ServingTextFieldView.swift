//
//  ServingTextFieldView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/03/2025.
//

import SwiftUI

struct ServingTextFieldView<Focus: Hashable>: View {
    @Binding var text: String
    
    let focus: FocusState<Focus?>.Binding
    let focusCase: Focus
    
    var placeholder: String = "0"
    var unitText: String = ""
    var labelIconName: String = ""
    var labelIconColor: Color = .customGray
    var stackText: String = ""
    var useLabel: Bool = false
    var keyboardType: UIKeyboardType = .decimalPad
    var inputMode: InputMode = .decimal
    var maxInteger: Int = 100000
    var maxFractionalDigits: Int = 2
    var maxIntegerDigits: Int = 4
    
    var body: some View {
        contentServingTextField
            .overlay {
                focusOverlay
            }
    }
    
    private var field: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .focused(focus, equals: focusCase)
            .onChange(of: text) {
                validateInput(&text)
            }
            .onChange(of: focus.wrappedValue) {
                if focus.wrappedValue != focusCase {
                    finalizeInput(&text)
                }
            }
    }
    
    @ViewBuilder
    private var contentServingTextField: some View {
        if useLabel {
            Label {
                HStack {
                    Text(stackText)
                    
                    HStack(spacing: 4) {
                        field
                            .multilineTextAlignment(.trailing)
                        
                        Text(unitText)
                            .foregroundStyle(
                                text.isEmpty
                                ? Color(.placeholderText)
                                : .primary
                            )
                    }
                }
            } icon: {
                Image(systemName: labelIconName)
                    .fontWeight(.semibold)
                    .foregroundStyle(labelIconColor)
            }
        } else {
            HStack {
                Text("Amount")
                
                field
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    @ViewBuilder
    private var focusOverlay: some View {
        if focus.wrappedValue != focusCase {
            Button {
                focus.wrappedValue = focusCase
            } label: {
                Color.clear
            }
            .buttonStyle(.borderless)
        }
    }
    
    private var decimalSeparator: String {
        Locale.current.decimalSeparator ?? "."
    }
    
    private func validateInput(_ input: inout String) {
        switch inputMode {
        case .decimal:
            let separator = decimalSeparator
            
            input = input.filter { $0.isNumber || String($0) == separator }
            
            let separatorCount = input.filter { String($0) == separator }.count
            if separatorCount > 1 {
                input = String(input.dropLast())
                return
            }
            
            let components = input.split(separator: Character(separator))
            
            if let intPart = components.first,
               intPart.count > maxIntegerDigits {
                let trimmedIntPart = String(intPart.prefix(maxIntegerDigits))
                if components.count > 1, let lastComponent = components.last {
                    input = "\(trimmedIntPart)\(separator)\(lastComponent)"
                } else {
                    input = trimmedIntPart
                }
                return
            }
            
            if components.count > 1,
               let intPart = components.first,
               let fracPart = components.last {
                let trimmedFracPart = String(
                    fracPart.prefix(maxFractionalDigits)
                )
                input = "\(intPart)\(separator)\(trimmedFracPart)"
            }
            
            if let doubleVal = input.doubleValue,
               doubleVal > Double(maxInteger) {
                input = "\(maxInteger)"
            }
            
        case .integer:
            input = input.filter { $0.isNumber }
            
            if input.count > maxIntegerDigits {
                input = String(input.prefix(maxIntegerDigits))
            }
            
            if let intVal = Int(input), intVal > maxInteger {
                input = "\(maxInteger)"
            }
        }
    }
    
    private func finalizeInput(_ input: inout String) {
        switch inputMode {
        case .decimal:
            let separator = decimalSeparator
            
            if input.hasSuffix(separator) {
                input.removeLast()
                return
            }
            
            let components = input.split(separator: Character(separator))
            if components.count > 1,
               let firstComponent = components.first,
               let lastComponent = components.last {
                var fracPart = String(lastComponent)
                while fracPart.hasSuffix("0") {
                    fracPart.removeLast()
                }
                if fracPart.isEmpty {
                    input = String(firstComponent)
                } else {
                    input = "\(firstComponent)\(separator)\(fracPart)"
                }
            }
            
        case .integer:
            break
        }
    }
    
    enum InputMode {
        case decimal
        case integer
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewGoalsView.goalsView
}

#Preview {
    PreviewFoodView.foodView
}
