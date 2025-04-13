//
//  SelectedTimeView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct SelectedTimeView: View {
    let selectedTime: String
    let isActive: Bool
    
    var body: some View {
        HStack {
            Text("시간")
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(Color.gray0)
            
            Spacer()
            
            TextChip(title: selectedTime.isEmpty ? "-" : selectedTime, style: isActive ? .active : .normal, onClickChip: {})
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}
