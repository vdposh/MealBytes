//
//  CalendarView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/03/2025.
//

import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button("Today") {
                    mainViewModel.selectDate(
                        Date(),
                        selectedDate: &selectedDate,
                        isPresented: &isPresented
                    )
                }
                
                HStack {
                    Button {
                        mainViewModel.changeMonth(
                            by: -1,
                            selectedDate: &selectedDate
                        )
                    } label: {
                        Image(systemName: "chevron.left")
                        
                            .padding(.trailing)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Button {
                    mainViewModel.changeMonth(
                        by: 1,
                        selectedDate: &selectedDate
                    )
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .font(.headline)
            .padding(.bottom)
            .padding(.horizontal)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 7)
            ) {
                ForEach(
                    mainViewModel.daysForCurrentMonth(
                        selectedDate: selectedDate
                    ),
                    id: \.self
                ) { date in
                    Button {
                        mainViewModel.selectDate(
                            date,
                            selectedDate: &selectedDate,
                            isPresented: &isPresented
                        )
                    } label: {
                        VStack(spacing: 3) {
                            Text("\(mainViewModel.dayComponent(for: date))")
                                .foregroundColor(mainViewModel.color(
                                    for: .day,
                                    date: date,
                                    isSelected: mainViewModel.calendar.isDate(
                                        selectedDate, inSameDayAs: date),
                                    isToday: mainViewModel
                                        .calendar.isDateInToday(date)
                                ))
                                .font(.callout)
                            
                            if mainViewModel.hasMealItems(for: date) {
                                Circle()
                                    .frame(width: 5, height: 5)
                                    .foregroundColor(.customGreen)
                            }
                        }
                        .frame(width: 40, height: 40)
                        .background(
                            mainViewModel.color(
                                for: .day,
                                date: date,
                                isSelected: mainViewModel.calendar.isDate(
                                    selectedDate, inSameDayAs: date),
                                forBackground: true
                            )
                        )
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        MainView(mainViewModel: MainViewModel())
    }
}
