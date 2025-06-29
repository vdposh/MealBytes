//
//  RdiView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

struct RdiView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: RdiFocus?
    @StateObject private var rdiViewModel = RdiViewModel()
    
    var body: some View {
        ZStack {
            if rdiViewModel.isDataLoaded {
                ScrollViewReader { proxy in
                    List {
                        OverviewSection(rdiViewModel: rdiViewModel)
                        AgeSection(
                            focusedField: _focusedField,
                            rdiViewModel: rdiViewModel
                        )
                        GenderSection(rdiViewModel: rdiViewModel)
                        ActivitySection(rdiViewModel: rdiViewModel)
                        WeightSection(
                            focusedField: _focusedField,
                            rdiViewModel: rdiViewModel
                        )
                        HeightSection(
                            focusedField: _focusedField,
                            rdiViewModel: rdiViewModel
                        )
                    }
                    .navigationBarTitle("RDI", displayMode: .inline)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Text(toolbarTitle)
                                .foregroundColor(.secondary)
                            
                            Button("Done") {
                                focusedField = nil
                            }
                            .font(.headline)
                        }
                        
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                if rdiViewModel.handleSave() {
                                    Task {
                                        await rdiViewModel.saveRdiView()
                                    }
                                    dismiss()
                                }
                            }
                        }
                    }
                    .onChange(of: focusedField) {
                        guard let field = focusedField else { return }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation {
                                proxy.scrollTo(field.scrollID,
                                               anchor: field.scrollAnchor)
                            }
                        }
                    }
                    .alert("Error", isPresented: $rdiViewModel.showAlert) {
                        Button("OK") {
                            rdiViewModel.showAlert = false
                        }
                    } message: {
                        Text(rdiViewModel.alertMessage)
                    }
                }
            } else {
                LoadingView()
                    .task {
                        await rdiViewModel.loadRdiView()
                    }
            }
        }
    }
    
    // MARK: - Keyboard
    private var toolbarTitle: String {
        switch focusedField {
        case .age: "Age"
        case .weight: "Weight"
        case .height: "Height"
        default: ""
        }
    }
}

enum RdiFocus: Hashable {
    case age
    case height
    case weight
    
    var scrollID: String {
        switch self {
        case .age: "ageField"
        case .weight: "weightField"
        case .height: "heightField"
        }
    }
    
    var scrollAnchor: UnitPoint {
        switch self {
        case .age: .bottom
        case .weight: .top
        case .height: .top
        }
    }
}

#Preview {
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel(),
        goalsViewModel: GoalsViewModel()
    )
    .environmentObject(ThemeManager())
}

#Preview {
    NavigationStack {
        RdiView()
    }
}
