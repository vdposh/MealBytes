//
//  OverviewDailyIntakeSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct OverviewDailyIntakeSection: View {
    
    var body: some View {
        Section {
        } footer: {
            Text("Set daily intake by entering calories directly or calculate it based on macronutrient distribution.")
        }
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}

//
//  OverviewDailyIntakeSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

//import SwiftUI
//
//struct OverviewDailyIntakeSection: View {
//    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
//    
//    var body: some View {
//        Section {
//        } footer: {
//            VStack(alignment: .leading) {
//                Text("Set daily intake by entering calories directly or calculate it based on macronutrient distribution.")
//                
//                Text(dailyIntakeViewModel.calories)
//                    .foregroundColor(
//                        rdiViewModel.color(for: rdiViewModel.calculatedRdi)
//                    )
//            }
//        }
//    }
//}
//
//#Preview {
//    PreviewDailyIntakeView.dailyIntakeView
//}
