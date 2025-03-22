//
//  GoalsView.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

struct GoalsView: View {
    @State private var calories: String = ""
    @State private var fat: String = ""
    @State private var carbohydrate: String = ""
    @State private var protein: String = ""
    @State private var isUsingPercentage: Bool = true
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        List {
            Section {
                VStack {
                    HStack(alignment: .bottom) {
                        ServingTextFieldView(text: $calories, title: "Calories")
                        .padding(.trailing, 5)
                        Text("kcal")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 5)
                    
                    
                    Text("MealBytes calculates your Recommended Daily Intake (RDI) to provide you with a daily calorie target tailored to help you achieve your desired weight.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 10)
                    
                    HStack {
                        Button(action: {
                            //переход к анкете
                        }) {
                            Text("Calculate My RDI")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.customGreen)
                                .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, 5)
                    }
                }
            }
            
            Section {
                HStack(alignment: .bottom) {
                    ServingTextFieldView(text: $fat, title: "Fat")
                        .padding(.top, 5)
                    Text(isUsingPercentage ? "g" : "%")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .frame(width: 20, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                }

                
                HStack(alignment: .bottom) {
                    ServingTextFieldView(text: $carbohydrate, title: "Carbohydrate")
                    Text(isUsingPercentage ? "g" : "%")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .frame(width: 20, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack(alignment: .bottom) {
                    ServingTextFieldView(text: $protein, title: "Protein")
                    Text(isUsingPercentage ? "g" : "%")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .frame(width: 20, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Button(action: {
                        isUsingPercentage.toggle()
                    }) {
                        Text(isUsingPercentage ? "Use %" : "Use grams")
                            .font(.headline)
                            .foregroundColor(.customGreen)
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom, 10)
                }
            }
            .listRowSeparator(.hidden)
        }
        .listSectionSpacing(15)
        .scrollDismissesKeyboard(.never)
        .navigationBarTitle("Search", displayMode: .large)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Text("Enter value")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button("Done") {
                    isTextFieldFocused = false
                }
            }
        }
    }
}

#Preview {
    GoalsView()
}
