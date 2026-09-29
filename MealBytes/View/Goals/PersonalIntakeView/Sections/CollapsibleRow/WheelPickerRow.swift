//
//  WheelPickerRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 28.09.2026.
//

import SwiftUI
import UIKit

struct WheelPickerRow<Unit: Hashable & RawRepresentable>: UIViewRepresentable
where Unit.RawValue == String, Unit: CaseIterable {
    @Binding var text: String
    @Binding var selectedUnit: Unit
    let integerRange: (Unit) -> ClosedRange<Int>
    let minValue: (Unit) -> Int
    
    private enum Component: Int {
        case integer = 0
        case fraction = 1
        case unit = 2
    }
    
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ picker: UIPickerView, context: Context) {
        context.coordinator.parent = self
        
        let value = text.doubleValue ?? 0
        let intValue = Int(value)
        let fraction = Int(((value - floor(value)) * 10).rounded())
        let unitIndex = Array(Unit.allCases).firstIndex(of: selectedUnit) ?? 0
        
        let range = integerRange(selectedUnit)
        
        picker.selectRow(
            max(0, intValue - range.lowerBound),
            inComponent: Component.integer.rawValue,
            animated: false
        )
        picker.selectRow(
            min(9, max(0, fraction)),
            inComponent: Component.fraction.rawValue,
            animated: false
        )
        picker.selectRow(
            unitIndex,
            inComponent: Component.unit.rawValue,
            animated: false
        )
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent: WheelPickerRow
        
        init(_ parent: WheelPickerRow) {
            self.parent = parent
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            3
        }
        
        func pickerView(
            _ pickerView: UIPickerView,
            numberOfRowsInComponent component: Int
        ) -> Int {
            switch Component(rawValue: component) {
            case .integer:
                return parent.integerRange(parent.selectedUnit).count
            case .fraction:
                return 10
            case .unit:
                return Array(Unit.allCases).count
            case .none:
                return 0
            }
        }
        
        func pickerView(
            _ pickerView: UIPickerView,
            widthForComponent component: Int
        ) -> CGFloat {
            switch Component(rawValue: component) {
            case .integer: return pickerView.bounds.width * 0.4
            case .fraction: return pickerView.bounds.width * 0.2
            case .unit: return pickerView.bounds.width * 0.4
            case .none: return 0
            }
        }
        
        func pickerView(
            _ pickerView: UIPickerView,
            viewForRow row: Int,
            forComponent component: Int,
            reusing view: UIView?
        ) -> UIView {
            let label = (view as? UILabel) ?? UILabel()
            label.font = UIFont.preferredFont(forTextStyle: .title3)
            label.textAlignment = .center
            label.textColor = .label
            
            switch Component(rawValue: component) {
            case .integer:
                let range = parent.integerRange(parent.selectedUnit)
                label.text = "\(range.lowerBound + row)"
            case .fraction:
                label.text = "\(row)"
            case .unit:
                label.text = Array(Unit.allCases)[row].rawValue
            case .none:
                label.text = ""
            }
            
            return label
        }
        
        func pickerView(
            _ pickerView: UIPickerView,
            didSelectRow row: Int,
            inComponent component: Int
        ) {
            let range = parent.integerRange(parent.selectedUnit)
            let intValue = range.lowerBound + pickerView.selectedRow(
                inComponent: Component.integer.rawValue
            )
            let fraction = pickerView.selectedRow(
                inComponent: Component.fraction.rawValue
            )
            let unitIndex = pickerView.selectedRow(
                inComponent: Component.unit.rawValue
            )
            let newUnit = Array(Unit.allCases)[unitIndex]
            
            if newUnit != parent.selectedUnit {
                parent.selectedUnit = newUnit
                parent.text = Double(parent.minValue(newUnit))
                    .asDecimal(grouping: false)
            } else {
                parent.text = (Double(intValue) + Double(fraction) / 10)
                    .asDecimal(grouping: false)
            }
            
            pickerView.reloadAllComponents()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewGoalsView.goalsView
}
