//
//  CalendarContentView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct CalendarContentView: View {
    @Binding var selectedDay: Int?
    let calendar = Calendar.current
    let year: Int
    let month: Int

    private var referenceDate: Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        return calendar.date(from: components)
    }

    private var daysInMonth: [Date] {
        guard let startOfMonth = referenceDate,
              let monthInterval = calendar.dateInterval(of: .month, for: startOfMonth),
              let startWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday else {
            return []
        }

        var dates: [Date] = []

        for _ in 1..<startWeekday {
            dates.append(Date.distantPast)
        }

        let numberOfDays = calendar.range(of: .day, in: .month, for: startOfMonth)!.count

        for day in 1...numberOfDays {
            if let date = calendar.date(bySetting: .day, value: day, of: startOfMonth) {
                dates.append(date)
            }
        }

        return dates
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
                        .foregroundStyle(symbol == "일" ? Color.red : Color.gray100)
                }
            }
            
            Spacer().frame(height: 18)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7),
                spacing: 18
            ) {
                ForEach(daysInMonth, id: \.self) { date in
                    if calendar.isDate(date, equalTo: Date.distantPast, toGranularity: .day) {
                        Text("")
                            .frame(height: 39)
                    } else {
                        Text("\(calendar.component(.day, from: date))")
                            .font(OnDotTypo.bodyLargeR2)
                            .foregroundStyle(selectedDay == calendar.component(.day, from: date) ? Color.green400 : Color.gray100)
                            .frame(maxWidth: .infinity)
                            .frame(height: 39)
                            .aspectRatio(1, contentMode: .fit)
                            .background(
                                Group {
                                    if selectedDay == calendar.component(.day, from: date) {
                                        Color.green900
                                    } else {
                                        Color.clear
                                    }
                                }
                            )
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedDay = calendar.component(.day, from: date)
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 0)
        }
        .padding()
    }
}
