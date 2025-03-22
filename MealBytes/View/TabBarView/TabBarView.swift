//
//  TabBarView.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

struct TabBarView: View {
    @StateObject var mainViewModel = MainViewModel()
    
    var body: some View {
        TabView {
            MainView(mainViewModel: mainViewModel)
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Diary")
                }
            
            GoalsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Goals")
                }
        }
    }
}

#Preview {
    NavigationStack {
        TabBarView()
    }
    .accentColor(.customGreen)
}
