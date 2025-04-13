//
//  CalendarContentView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct CalendarContentView: View {
    let selectedDate: Date?
    let referenceDate: Date
    let calendar = Calendar.current
    
    var onClickDate: (Date) -> Void

    private var daysInMonth: [CalendarDay] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: referenceDate),
              let startWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday,
              let range = calendar.range(of: .day, in: .month, for: referenceDate) else {
            return []
        }

        var days: [CalendarDay] = []

        for _ in 1..<startWeekday {
            days.append(CalendarDay(date: nil, isCurrentMonth: false))
        }

        for day in range {
            if let date = calendar.date(from: DateComponents(
                year: calendar.component(.year, from: referenceDate),
                month: calendar.component(.month, from: referenceDate),
                day: day
            )) {
                days.append(CalendarDay(date: date, isCurrentMonth: true))
            }
        }

        return days
    }

    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.shortWeekdaySymbols
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(OnDotTypo.bodyLargeR2)
                        .frame(maxWidth: .infinity)
                        .frame(height: 39)
                        .foregroundStyle(symbol == "일" ? Color.red : Color.gray100)
                }
            }
            
            Spacer().frame(height: 4)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 4) {
                ForEach(daysInMonth) { day in
                    if let date = day.date {
                        let isSelected = selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!)

                        Text("\(calendar.component(.day, from: date))")
                            .font(OnDotTypo.bodyLargeR2)
                            .foregroundStyle(isSelected ? Color.green400 : Color.gray100)
                            .frame(maxWidth: .infinity)
                            .frame(height: 39)
                            .aspectRatio(1, contentMode: .fit)
                            .background(isSelected ? Color.green900 : Color.clear)
                            .clipShape(Circle())
                            .onTapGesture {
                                onClickDate(date)
                            }
                    } else {
                        Text("")
                            .frame(height: 39)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
    
    struct CalendarDay: Identifiable, Hashable {
        let id = UUID()
        let date: Date?
        let isCurrentMonth: Bool
    }
}
