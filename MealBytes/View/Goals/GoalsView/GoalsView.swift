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
                NavigationLink(destination: RdiView()) {
                    Text("Calculate RDI")
                }
            } footer: {
                Text("MealBytes calculates your Recommended Daily Intake (RDI) to provide you with a daily calorie target tailored to help you achieve your desired weight.")
            }
            
            Section {
                NavigationLink(destination: CustomRdiView()) {
                    Text("Custom RDI")
                }
            } footer: {
                Text("You can also calculate your RDI manually by entering calories and macronutrient values such as fats, carbohydrates and proteins.")
            }
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        GoalsView()
    }
    .accentColor(.customGreen)
}
