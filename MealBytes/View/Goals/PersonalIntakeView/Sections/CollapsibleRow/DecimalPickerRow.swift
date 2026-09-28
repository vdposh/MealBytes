//
//  DecimalPickerRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 28.09.2026.
//

import SwiftUI

struct DecimalPickerRow<Unit: Hashable & RawRepresentable>: View
where Unit.RawValue == String, Unit: CaseIterable {
    @Binding var text: String
    @Binding var selectedUnit: Unit
    let integerRange: (Unit) -> ClosedRange<Int>
    let minValue: (Unit) -> Int
    
    var body: some View {
        HStack(spacing: 0) {
            Picker("Integer", selection: integerBinding) {
                ForEach(integerRange(selectedUnit), id: \.self) { value in
                    Text("\(value)").tag(value)
                }
            }
            .pickerStyle(.wheel)
            .containerRelativeFrame(.horizontal) { length, _ in
                length * 0.4
            }
            
            Picker("Fraction", selection: fractionBinding) {
                ForEach(0...9, id: \.self) { value in
                    Text("\(value)").tag(value)
                }
            }
            .pickerStyle(.wheel)
            .containerRelativeFrame(.horizontal) { length, _ in
                length * 0.2
            }
            
            Picker("Unit", selection: $selectedUnit) {
                ForEach(Array(Unit.allCases), id: \.self) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            .pickerStyle(.wheel)
            .containerRelativeFrame(.horizontal) { length, _ in
                length * 0.4
            }
            .onChange(of: selectedUnit) {
                text = Double(minValue(selectedUnit))
                    .asDecimal(grouping: false)
            }
        }
    }
    
    private var value: Double {
        text.doubleValue ?? 0
    }
    
    private var integerBinding: Binding<Int> {
        Binding(
            get: { Int(value) },
            set: { newValue in
                let fraction = fractionBinding.wrappedValue
                let result = Double(newValue) + Double(fraction) / 10
                text = result.asDecimal(grouping: false)
            }
        )
    }
    
    private var fractionBinding: Binding<Int> {
        Binding(
            get: {
                let fraction = (value - floor(value)) * 10
                return Int(fraction.rounded())
            },
            set: { newValue in
                let integer = integerBinding.wrappedValue
                let result = Double(integer) + Double(newValue) / 10
                text = result.asDecimal(grouping: false)
            }
        )
    }
}

#Preview {
    PreviewGoalsView.goalsView
}
