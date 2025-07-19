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
        VStack(alignment: .leading) {
            Text("Activity Level".uppercased())
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
            
            HStack {
                Text("Activity")
                    .padding(.leading, 20)
                
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
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 10)
            }
            .padding(.vertical, 5)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(14)
            .padding(.horizontal, 20)
            
            Text("Select the necessary indicator based on daily activity level.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 25)
    }
}

enum Activity: String, CaseIterable {
    case notSelected = "Not selected"
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"
    case extraActive = "Extra Active"
    
    var accentColor: Color {
        switch self {
        case .notSelected:
            return .customRed
        default:
            return .customGreen
        }
    }
}

#Preview {
    let mainViewModel = MainViewModel()
    let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)
    
    return NavigationStack {
        RdiView(rdiViewModel: rdiViewModel)
    }
}
