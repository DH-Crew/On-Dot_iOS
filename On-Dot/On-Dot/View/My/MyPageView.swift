//
//  MyPageView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/29/25.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject private var viewModel = MyPageViewModel()
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 24)
                
                Text("마이")
                    .font(OnDotTypo.titleMediumSB)
                    .foregroundStyle(Color.gray0)
                
                Spacer().frame(height: 28)
                
                MyPageMenuView(
                    title: "일반",
                    content1: "집 주소 설정",
                    content2: "길 안내 지도 설정"
                )
                
                Spacer().frame(height: 16)
                
                MyPageMenuView(
                    title: "도움",
                    content1: "고객센터",
                    content2: "서비스 정책"
                )
                
                Spacer().frame(height: 16)
                
                MyPageMenuView(
                    title: "계정",
                    content1: "회원탈퇴",
                    content2: "로그아웃"
                )
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 22)
        }
    }
}

struct MyPageMenuView: View {
    let title: String
    let content1: String
    let content2: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(OnDotTypo.bodyMediumM)
                .foregroundStyle(Color.gray200)
                .padding(.horizontal, 20)
            
            Spacer().frame(height: 16)
            
            Rectangle().fill(Color.gray600).frame(maxWidth: .infinity).frame(height: 0.5)
            
            Spacer().frame(height: 16)
            
            menuItem(content: content1)
            
            Spacer().frame(height: 20)
            
            menuItem(content: content2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    @ViewBuilder
    private func menuItem(
        content: String
    ) -> some View {
        HStack {
            Text(content)
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(Color.gray0)
            
            Spacer()
            
            Image("ic_arrow_right")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.gray400)
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal, 20)
    }
}
