//
//  GoalsView.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

struct GoalsView: View {
    @State private var isNavigatingToCustomRdiView: Bool = false
    @State private var isNavigatingToRdiView: Bool = false
    
    let goalsViewModel: GoalsViewModel
    
    init(goalsViewModel: GoalsViewModel) {
        self.goalsViewModel = goalsViewModel
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("MealBytes calculates your Recommended Daily Intake (RDI) to provide you with a daily calorie target tailored to help you achieve your desired weight.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 10)
                        
                        RdiButtonView(
                            title: "Calculate RDI",
                            backgroundColor: .customGreen,
                            action: {
                                isNavigatingToRdiView = true
                            }
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("You can also calculate your RDI manually by entering calories and macronutrient values such as fats, carbohydrates and proteins.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 10)
                        
                        RdiButtonView(
                            title: "Custom RDI",
                            backgroundColor: .customGreen,
                            action: {
                                isNavigatingToCustomRdiView = true
                            }
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            .navigationBarTitle("Your Goals", displayMode: .inline)
            .navigationDestination(isPresented: $isNavigatingToRdiView) {
                RdiView(rdiViewModel: goalsViewModel.rdiViewModel)
            }
            .navigationDestination(isPresented: $isNavigatingToCustomRdiView) {
                CustomRdiView(
                    customRdiViewModel: goalsViewModel.customRdiViewModel
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        GoalsView(
            goalsViewModel: GoalsViewModel(
                customRdiViewModel: CustomRdiViewModel(
                    firestoreManager: FirestoreManager(),
                    mainViewModel: MainViewModel(
                        firestoreManager: FirestoreManager()
                    )
                ),
                rdiViewModel: RdiViewModel(
                    firestoreManager: FirestoreManager(),
                    mainViewModel: MainViewModel(
                        firestoreManager: FirestoreManager()
                    )
                )
            )
        )
    }
    .accentColor(.customGreen)
}
