//
//  SelectedDateView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct SelectedDateView: View {
    @State var selectedDate: String = "2025년 06월 13일"
    
    var body: some View {
        HStack {
            Text("날짜")
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(Color.gray0)
            
            Spacer()
            
            TextChip(title: selectedDate, isActive: true)
        }
        .frame(maxWidth: .infinity)
    }
}
