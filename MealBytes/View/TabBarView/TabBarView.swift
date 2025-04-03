//
//  TabBarView.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Int = 0
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var mainViewModel: MainViewModel
    
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
                MainView(mainViewModel: mainViewModel)
            }
            .tabItem {
                Image(systemName: "fork.knife")
                Text("Diary")
            }
            .tag(0)
            
            NavigationStack {
                ProfileView(loginViewModel: loginViewModel,
                            mainViewModel: mainViewModel)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(2)
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if mainViewModel.isExpandedCalendar {
                    mainViewModel.isExpandedCalendar = false
                }
            }
        }
        .task {
            selectedTab = 0
        }
    }
}

#Preview {
    ContentView()
        .accentColor(.customGreen)
}
