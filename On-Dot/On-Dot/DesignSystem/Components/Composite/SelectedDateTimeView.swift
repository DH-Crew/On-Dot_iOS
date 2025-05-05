//
//  SelectedDateTimeView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct SelectedDateTimeView: View {
    let selectedDate: String?
    let selectedTime: String
    let selectedWeekdays: Set<Int>
    var isConfirmMode: Bool = false
    var backgroundColor: Color = .gray700
    
    var onClickDateChip: () -> Void = {}
    var onClickTimeChip: () -> Void = {}
    
    var body: some View {
        HStack {
            if let date = selectedDate {
                TextChip(title: date, style: isConfirmMode ? .confirm : .normal, onClickChip: onClickDateChip)
            } else {
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { index in
                        Text(AppConstants.weekdaySymbolsKR[index])
                            .font(OnDotTypo.bodyMediumR)
                            .foregroundColor(selectedWeekdays.contains(index) ? .gray50 : isConfirmMode ? .green800 : .gray400)
                            .frame(width: 20, height: 24)
                    }
                }
            }
            Spacer()
            TextChip(title: selectedTime, style: isConfirmMode ? .confirm : .normal, onClickChip: onClickTimeChip)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(Rectangle())
    }
}
