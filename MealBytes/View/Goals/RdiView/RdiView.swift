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
                .scrollDismissesKeyboard(.never)
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
                .alert("Error", isPresented: $rdiViewModel.showAlert) {
                    Button("OK", role: .none) {
                        rdiViewModel.showAlert = false
                    }
                } message: {
                    Text(rdiViewModel.alertMessage)
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
        case .age: "Enter Age"
        case .weight: "Enter Weight"
        case .height: "Enter Height"
        default: ""
        }
    }
}

enum RdiFocus: Hashable {
    case age
    case height
    case weight
}

#Preview {
    NavigationStack {
        RdiView()
    }
}
