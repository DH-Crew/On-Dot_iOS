//
//  DepartureTimeCalculatingView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

import SwiftUI

struct DepartureTimeCalculatingView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Color.gray900.ignoresSafeArea()
            
            VStack(spacing: 32) {
                Rectangle()
                    .fill(Color.gray50)
                    .frame(width: 200, height: 163)
                    
                Text("최적의 출발 시간을 계산하고 있어요.")
                    .font(OnDotTypo.titleSmallSB)
                    .foregroundStyle(Color.gray0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
