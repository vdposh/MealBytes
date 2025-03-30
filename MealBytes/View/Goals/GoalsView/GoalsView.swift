//
//  GoalsView.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

struct GoalsView: View {
    @StateObject var goalsViewModel = GoalsViewModel()
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            NavigationStack {
                VStack {
                    VStack(alignment: .leading) {
                        Text("MealBytes calculates your Recommended Daily Intake (RDI) to provide you with a daily calorie target tailored to help you achieve your desired weight.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                        
                        RdiButtonView(
                            title: "Calculate RDI",
                            backgroundColor: .customGreen,
                            action: {
                                goalsViewModel.navigationDestination = .rdiView
                            }
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.vertical)
                    
                    VStack(alignment: .leading) {
                        Text("You can also calculate your RDI manually by entering calories and macronutrient values such as fats, carbohydrates and proteins.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                        
                        RdiButtonView(
                            title: "Custom RDI",
                            backgroundColor: .customGreen,
                            action: {
                                goalsViewModel.navigationDestination =
                                    .customRdiView
                            }
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal, 20)
                .padding(.top)
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationBarTitle("Your Goals", displayMode: .inline)
                .navigationDestination(isPresented: Binding(
                    get: { goalsViewModel.navigationDestination != .none },
                    set: { if !$0 { goalsViewModel.navigationDestination = .none } }
                )) {
                    switch goalsViewModel.navigationDestination {
                    case .rdiView:
                        goalsViewModel.rdiView
                    case .customRdiView:
                        goalsViewModel.customRdiView
                    case .none:
                        EmptyView()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GoalsView()
    }
    .accentColor(.customGreen)
}
