//
//  TabBarView.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

struct TabBarView: View {
    @StateObject var mainViewModel: MainViewModel
    @StateObject var customRdiViewModel: CustomRdiViewModel
    
    init(mainViewModel: MainViewModel, customRdiViewModel: CustomRdiViewModel) {
        _mainViewModel = StateObject(wrappedValue: mainViewModel)
        _customRdiViewModel = StateObject(wrappedValue: customRdiViewModel)
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
                CustomRdiView(viewModel: customRdiViewModel)
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
        mainViewModel: MainViewModel(),
        customRdiViewModel: CustomRdiViewModel(
            firestoreManager: FirestoreManager()
        )
    )
    .accentColor(.customGreen)
}
