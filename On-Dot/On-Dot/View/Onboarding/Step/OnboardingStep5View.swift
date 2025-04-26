//
//  OnboardingStep5View.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

import SwiftUI

struct OnboardingStep5View: View {
    @Binding var selectedItem: ReasonItem?
    let reasonList: [ReasonItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("해당 목표를 달성하고 싶은")
                    .font(OnDotTypo.titleMediumM)
                    .foregroundColor(Color.gray0)
                HStack(spacing: 0) {
                    Text("이유")
                        .font(OnDotTypo.titleMediumM)
                        .foregroundColor(Color.green500)
                    Text("는 무엇인가요?")
                        .font(OnDotTypo.titleMediumM)
                        .foregroundColor(Color.gray0)
                }
            }
            
            Spacer().frame(height: 16)
            
            Text("한 개의 항목만 선택이 가능해요.")
                .font(OnDotTypo.bodyMediumR)
                .foregroundStyle(Color.green300)
            
            Spacer().frame(height: 40)
            
            ForEach(reasonList, id: \.id) { item in
                Text(item.content)
                    .font(OnDotTypo.bodyMediumR)
                    .foregroundStyle(Color.gray0)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.gray700)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 20)
                
                Spacer().frame(height: 16)
            }
        }
    }
}
