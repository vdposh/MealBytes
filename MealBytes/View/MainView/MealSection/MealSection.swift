//
//  MealSection.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct MealSection: View {
    let title: String
    let iconName: String
    let color: Color
    let calories: Double
    let fats: Double
    let proteins: Double
    let carbohydrates: Double
    private let formatter = Formatter()

    var body: some View {
        Section {
            NavigationLink(destination: SearchView()) {
                VStack(spacing: 10) {
                    HStack {
                        Label {
                            Text(title)
                        } icon: {
                            Image(systemName: iconName)
                                .foregroundColor(color)
                        }
                        Spacer()
                        Text(formatter.formattedValue(calories, unit: .empty))
                    }
                    
                    HStack {
                        Text("F")
                            .foregroundColor(.gray)
                            .font(.footnote)
                        Text(formatter.formattedValue(fats, unit: .empty))
                            .foregroundColor(.gray)
                            .font(.footnote)
                        
                        Text("P")
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .padding(.leading)
                        Text(formatter.formattedValue(proteins, unit: .empty))
                            .foregroundColor(.gray)
                            .font(.footnote)
                        
                        Text("C")
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .padding(.leading)
                        Text(formatter.formattedValue(carbohydrates, unit: .empty))
                            .foregroundColor(.gray)
                            .font(.footnote)
                        
                        Spacer()
                        Text("РСК")
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
                .padding(.vertical, 5)
                .padding(.trailing, 5)
            }
        }
    }
}

#Preview {
    MainView()
}
