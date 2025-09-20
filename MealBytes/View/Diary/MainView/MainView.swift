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
        .navigationBarTitle("Diary", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if mainViewModel.isExpandedCalendar {
                    Text("")
                } else {
                    Text(mainViewModel.formattedDate())
                        .font(.headline)
                }
            }
            
            ToolbarItem() {
                if mainViewModel.isExpandedCalendar {
                    HStack {
                        Button {
                            mainViewModel.changeMonth(by: -1, selectedDate: &mainViewModel.date)
                        } label: {
                            Image(systemName: "chevron.left")
                                .padding(.trailing)
                        }
                        
                        Button {
                            mainViewModel.changeMonth(by: 1, selectedDate: &mainViewModel.date)
                            
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.horizontal, 8)
                }
            }
            
            ToolbarSpacer(.fixed)
            
            ToolbarItem() {
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
            
            ToolbarItem(placement: .cancellationAction) {
                if mainViewModel.isExpandedCalendar {
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
        .listSectionSpacing(15)
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
                    Button {
                        mainViewModel.date = mainViewModel
                            .dateByAddingOffset(for: offset)
                    } label: {
                        dateView(
                            for: mainViewModel.dateByAddingOffset(for: offset)
                        )
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }
    
    private func dateView(for date: Date) -> some View {
        DateView(
            date: date,
            isToday: Calendar.current.isDate(date, inSameDayAs: Date()),
            isSelected: Calendar.current.isDate(
                date,
                inSameDayAs: mainViewModel.date
            ),
            mainViewModel: mainViewModel
        )
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
        DetailedInformationSection(
            isExpanded: $mainViewModel.isExpanded,
            nutrients: mainViewModel.filteredNutrients
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
