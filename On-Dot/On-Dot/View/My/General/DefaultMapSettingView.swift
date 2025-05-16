//
//  DefaultMapSettingView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/30/25.
//

import SwiftUI

struct DefaultMapSettingView: View {
    @EnvironmentObject private var viewModel: MyPageViewModel
    
    var onClickBackButton: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.gray900.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                TopBar(
                    title: "길 안내 지도 설정",
                    image: "ic_back",
                    onClickButton: onClickBackButton
                )
                
                Spacer().frame(height: 32)
                
                Text("자주 사용하는\n지도를 설정해주세요")
                    .font(OnDotTypo.titleMediumM)
                    .foregroundStyle(Color.gray0)
                    .multilineTextAlignment(.leading)
                
                Spacer().frame(height: 16)
                
                Text("길 안내에 사용될 예정이에요.")
                    .font(OnDotTypo.bodyMediumR)
                    .foregroundStyle(Color.green300)
                
                Spacer().frame(height: 40)
                
                HStack(spacing: 16) {
                    mapItem(type: .naver)
                    mapItem(type: .kakao)
                    mapItem(type: .apple)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                OnDotButton(
                    content: "저장",
                    action: {
                        Task {
                            await viewModel.editMapProvider()
                        }
                        onClickBackButton()
                    },
                    style: .green500
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 22)
        }
    }
    
    @ViewBuilder
    private func mapItem(
        type: MapProvider.MapType
    ) -> some View {
        VStack(alignment: .center, spacing: 16) {
            Image(type.image)
            
            Text(type.title)
                .font(OnDotTypo.bodyMediumR)
                .foregroundStyle(Color.gray0)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(viewModel.selectedMapType == type ? Color.green600 : Color.clear, lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.selectedMapType = type
        }
    }
}
