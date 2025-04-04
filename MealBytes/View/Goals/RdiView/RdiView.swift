//
//  RdiView.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

struct RdiView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Bool
    @StateObject private var rdiViewModel = RdiViewModel()
    
    var body: some View {
        ZStack {
            if rdiViewModel.isDataLoaded {
                List {
                    OverviewSection(rdiViewModel: rdiViewModel)
                    BasicInfoSection(
                        focusedField: _focusedField,
                        rdiViewModel: rdiViewModel
                    )
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
                        Text("Enter value")
                            .foregroundColor(.secondary)
                        Button("Done") {
                            focusedField = false
                        }
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
}

#Preview {
    NavigationStack {
        RdiView()
    }
    .accentColor(.customGreen)
}
