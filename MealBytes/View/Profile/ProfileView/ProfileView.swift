//
//  ProfileView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/03/2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        profileViewContentBody
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private var profileViewContentBody: some View {
        Form {
            AccountSection(profileViewModel: profileViewModel)
            
            Section {
                ThemePickerSection()
            }
            
            Section {
                Toggle("Goals", isOn: Binding(
                    get: { profileViewModel.displayGoals },
                    set: { newValue in
                        Task {
                            await profileViewModel.setDisplayGoals(newValue)
                        }
                    }
                ))
            } footer: {
                Text("Enable to show Goal Cards in the Diary.")
            }
            
            Section {
                Picker("Energy Unit", selection: Binding(
                    get: { profileViewModel.energyUnit },
                    set: { newValue in
                        Task {
                            await profileViewModel.setEnergyUnit(newValue)
                        }
                    }
                )) {
                    ForEach(EnergyUnit.allCases, id: \.self) { unit in
                        Text(unit.title).tag(unit)
                    }
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewProfileView.profileView
}
