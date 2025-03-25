//
//  TabBarView.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

struct TabBarView: View {
    @StateObject var mainViewModel: MainViewModel
    @StateObject var goalsViewModel: GoalsViewModel
    
    init(mainViewModel: MainViewModel,
         goalsViewModel: GoalsViewModel) {
        _mainViewModel = StateObject(wrappedValue: mainViewModel)
        _goalsViewModel = StateObject(wrappedValue: goalsViewModel)
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
    let firestoreManager = FirestoreManager()
    let mainViewModel = MainViewModel(firestoreManager: firestoreManager)
    let customRdiViewModel = CustomRdiViewModel(
        firestoreManager: firestoreManager,
        mainViewModel: mainViewModel
    )
    let rdiViewModel = RdiViewModel(
        firestoreManager: firestoreManager,
        mainViewModel: mainViewModel
    )
    let goalsViewModel = GoalsViewModel(
        customRdiViewModel: customRdiViewModel,
        rdiViewModel: rdiViewModel
    )
    
    TabBarView(
        mainViewModel: mainViewModel,
        goalsViewModel: goalsViewModel
    )
    .accentColor(.customGreen)
}
