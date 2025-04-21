//
//  OnboardingStep2View.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/21/25.
//

import SwiftUI

struct OnboardingStep2View: View {
    let address: String
    
    var onClickLocationSearchView: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("주소")
                    .font(OnDotTypo.titleMediumM)
                    .foregroundColor(Color.green500)
                Text("를 입력해 주세요.")
                    .font(OnDotTypo.titleMediumM)
                    .foregroundColor(Color.gray0)
            }
            
            Spacer().frame(height: 16)
            
            Text("빠른 일정 등록에 꼭 필요한 정보예요.\n집 주소는 안전하게 저장되며 언제든 수정할 수 있어요.")
                .font(OnDotTypo.bodyMediumR)
                .foregroundStyle(Color.green300)
            
            Spacer().frame(height: 40)
            
            locationSearchView(address: address)
        }
    }
    
    @ViewBuilder
    private func locationSearchView(
        address: String
    ) -> some View {
        HStack(spacing: 8) {
            Image("ic_search")
                .resizable()
                .frame(width: 20, height: 20)
            
            Text(address.isEmpty ? "도로명 주소" : address)
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(address.isEmpty ? Color.gray300 : Color.gray0)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 17)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            onClickLocationSearchView()
        }
    }
}
