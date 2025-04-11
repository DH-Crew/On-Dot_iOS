//
//  EmptyScheduleView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct EmptyScheduleView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image("ic_large_clock")
            Text("등록된 알람이 없어요")
                .font(OnDotTypo.titleSmallM)
                .foregroundStyle(Color.gray500)
        }
    }
}
