//
//  RdiViewModel.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

struct RdiViewModel: View {
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var age: String = ""
    @State private var selectedGender: String? = nil
    @State private var selectedActivityLevel: String? = nil
    @State private var selectedWeightUnit: String = "kg"
    @State private var selectedHeightUnit: String = "cm"
    @State private var calculatedRdi: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    let genders = ["Male", "Female"]
    let activityLevels = [
        "Sedentary",
        "Lightly Active",
        "Moderately Active",
        "Very Active",
        "Extra Active"
    ]
    let weightUnits = ["kg", "lbs"]
    let heightUnits = ["cm", "inches"]
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text("The RDI calculation is based on unique factors, including your age, weight, height, gender, and activity level.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 5)
                    
                    HStack {
                        if !calculatedRdi.isEmpty {
                            Text("\(calculatedRdi) calories")
                                .lineLimit(1)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            calculateRdi()
                        }) {
                            Text("Calculate RDI")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.customGreen)
                                .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.bottom, 5)
                }
            }
            
            Section(header: Text("Basic Information")) {
                VStack(alignment: .leading, spacing: 15) {
                    ServingTextFieldView(
                        text: $age,
                        title: "Age",
                        keyboardType: .decimalPad,
                        titleColor: fieldTitleColor(for: age)
                    )
                    
                    HStack {
                        Text("Gender")
                        Picker("", selection: $selectedGender) {
                            ForEach(genders, id: \.self) { gender in
                                Text(gender).tag(gender as String?)
                            }
                        }
                    }
                    .frame(height: 30)
                    
                    HStack {
                        Text("Activity Level")
                        Picker("", selection: $selectedActivityLevel) {
                            ForEach(activityLevels, id: \.self) { level in
                                Text(level).tag(level as String?)
                            }
                        }
                    }
                    .frame(height: 30)
                }
            }
            
            Section(header: Text("Weight")) {
                VStack(alignment: .leading, spacing: 15) {
                    ServingTextFieldView(
                        text: $weight,
                        title: "Weight",
                        keyboardType: .decimalPad,
                        titleColor: fieldTitleColor(for: weight)
                    )
                    Picker("Unit", selection: $selectedWeightUnit) {
                        ForEach(weightUnits, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                }
            }
            
            Section(header: Text("Height")) {
                VStack(alignment: .leading, spacing: 15) {
                    ServingTextFieldView(
                        text: $height,
                        title: "Height",
                        keyboardType: .decimalPad,
                        titleColor: fieldTitleColor(for: height)
                    )
                    Picker("Unit", selection: $selectedHeightUnit) {
                        ForEach(heightUnits, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("RDI Calculator", displayMode: .inline)
        .scrollDismissesKeyboard(.never)
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .none) { showAlert = false }
        } message: {
            Text(alertMessage)
        }
    }
    
    func validateInputs() -> String? {
        var errorMessages: [String] = []
        let inputs: [(String, String)] = [
            (age.sanitizedForDouble, "Enter a valid Age."),
            (weight.sanitizedForDouble, "Enter a valid Weight."),
            (height.sanitizedForDouble, "Enter a valid Height.")
        ]
        
        for (value, errorMessage) in inputs {
            switch true {
            case value.isEmpty,
                Double(value) == nil,
                Double(value) == 0:
                errorMessages.append(errorMessage)
            default:
                break
            }
        }
        
        if selectedGender == nil {
            errorMessages.append("Select a Gender.")
        }
        
        if selectedActivityLevel == nil {
            errorMessages.append("Select an Activity Level.")
        }
        
        switch errorMessages.isEmpty {
        case true:
            return nil
        case false:
            return errorMessages.joined(separator: "\n")
        }
    }
    
    private func calculateRdiInternal(weightValue: Double,
                                      heightValue: Double,
                                      ageValue: Double,
                                      gender: String,
                                      activityLevel: String) {
        let weightInKg = selectedWeightUnit == "lbs" ? weightValue * 0.453592 : weightValue
        let heightInCm = selectedHeightUnit == "inches" ? heightValue * 2.54 : heightValue
        
        let bmr: Double
        if gender == "Male" {
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * ageValue + 5
        } else {
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * ageValue - 161
        }
        
        let activityFactor: Double
        switch activityLevel {
        case "Sedentary": activityFactor = 1.2
        case "Lightly Active": activityFactor = 1.375
        case "Moderately Active": activityFactor = 1.55
        case "Very Active": activityFactor = 1.725
        case "Extra Active": activityFactor = 1.9
        default: activityFactor = 1.2
        }
        
        calculatedRdi = String(format: "%.0f", bmr * activityFactor)
    }
    
    func calculateRdi() {
        if let errors = validateInputs() {
            alertMessage = errors
            showAlert = true
            return
        }
        
        let sanitizedWeight = weight.sanitizedForDouble
        let sanitizedHeight = height.sanitizedForDouble
        let sanitizedAge = age.sanitizedForDouble
        
        guard let weightValue = Double(sanitizedWeight),
              let heightValue = Double(sanitizedHeight),
              let ageValue = Double(sanitizedAge),
              let gender = selectedGender,
              let activityLevel = selectedActivityLevel else {
            alertMessage = "There was an error processing the input values."
            showAlert = true
            return
        }
        
        calculateRdiInternal(weightValue: weightValue,
                             heightValue: heightValue,
                             ageValue: ageValue,
                             gender: gender,
                             activityLevel: activityLevel)
    }
    
    func fieldTitleColor(for field: String) -> Color {
        let sanitizedField = field.sanitizedForDouble
        switch true {
        case sanitizedField.isEmpty,
            Double(sanitizedField) == nil,
            Double(sanitizedField)! <= 0:
            return .customRed
        default:
            return .primary
        }
    }
}

#Preview {
    RdiViewModel()
}
