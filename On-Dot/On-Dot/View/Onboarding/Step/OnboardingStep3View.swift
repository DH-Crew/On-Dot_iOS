//
//  OnboardingStep3View.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/23/25.
//

import SwiftUI

struct OnboardingStep3View: View {
    var onClickButton: (OnboardingStep3View.ButtonType) -> Void
    
    enum ButtonType {
        case sound
        case delay
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("알람의 초기값")
                    .font(OnDotTypo.titleMediumM)
                    .foregroundColor(Color.green500)
                Text("을 설정해 주세요.")
                    .font(OnDotTypo.titleMediumM)
                    .foregroundColor(Color.gray0)
            }
            
            Spacer().frame(height: 16)
            
            Text("추후에 마이페이지 또는 알람 생성에서 수정할 수 있어요.")
                .font(OnDotTypo.bodyMediumR)
                .foregroundStyle(Color.green300)
            
            Spacer().frame(height: 40)
            
            buttonView(buttonType: .sound)
            
            Spacer().frame(height: 16)
            
            buttonView(buttonType: .delay)
        }
    }
    
    @ViewBuilder
    private func buttonView(
        buttonType: OnboardingStep3View.ButtonType
    ) -> some View {
        HStack {
            Text(buttonType == .sound ? "사운드" : "알림 미루기")
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(Color.gray0)
            
            Spacer()
            
            Image("ic_arrow_right")
                .resizable()
                .frame(width: 20, height: 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(Rectangle())
        .onTapGesture {
            onClickButton(buttonType)
        }
    }
}

