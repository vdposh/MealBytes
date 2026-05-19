//
//  ServingTextFieldView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/03/2025.
//

import SwiftUI

struct ServingTextFieldView: View {
    @Binding var text: String
    @FocusState private var focus: Bool
    var placeholder: String = "amount"
    var labelIconName: String = "plus.forwardslash.minus"
    var stackText: String = ""
    var trailingUnit: String? = nil
    var useLabel: Bool = false
    var useStack: Bool = false
    var keyboardType: UIKeyboardType = .decimalPad
    var inputMode: InputMode = .decimal
    var maxInteger: Int = 100000
    var maxFractionalDigits: Int = 2
    var maxIntegerDigits: Int = 4
    
    private var decimalSeparator: String {
        Locale.current.decimalSeparator ?? "."
    }
    
    var body: some View {
        let field = TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .focused($focus)
            .onChange(of: text) {
                validateInput(&text)
            }
            .onChange(of: focus) {
                if !focus {
                    finalizeInput(&text)
                }
            }
            .overlay(alignment: .trailing) {
                if let trailingUnit, !text.isEmpty {
                    Text(trailingUnit)
                        .foregroundStyle(.tertiary)
                }
            }
        
        Group {
            if useLabel {
                Label {
                    field
                } icon: {
                    Image(systemName: labelIconName)
                        .font(.system(size: 18))
                        .foregroundStyle(.customGray)
                        .symbolColorRenderingMode(.gradient)
                }
            } else if useStack {
                HStack {
                    Text(stackText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    field
                        .containerRelativeFrame(.horizontal) {
                            length,
                            _ in length * 0.5
                        }
                }
            } else {
                field
            }
        }
        .overlay(
            Button {
                focus = true
            } label: {
                Color.clear
            }
        )
        .buttonStyle(.borderless)
        .focused($focus)
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
