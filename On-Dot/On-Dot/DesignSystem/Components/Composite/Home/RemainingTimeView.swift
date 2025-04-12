//
//  RemainingTimeView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/10/25.
//

import SwiftUI

struct RemainingTimeView: View {
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    
    var body: some View {
        Text(formatRemainingTimeText())
            .font(OnDotTypo.titleMediumSB)
            .foregroundStyle(Color.gray0)
    }
    
    private func formatRemainingTimeText() -> String {
        if day == 0 && hour == 0 && minute == 0 {
            return "곧 알람이 울려요"
        }
        
        if day == -1 && hour == -1 && minute == -1 {
            return "등록된 알람이 없어요"
        }
        
        return "\(day)일 \(hour)시간 \(minute)분 후에 울려요"
    }
}
