//
//  DateTimeSettingView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

import SwiftUI

struct DateTimeSettingView: View {
    let selectedDate: Date?
    let selectedTime: Date?
    let referenceDate: Date
    let isActiveCalendar: Bool
    let isActiveTimePicker: Bool
    let activeWeekdays: Set<Int>
    
    @Binding var meridiem: String
    @Binding var hour: Int
    @Binding var minute: Int
    
    var onClickSelectedDateView: () -> Void = {}
    var onClickSelectedTimeView: () -> Void = {}
    var increaseMonth: () -> Void
    var decreaseMonth: () -> Void
    var onClickDate: (Date) -> Void
    var updateSelectedTime: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            SelectedDateView(
                selectedDate: selectedDate.map { DateFormatterUtil.formatDate($0) } ?? "",
                isActive: isActiveCalendar
            )
            .padding(.horizontal, 20)
            .simultaneousGesture (
                TapGesture().onEnded {
                    onClickSelectedDateView()
                }
            )
            
            Spacer().frame(height: 16)
            
            if isActiveCalendar {
                Rectangle().fill(Color.gray600).frame(maxWidth: .infinity).frame(height: 0.5).padding(.horizontal, 4)
                
                Spacer().frame(height: 14)
                
                MonthNavigatorView(
                    currentDate: referenceDate,
                    decreaseMonth: decreaseMonth,
                    increaseMonth: increaseMonth
                )
                .padding(.horizontal, 19)
                
                Spacer().frame(height: 14)
                
                CalendarContentView(
                    selectedDate: selectedDate,
                    referenceDate: referenceDate,
                    activeWeekdays: activeWeekdays,
                    onClickDate: onClickDate
                )
            }
            
            Rectangle().fill(Color.gray600).frame(maxWidth: .infinity).frame(height: 0.5).padding(.horizontal, 4)
            
            Spacer().frame(height: 16)
            
            SelectedTimeView(
                selectedTime: selectedTime.map { DateFormatterUtil.formatTime($0) } ?? "",
                isActive: isActiveTimePicker
            )
            .padding(.horizontal, 20)
            .simultaneousGesture (
                TapGesture().onEnded {
                    onClickSelectedTimeView()
                }   
            )
                
            
            if isActiveTimePicker {
                Spacer().frame(height: 16)
                
                Rectangle().fill(Color.gray600).frame(maxWidth: .infinity).frame(height: 0.5).padding(.horizontal, 4)
                
                Spacer().frame(height: 16)
                
                DialTimePickerView(
                    meridiem: $meridiem,
                    hour: $hour,
                    minute: $minute
                )
                .onChange(of: meridiem) { _ in updateSelectedTime() }
                .onChange(of: hour) { _ in updateSelectedTime() }
                .onChange(of: minute) { _ in updateSelectedTime() }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
