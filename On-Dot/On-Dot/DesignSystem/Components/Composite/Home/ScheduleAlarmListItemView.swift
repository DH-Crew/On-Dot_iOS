//
//  ScheduleAlarmListItemView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/10/25.
//

import SwiftUI

struct ScheduleAlarmListItemView: View {
    @Binding var item: ScheduleModel
    
    var onClickToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScheduleNameDateView(item: item)
            
            ScheduleTimeAlarmView(
                time: DateFormatterUtil.formatTime(item.appointmentAt).components(separatedBy: " "),
                isEnabled: $item.isEnabled,
                onClickToggle: onClickToggle
            )
            
            if let date = item.preparationTriggeredAt {
                Text("준비시작 \(DateFormatterUtil.formatTime(date))")
                    .font(OnDotTypo.bodyLargeR2)
                    .foregroundStyle(Color.gray200)
            } else {
                Text("준비시작 알람 없음")
                    .font(OnDotTypo.bodyLargeR2)
                    .foregroundStyle(Color.gray200)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct ScheduleNameDateView: View {
    var item: ScheduleModel
    
    var body: some View {
        HStack(alignment: .center) {
            Text(item.title)
                .font(OnDotTypo.bodyMediumR)
                .foregroundStyle(Color.gray200)

            Spacer()
            
            if item.isRepeat {
                HStack(spacing: 6) {
                    ForEach(0..<7, id: \.self) { index in
                        let dayNumber = index + 1
                        Text(weekdaySymbolsKR[index])
                            .font(OnDotTypo.bodySmallR1)
                            .foregroundStyle(
                                item.repeatDays.contains(dayNumber)
                                ? Color.green500
                                : Color.gray400
                            )
                    }
                }
            } else {
                Text(DateFormatterUtil.formatDate(item.appointmentAt))
                    .font(OnDotTypo.bodySmallR1)
                    .foregroundStyle(Color.gray400)
            }
        }
    }
}

private struct ScheduleTimeAlarmView: View {
    var time: [String]
    @Binding var isEnabled: Bool
    
    var onClickToggle: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .lastTextBaseline, spacing: 10) {
                    Text(time[0])
                        .font(OnDotTypo.titleMediumL)
                        .foregroundStyle(Color.gray0)
                    
                    Text(time[1])
                        .font(OnDotTypo.titleLargeL)
                        .foregroundStyle(Color.gray0)
                }
            }
            
            Spacer()
            
            VStack(alignment: .center) {
                OnDotToggle(isOn: $isEnabled, action: onClickToggle)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
