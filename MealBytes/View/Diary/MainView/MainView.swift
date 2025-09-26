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
        ZStack(alignment: .top) {
            listLayer
            calendarLayer
        }
        .navigationBarTitle(mainViewModel.navigationTitle)
        .navigationSubtitle(mainViewModel.navigationSubtitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            calendarToolbar
        }
        .task {
            await mainViewModel.loadMainData()
        }
    }
    
    private var listLayer: some View {
        List {
            dateSection
            caloriesSection
            mealSections
            detailedInformationSection
        }
        .scrollIndicators(.hidden)
        .listSectionSpacing(16)
    }
    
    private var calendarLayer: some View {
        ZStack(alignment: .top) {
            if mainViewModel.isExpandedCalendar {
                CalendarView(mainViewModel: mainViewModel)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .zIndex(2)
                
                CalendarButtonView {
                    mainViewModel.isExpandedCalendar = false
                }
                .zIndex(1)
            }
        }
    }
    
    private var dateSection: some View {
        Section {
            HStack {
                ForEach(-3...3, id: \.self) { offset in
                    let date = mainViewModel.dateByAddingOffset(for: offset)
                    Button {
                        mainViewModel.date = date
                    } label: {
                        DateView(
                            date: date,
                            isToday: Calendar.current.isDate(
                                date,
                                inSameDayAs: Date()
                            ),
                            isSelected: Calendar.current.isDate(
                                date,
                                inSameDayAs: mainViewModel.date
                            ),
                            mainViewModel: mainViewModel
                        )
                    }
                    .buttonStyle(.borderless)
                }
            }
            .padding(.vertical, 10)
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }
    
    private var caloriesSection: some View {
        CaloriesSection(
            summaries: mainViewModel.summariesForCaloriesSection(),
            mainViewModel: mainViewModel
        )
    }
    
    private var mealSections: some View {
        ForEach(MealType.allCases, id: \.self) { mealType in
            let filteredItems = mainViewModel.filteredMealItems(
                for: mealType,
                on: mainViewModel.date
            )
            
            MealSectionView(
                mealType: mealType,
                mealItems: filteredItems,
                mainViewModel: mainViewModel
            )
        }
    }
    
    private var detailedInformationSection: some View {
        NutrientValueSection(
            nutrients: mainViewModel.filteredNutrientValues,
            isExpandable: $mainViewModel.isExpanded
        )
    }
    
    @ToolbarContentBuilder
    private var calendarToolbar: some ToolbarContent {
        if mainViewModel.isExpandedCalendar {
            ToolbarItemGroup {
                Button {
                    mainViewModel.changeMonth(
                        by: -1,
                        selectedDate: &mainViewModel.date
                    )
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Button {
                    mainViewModel.changeMonth(
                        by: 1,
                        selectedDate: &mainViewModel.date
                    )
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    mainViewModel.selectDate(
                        Date(),
                        selectedDate: &mainViewModel.date,
                        isPresented: &mainViewModel.isExpandedCalendar
                    )
                } label: {
                    Text("Today")
                        .font(.headline)
                }
            }
        }
        
        ToolbarSpacer(.fixed)
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                mainViewModel.isExpandedCalendar.toggle()
            } label: {
                Image(
                    systemName: mainViewModel.isExpandedCalendar
                    ? "xmark"
                    : "calendar"
                )
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
