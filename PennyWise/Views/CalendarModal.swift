//
//  CalendarModal.swift
//  PennyWise
//
//  Created by Bart Tynior on 12/11/2024.
//

import SwiftUI

struct CalendarModal: View {
    @Binding var isPresented: Bool
    @State private var selectedStartDate: Date?
    @State private var selectedEndDate: Date?
    @State private var currentMonth = Date()

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .onTapGesture {
                    withAnimation {
                        isPresented.toggle()
                    }
                }

            VStack(spacing: 20) {
                // Header with title and close button
                HStack {
                    Text("Select Week")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Buttons at the top-right corner
                    HStack(spacing: 10) {
                        // Close Button
                        Button(action: {
                            withAnimation {
                                isPresented.toggle()
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(Color.white.opacity(0.8))
                                .frame(width: 30, height: 30)
                                .background(.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                }
                .padding(.top)
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 2)
                    .overlay(.white.opacity(0.5))
                    .padding(.horizontal)
                
                // Month navigation and calendar grid
                VStack(spacing: 15) {
                    // Month Navigation
                    HStack {
                        Button(action: { changeMonth(by: -1) }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        Text(monthYearString(from: currentMonth))
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: { changeMonth(by: 1) }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 20)
                    }
                    
                    // Calendar Grid
                    CalendarGrid(
                        selectedStartDate: $selectedStartDate,
                        selectedEndDate: $selectedEndDate,
                        currentMonth: $currentMonth
                    )
                }
                
                Divider()
                    .frame(height: 2)
                    .overlay(.white.opacity(0.5))
                    .padding(.horizontal)
                
                VStack(spacing: 20) {
                    Text("Quick selection")
                    
                    HStack(spacing: 10) {
                        // Add Category Button
                        Button(action: {
                        }) {
                            Text("Previous Week")
                                .foregroundColor(.purple)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(.gray.opacity(0.1)))
                        
                        // Add Category Button
                        Button(action: {
                        }) {
                            Text("Current Week")
                                .foregroundColor(.purple)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(.gray.opacity(0.1)))
                        
                        // Add Category Button
                        Button(action: {
                        }) {
                            Text("Next Week")
                                .foregroundColor(.purple)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(.gray.opacity(0.1)))
                    }
                }
                .padding()

            }
            .background(Color("Secondary"))
            .cornerRadius(10)
            .padding()
            .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
            .animation(.spring(), value: isPresented)
        }
    }
    
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    func resetSelection() {
        selectedStartDate = nil
        selectedEndDate = nil
    }
}

struct CalendarGrid: View {
    @Binding var selectedStartDate: Date?
    @Binding var selectedEndDate: Date?
    @Binding var currentMonth: Date

    var body: some View {
        let daysOfWeek = ["M", "T", "W", "T", "F", "S", "S"]
        let daysInMonthGrid = daysInMonthWithAdjacentDays()
        
        VStack(spacing: 5) {
            // Days of the week header
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.4))
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Days grid with previous/next month placeholders
            ForEach(0..<6) { week in
                HStack(spacing: 5) {
                    ForEach(0..<7) { day in
                        let index = week * 7 + day
                        if index < daysInMonthGrid.count {
                            let dayDate = daysInMonthGrid[index].date
                            let isInCurrentMonth = daysInMonthGrid[index].isInCurrentMonth
                            let isInRange = isInSelectedRange(date: dayDate)
                            let isSelectedDay = dayDate == selectedStartDate || dayDate == selectedEndDate
                            
                            Text("\(Calendar.current.component(.day, from: dayDate))")
                                .frame(maxWidth: .infinity, minHeight: 30)
                                .background(isSelectedDay ? Color("Primary") : (isInRange ? Color("Primary").opacity(0.3) : Color.clear))
                                .foregroundColor(isInCurrentMonth ? (isSelectedDay ? .white : .white) : .clear) // Gray for previous/next month dates
                                .clipShape(Circle())
                                .onTapGesture { if isInCurrentMonth { selectDate(dayDate) } }
                        } else {
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    func daysInMonthWithAdjacentDays() -> [(date: Date, isInCurrentMonth: Bool)] {
        var days = [(date: Date, isInCurrentMonth: Bool)]()
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        
        // Calculate the first day of the month
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // Add previous month days to align the calendar
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth),
           let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonth) {
            let daysToShowFromPreviousMonth = (firstWeekday + 5) % 7  // Calculate the leading spaces based on weekday
            let startDay = previousMonthRange.count - daysToShowFromPreviousMonth + 1
            for day in startDay...previousMonthRange.count {
                if let date = calendar.date(bySetting: .day, value: day, of: previousMonth) {
                    days.append((date, false))  // Mark as not in current month
                }
            }
        }
        
        // Add current month days
        for day in range {
            if let date = calendar.date(bySetting: .day, value: day, of: currentMonth) {
                days.append((date, true))  // Mark as in current month
            }
        }
        
        // Add next month days to complete the grid
        let remainingDays = 42 - days.count  // 42 = 6 weeks * 7 days
        if remainingDays > 0, let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            for day in 1...remainingDays {
                if let date = calendar.date(bySetting: .day, value: day, of: nextMonth) {
                    days.append((date, false))  // Mark as not in current month
                }
            }
        }
        
        return days
    }
    
    func selectDate(_ date: Date) {
        if selectedStartDate == nil || selectedEndDate != nil {
            // Start new range
            selectedStartDate = date
            selectedEndDate = nil
        } else if date < selectedStartDate! {
            // Reset start if new date is earlier
            selectedStartDate = date
        } else {
            // Complete the range
            selectedEndDate = date
        }
    }
    
    func isInSelectedRange(date: Date) -> Bool {
        guard let start = selectedStartDate, let end = selectedEndDate else { return false }
        return date >= start && date <= end
    }
}
