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
        Text("\(day)일 \(hour)시간 \(minute)분 후에 울려요")
            .font(OnDotTypo.titleMediumSB)
            .foregroundStyle(Color.gray0)
    }
}
