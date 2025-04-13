//
//  SelectedDateView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct SelectedDateView: View {
    let selectedDate: String
    let isActive: Bool
    
    var body: some View {
        HStack {
            Text("날짜")
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(Color.gray0)
            
            Spacer()
            
            TextChip(title: selectedDate.isEmpty ? "-" : selectedDate, style: isActive ? .active : .normal, onClickChip: {})
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}
