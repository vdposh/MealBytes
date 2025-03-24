//
//  GoalsView.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

struct GoalsView: View {
    var body: some View {
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
                            // Calculate RDI action
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text("You can also calculate your Recommended Daily Intake (RDI) manually by entering calories and macronutrient values such as fats, carbohydrates and proteins.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 10)
                    
                    RdiButtonView(
                        title: "Custom RDI",
                        backgroundColor: .customGreen,
                        action: {
                            // Custom RDI action
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .navigationBarTitle("Your Goals", displayMode: .inline)
    }
}

#Preview {
    NavigationStack {
        GoalsView()
    }
}
