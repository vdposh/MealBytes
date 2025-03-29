//
//  TabBarView.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            NavigationStack {
                MainView()
            }
            .tabItem {
                Image(systemName: "fork.knife")
                Text("Diary")
            }
            
            NavigationStack {
                GoalsView()
            }
            .tabItem {
                Image(systemName: "chart.bar")
                Text("Goals")
            }
        }
    }
}

#Preview {
    TabBarView()
        .accentColor(.customGreen)
}
