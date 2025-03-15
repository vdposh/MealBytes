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
                        Text("калории")
                    }
                    HStack {
                        Text("F")
                            .foregroundColor(.gray)
                            .font(.footnote)
                        Text("жиры")
                            .foregroundColor(.gray)
                            .font(.footnote)
                        Text("P")
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .padding(.leading)
                        Text("белки")
                            .foregroundColor(.gray)
                            .font(.footnote)
                        Text("C")
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .padding(.leading)
                        Text("углеводы")
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
