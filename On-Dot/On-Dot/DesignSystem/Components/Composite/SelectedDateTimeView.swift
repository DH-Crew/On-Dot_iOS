//
//  SelectedDateTimeView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct SelectedDateTimeView: View {
    @State var selectedDate: String = "2025년 6월 13일"
    @State var selectedTime: String = "오후 7:00"
    
    var onClickDateChip: () -> Void
    var onClickTimeChip: () -> Void
    
    var body: some View {
        HStack {
            TextChip(title: selectedDate, isActive: false)
                .onTapGesture { onClickDateChip() }
            Spacer()
            TextChip(title: selectedTime, isActive: false)
                .onTapGesture { onClickTimeChip() }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
