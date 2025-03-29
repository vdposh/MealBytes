//
//  TabBarView.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

struct TabBarView: View {
    @StateObject var mainViewModel: MainViewModel = MainViewModel()
    @StateObject var goalsViewModel: GoalsViewModel = GoalsViewModel()
    
    var body: some View {
        TabView {
            NavigationStack {
                MainView(mainViewModel: mainViewModel)
            }
            .tabItem {
                Image(systemName: "fork.knife")
                Text("Diary")
            }
            
            NavigationStack {
                GoalsView(goalsViewModel: goalsViewModel)
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
