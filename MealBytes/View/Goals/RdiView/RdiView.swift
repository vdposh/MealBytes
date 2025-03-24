//
//  RdiView.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

struct RdiView: View {
    @FocusState private var isAgeFocused: Bool
    @FocusState private var isWeightFocused: Bool
    @FocusState private var isHeightFocused: Bool
    
    @StateObject private var viewModel: RdiViewModel
    
    init (viewModel: RdiViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text("The RDI calculation is based on unique factors, including your age, weight, height, gender, and activity level.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 5)
                    
                    HStack {
                        if !viewModel.calculatedRdi.isEmpty {
                            Text("\(viewModel.calculatedRdi) calories")
                                .lineLimit(1)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        Button(action: {
                            dismissAllFocuses()
                            viewModel.calculateRdi()
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
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.bottom, 5)
                }
            }
            
            Section(header: Text("Basic Information")) {
                VStack(alignment: .leading, spacing: 15) {
                    ServingTextFieldView(
                        text: $viewModel.age,
                        title: "Age",
                        keyboardType: .decimalPad,
                        titleColor: viewModel.fieldTitleColor(
                            for: viewModel.age)
                    )
                    .focused($isAgeFocused)
                    
                    HStack {
                        Text("Gender")
                        Picker("", selection: $viewModel.selectedGender) {
                            ForEach(viewModel.genders,
                                    id: \.self) { gender in
                                Text(gender).tag(gender as String?)
                            }
                        }
                    }
                    .frame(height: 30)
                    
                    HStack {
                        Text("Activity Level")
                        Picker("", selection: $viewModel.selectedActivity) {
                            ForEach(viewModel.activityLevels,
                                    id: \.self) { level in
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
                        text: $viewModel.weight,
                        title: "Weight",
                        keyboardType: .decimalPad,
                        titleColor: viewModel.fieldTitleColor(
                            for: viewModel.weight)
                    )
                    .focused($isWeightFocused)
                    
                    Picker("Unit", selection: $viewModel.selectedWeightUnit) {
                        ForEach(viewModel.weightUnits,
                                id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                }
            }
            
            Section(header: Text("Height")) {
                VStack(alignment: .leading, spacing: 15) {
                    ServingTextFieldView(
                        text: $viewModel.height,
                        title: "Height",
                        keyboardType: .decimalPad,
                        titleColor: viewModel.fieldTitleColor(
                            for: viewModel.height)
                    )
                    .focused($isHeightFocused)
                    
                    Picker("Unit", selection: $viewModel.selectedHeightUnit) {
                        ForEach(viewModel.heightUnits, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("RDI Calculator", displayMode: .inline)
        .scrollDismissesKeyboard(.never)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Text("Enter value")
                    .foregroundColor(.secondary)
                Button("Done") {
                    dismissAllFocuses()
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK", role: .none) { viewModel.showAlert = false }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
    private func dismissAllFocuses() {
        isAgeFocused = false
        isWeightFocused = false
        isHeightFocused = false
    }
}

#Preview {
    NavigationStack {
        RdiView(viewModel: RdiViewModel())
    }
    .accentColor(.customGreen)
}
