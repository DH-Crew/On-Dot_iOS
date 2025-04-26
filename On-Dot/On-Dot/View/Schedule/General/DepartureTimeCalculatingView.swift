//
//  DepartureTimeCalculatingView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

import SwiftUI

struct DepartureTimeCalculatingView: View {
    var onClickBtnClose: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.gray900.ignoresSafeArea()
            
            LottieView(name: "TimeCalculate", loopMode: .playOnce)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text("최적의 출발 시간을 계산하고 있어요.")
                .padding(.top, 220)
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(Color.gray0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                onClickBtnClose()
            }
        }
    }
}
