//
//  SelectedDateTimeView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct SelectedDateTimeView: View {
    let selectedDate: String
    let selectedTime: String
    
    var onClickDateChip: () -> Void = {}
    var onClickTimeChip: () -> Void = {}
    
    var body: some View {
        HStack {
            TextChip(title: selectedDate, style: .normal, onClickChip: onClickDateChip)
            Spacer()
            TextChip(title: selectedTime, style: .normal, onClickChip: onClickTimeChip)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
