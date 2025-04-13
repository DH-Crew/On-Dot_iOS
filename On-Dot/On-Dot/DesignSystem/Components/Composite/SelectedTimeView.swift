//
//  SelectedTimeView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct SelectedTimeView: View {
    @State var selectedTime: String = "오후 7:00"
    
    var body: some View {
        HStack {
            Text("시간")
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(Color.gray0)
            
            Spacer()
            
            TextChip(title: selectedTime, style: .normal, onClickChip: {})
        }
        .frame(maxWidth: .infinity)
    }
}
