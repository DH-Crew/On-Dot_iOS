//
//  RemainingTimeView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/10/25.
//

import SwiftUI

struct RemainingTimeView: View {
    var alarmDate: Date?
    
    var body: some View {
        Text(formattedRemainingTime())
            .font(OnDotTypo.titleMediumSB)
            .foregroundStyle(Color.gray0)
    }
    
    private func formattedRemainingTime() -> String {
        guard let alarmDate else {
            return "등록된 알람이 없어요"
        }

        let now = Date()
        let interval = alarmDate.timeIntervalSince(now)
        
        if interval <= 0 {
            return "곧 알람이 울려요"
        }

        let totalMinutes = Int(interval) / 60
        let days = totalMinutes / (24 * 60)
        let hours = (totalMinutes % (24 * 60)) / 60
        let minutes = totalMinutes % 60

        if days == 0 && hours == 0 && minutes == 0 {
            return "곧 알람이 울려요"
        }

        return "\(days)일 \(hours)시간 \(minutes)분 후에 울려요"
    }
}

