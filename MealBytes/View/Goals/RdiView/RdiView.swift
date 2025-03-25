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
    
    @StateObject private var rdiViewModel: RdiViewModel
    
    init(rdiViewModel: RdiViewModel) {
        _rdiViewModel = .init(wrappedValue: rdiViewModel)
    }
    
    var body: some View {
        ZStack {
            if rdiViewModel.isDataLoaded {
                List {
                    overviewSection
                    basicInfoSection
                    weightSection
                    heightSection
                }
                .navigationBarTitle("RDI", displayMode: .inline)
                .scrollDismissesKeyboard(.never)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Text("Enter value")
                            .foregroundColor(.secondary)
                        Button("Done") {
                            dismissAllFocuses()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            Task {
                                await rdiViewModel.saveRdiView()
                                dismissAllFocuses()
                                rdiViewModel.saveGoalsAlert()
                            }
                        }
                    }
                }
                .alert(rdiViewModel.alertTitle(),
                       isPresented: $rdiViewModel.showAlert) {
                    Button("OK", role: .none) {
                        rdiViewModel.showAlert = false
                    }
                } message: {
                    Text(rdiViewModel.alertMessage)
                }
                .task {
                    await rdiViewModel.loadRdiView()
                }
            } else {
                LoadingView()
                    .task {
                        await rdiViewModel.loadRdiView()
                        await MainActor.run {
                            rdiViewModel.isDataLoaded = true
                        }
                    }
            }
        }
    }
    
    private var overviewSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 10) {
                Text("The RDI calculation is based on unique factors, including your age, weight, height, gender, and activity level.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 5)
                
                HStack {
                    Text(rdiViewModel.text(for: rdiViewModel.calculatedRdi))
                        .lineLimit(1)
                        .font(rdiViewModel.font(
                            for: rdiViewModel.calculatedRdi))
                        .foregroundColor(rdiViewModel.color(
                            for: rdiViewModel.calculatedRdi))
                        .fontWeight(rdiViewModel.weight(
                            for: rdiViewModel.calculatedRdi))
                    
                    RdiButtonView(
                        title: "Calculate",
                        backgroundColor: .customGreen,
                        action: {
                            dismissAllFocuses()
                            rdiViewModel.calculateRdi()
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .padding(.horizontal)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }
    
    private var basicInfoSection: some View {
        Section(header: Text("Basic Information")) {
            VStack(alignment: .leading, spacing: 15) {
                ServingTextFieldView(
                    text: $rdiViewModel.age,
                    title: "Age",
                    keyboardType: .decimalPad,
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.age)
                )
                .focused($isAgeFocused)
                
                HStack {
                    Text("Gender")
                        .font(.callout)
                    Picker("", selection: $rdiViewModel.selectedGender) {
                            ForEach(rdiViewModel.genders,
                                    id: \.self) { gender in
                                Text(gender).tag(gender as String?)
                            }
                        }
                }
                .frame(height: 30)
                
                HStack {
                    Text("Activity Level")
                        .font(.callout)
                    Picker("", selection: $rdiViewModel.selectedActivity) {
                            ForEach(rdiViewModel.activityLevels,
                                    id: \.self) { level in
                                Text(level).tag(level as String?)
                            }
                        }
                }
                .frame(height: 30)
            }
        }
    }
    
    private var weightSection: some View {
        Section(header: Text("Weight")) {
            VStack(alignment: .leading, spacing: 15) {
                ServingTextFieldView(
                    text: $rdiViewModel.weight,
                    title: "Weight",
                    keyboardType: .decimalPad,
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.weight)
                )
                .focused($isWeightFocused)
                
                Picker("Unit", selection: $rdiViewModel.selectedWeightUnit) {
                        ForEach(rdiViewModel.weightUnits,id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                    .font(.callout)
            }
        }
    }
    
    private var heightSection: some View {
        Section(header: Text("Height")) {
            VStack(alignment: .leading, spacing: 15) {
                ServingTextFieldView(
                    text: $rdiViewModel.height,
                    title: "Height",
                    keyboardType: .decimalPad,
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.height)
                )
                .focused($isHeightFocused)
                
                Picker("Unit", selection: $rdiViewModel.selectedHeightUnit) {
                        ForEach(rdiViewModel.heightUnits, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                    .font(.callout)
            }
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
        RdiView(
            rdiViewModel: RdiViewModel(
                firestoreManager: FirestoreManager(),
                mainViewModel: MainViewModel(
                    firestoreManager: FirestoreManager()
                )
            )
        )
    }
    .accentColor(.customGreen)
}
