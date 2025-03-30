//
//  TabBarView.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                GoalsView()
            }
            .tabItem {
                Image(systemName: "chart.bar")
                Text("Goals")
            }
            .tag(1)
            
            NavigationStack {
                MainView()
            }
            .tabItem {
                Image(systemName: "fork.knife")
                Text("Diary")
            }
            .tag(0)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(2)
        }
        .task {
            selectedTab = 2
        }
    }
}

#Preview {
    TabBarView()
        .accentColor(.customGreen)
}
