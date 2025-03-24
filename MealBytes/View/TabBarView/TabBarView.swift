//
//  TabBarView.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

struct TabBarView: View {
    @StateObject var mainViewModel: MainViewModel
    
    init(mainViewModel: MainViewModel) {
        _mainViewModel = StateObject(wrappedValue: mainViewModel)
    }
    
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
    TabBarView(
        mainViewModel: MainViewModel()
    )
    .accentColor(.customGreen)
}
