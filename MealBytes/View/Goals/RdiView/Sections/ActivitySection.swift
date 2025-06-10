//
//  ActivitySection.swift
//  MealBytes
//
//  Created by Porshe on 08/06/2025.
//

import SwiftUI

struct ActivitySection: View {
    @Binding var selectedActivity: ActivityLevel

    var body: some View {
        Section {
            HStack {
                Picker("Activity", selection: $selectedActivity) {
                    ForEach(ActivityLevel.allCases, id: \.self) { level in
                        Text(level.rawValue)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(selectedActivity.accentColor)
            }
        } header: {
            Text("Activity Level")
        } footer: {
            Text("Select the necessary indicator based on daily activity level.")
        }
    }
}

#Preview {
    NavigationStack {
        RdiView()
    }
}
