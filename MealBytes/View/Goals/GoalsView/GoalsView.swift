//
//  GoalsView.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

struct GoalsView: View {
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            NavigationStack {
                VStack {
                    VStack(alignment: .leading) {
                        Text("MealBytes calculates your Recommended Daily Intake (RDI) to provide you with a daily calorie target tailored to help you achieve your desired weight.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                        
                        NavigationLink(destination: RdiView()) {
                            RdiButtonView(
                                title: "Calculate RDI",
                                backgroundColor: .customGreen
                            )
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(.vertical)
                    
                    VStack(alignment: .leading) {
                        Text("You can also calculate your RDI manually by entering calories and macronutrient values such as fats, carbohydrates and proteins.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                        
                        NavigationLink(destination: CustomRdiView()) {
                            RdiButtonView(
                                title: "Custom RDI",
                                backgroundColor: .customGreen
                            )
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top)
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationBarTitle("Goals", displayMode: .inline)
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
