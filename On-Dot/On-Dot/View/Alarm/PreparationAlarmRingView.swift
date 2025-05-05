//
//  PreparationAlarmRingView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/5/25.
//

import SwiftUI

struct PreparationAlarmRingView: View {
    @State private var isSnoozed: Bool = false
    
    var onPreparationStarted: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.gray900.ignoresSafeArea()
            
            VStack(alignment: .center) {
                Spacer().frame(height: 69)
                
                HStack(spacing: 0) {
                    Text("출발하기까지 ")
                        .font(OnDotTypo.titleMediumSB)
                        .foregroundStyle(Color.gray0)
                    
                    Text("NN:NN")
                        .font(OnDotTypo.titleMediumSB)
                        .foregroundStyle(Color.green500)
                }
                
                Text(isSnoozed ? "어서 준비를 시작하세요!" : "준비를 시작하세요!")
                    .font(OnDotTypo.titleMediumSB)
                    .foregroundStyle(Color.gray0)
                
                if isSnoozed {
                    Spacer().frame(height: 79)
                    
                    Text("23:54")
                        .font(OnDotTypo.titleLargeM)
                        .foregroundStyle(Color.red)
                    
//                    LottieView(name: "preparation_alarm_snoozed", loopMode: .loop)
//                        .frame(maxHeight: 300)
                    
                    Spacer()
                } else {
                    Spacer().frame(height: 54)
                    
                    Text(DateFormatterUtil.formatShortKoreanMonthDay(Date()))
                        .font(OnDotTypo.titleSmallM)
                        .foregroundStyle(Color.gray0)
                    
                    Text("23:54")
                        .font(OnDotTypo.titleLargeM)
                        .foregroundStyle(Color.gray0)
                    
                    Spacer().frame(height: 16)
                    
                    Text("새로운 일정")
                        .font(OnDotTypo.bodyLargeR1)
                        .foregroundStyle(Color.gray0)
                    
                    Spacer()
                    
                    Text("N분 알람 미루기")
                        .font(OnDotTypo.titleSmallSB)
                        .foregroundStyle(Color.gray200)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray700)
                        )
                        .onTapGesture {
                            isSnoozed = true
                        }
                    
                    Spacer().frame(height: 140)
                }
                
                OnDotButton(
                    content: "준비 시작하기",
                    action: {
                        isSnoozed = false
                        onPreparationStarted()
                    },
                    style: .green500
                )
                
                Spacer().frame(height: 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 22)
        }
    }
}
