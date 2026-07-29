//
//  MainView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/03/2025.
//

import SwiftUI
import FirebaseCore

struct MainView: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        mainViewContentBody
            .navigationTitle("Diary")
            .navigationSubtitle(mainViewModel.formattedDate())
            .toolbarTitleDisplayMode(.inlineLarge)
            .safeAreaPadding(.top)
            .toolbar {
                mainViewToolbar
            }
            .alert(
                isPresented: $mainViewModel.showClearDayAlert,
                content: {
                    mainViewModel.clearDayAlert(for: mainViewModel.date)
                }
            )
            .onChange(of: mainViewModel.date) {
                mainViewModel.scrollToTop()
            }
            .task {
                await mainViewModel.loadMainData()
            }
    }
    
    private var mainViewContentBody: some View {
        Form {
            goalsSection
            mealSection
            nutrientTotalsButtonView
        }
        .sheet(isPresented: $mainViewModel.showNutrientTotals) {
            NutrientTotalsSheet(
                nutrients: mainViewModel.filteredNutrientValues,
                hasMealItems: mainViewModel.hasMealItems
            )
        }
        .navigationDestination(
            item: $mainViewModel.selectedMealType
        ) { mealType in
            if let searchViewModel = mainViewModel
                .searchViewModel as? SearchViewModel {
                SearchView(
                    searchViewModel: searchViewModel,
                    mealType: mealType
                )
            }
        }
    }
    
    private var goalsSection: some View {
        GoalsSection(mainViewModel: mainViewModel)
    }
    
    private var mealSection: some View {
        ForEach(MealType.allCases, id: \.self) { mealType in
            MealSectionView(
                mainViewModel: mainViewModel,
                mealType: mealType
            )
        }
    }
    
    private var nutrientTotalsButtonView: some View {
        Button {
            mainViewModel.showNutrientTotals = true
        } label: {
            Text("Nutrient Totals")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
                .overlay(alignment: .leading) {
                    Image(systemName: "text.rectangle.page")
                        .imageScale(.large)
                        .fontWeight(.semibold)
                    
                }
        }
        .listRowBackground(Color.accent.opacity(0.2))
    }
    
    @ToolbarContentBuilder
    private var mainViewToolbar: some ToolbarContent {
        if !mainViewModel.isTodaySelected {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    withAnimation {
                        mainViewModel.date = Date()
                    }
                } label: {
                    Text("Today")
                        .fontWeight(.medium)
                }
            }
        }
        
        ToolbarSpacer(.fixed, placement: .primaryAction)
        
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                mainViewModel.showDatePicker.toggle()
            } label: {
                Image(systemName: "calendar")
            }
            .popover(isPresented: $mainViewModel.showDatePicker) {
                DatePickerView(date: $mainViewModel.date)
            }
            
            if mainViewModel.hasMealItems {
                Menu {
                    Button {
                        
                    } label: {
                        Label("Select", systemImage: "checkmark.circle")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive) {
                        mainViewModel.showClearDayAlert = true
                    } label: {
                        Label("Clear Day", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
