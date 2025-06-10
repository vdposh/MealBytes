//
//  ActivitySection.swift
//  MealBytes
//
//  Created by Porshe on 08/06/2025.
//

import SwiftUI

struct ActivitySection: View {
    @Binding var selectedActivity: Activity
    
    var body: some View {
        Section {
            HStack {
                Picker("Activity", selection: $selectedActivity) {
                    if selectedActivity == .notSelected {
                        Text("Not Selected").tag(Activity.notSelected)
                    }
                    ForEach(Activity.allCases.filter { $0 != .notSelected },
                            id: \.self) { level in
                        Text(level.rawValue).tag(level)
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
