//
//  ActivitySection.swift
//  MealBytes
//
//  Created by Porshe on 08/06/2025.
//

import SwiftUI

struct ActivitySection: View {
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section {
            HStack {
                Picker("Activity", selection: $rdiViewModel.selectedActivity) {
                    if rdiViewModel.selectedActivity == .notSelected {
                        Text("Not Selected").tag(Activity.notSelected)
                    }
                    ForEach(Activity.allCases.filter { $0 != .notSelected },
                            id: \.self) { level in
                        Text(level.rawValue).tag(level)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(rdiViewModel.selectedActivity.accentColor)
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
