//
//  HomeAddressSettingView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/30/25.
//

import SwiftUI

struct HomeAddressSettingView: View {
    @EnvironmentObject private var viewModel: MyPageViewModel
    
    var onClickBackButton: () -> Void
    var onClickEditButton: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.gray900.ignoresSafeArea()
            
            VStack(spacing: 0) {
                TopBar(
                    title: "집 주소 설정",
                    image: "ic_back",
                    onClickButton: onClickBackButton
                )
                
                Spacer().frame(height: 32)
                
                HStack(alignment: .center, spacing: 0) {
                    Image("ic_home_address")
                    
                    Spacer().frame(width: 16)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("집")
                            .font(OnDotTypo.bodyMediumM)
                            .foregroundStyle(Color.gray200)
                        
                        Spacer().frame(height: 4)
                        
                        Text(viewModel.homeAddress.roadAddress)
                            .font(OnDotTypo.bodyLargeR1)
                            .foregroundStyle(Color.gray0)
                        
                        Spacer().frame(height: 4)
                        
                        Text(viewModel.homeAddress.roadAddress)
                            .font(OnDotTypo.bodyMediumR)
                            .foregroundStyle(Color.gray300)
                    }
                    
                    Spacer()
                    
                    Button(action: onClickEditButton) {
                        Image("ic_pencil")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.gray400)
                            .frame(width: 20, height: 20)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(Color.gray700)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Spacer()
            }
            .padding(.horizontal, 22)
        }
    }
}
