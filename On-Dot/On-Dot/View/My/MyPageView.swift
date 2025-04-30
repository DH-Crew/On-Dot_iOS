//
//  MyPageView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/29/25.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject private var viewModel = MyPageViewModel()
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
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
                        content2: "길 안내 지도 설정",
                        onClickContent1: { path.append(MyPageDestination.homeAddress) },
                        onClickContent2: { path.append(MyPageDestination.defaultMap) }
                    )
                    
                    Spacer().frame(height: 16)
                    
                    MyPageMenuView(
                        title: "도움",
                        content1: "고객센터",
                        content2: "서비스 이용약관",
                        content3: "개인정보 처리 방침",
                        onClickContent1: {
                            if let url = URL(string: viewModel.customerServiceChatLink) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        },
                        onClickContent2: { viewModel.isPolicyViewPresented = true },
                        onClickContent3: { viewModel.isTermsViewPresented = true }
                    )
                    
                    Spacer().frame(height: 16)
                    
                    MyPageMenuView(
                        title: "계정",
                        content1: "회원탈퇴",
                        content2: "로그아웃",
                        onClickContent1: { path.append(MyPageDestination.withdrawal) },
                        onClickContent2: { viewModel.showLogoutDialog = true }
                    )
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 22)
                
                if viewModel.showLogoutDialog {
                    OnDotDialog(
                        title: "로그아웃",
                        content: "정말 로그아웃 하시겠어요?",
                        positiveButtonText: "네",
                        negativeButtonText: "아니요",
                        onClickBtnPositive: { viewModel.showLogoutDialog = false },
                        onClickBtnNegative: { viewModel.showLogoutDialog = false },
                        onDismissRequest: { viewModel.showLogoutDialog = false }
                    )
                }
            }
            .navigationDestination(for: MyPageDestination.self) { view in
                switch view {
                case .homeAddress:
                    HomeAddressSettingView(
                        onClickBackButton: { path.removeLast() },
                        onClickEditButton: { path.append(MyPageDestination.homeAddressEdit) }
                    )
                    .toolbar(.hidden, for: .tabBar)
                    .environmentObject(viewModel)
                    .navigationBarBackButtonHidden(true)
                    .enableSwipeBack()
                case .homeAddressEdit:
                    HomeAddressEditView(
                        onClickBackButton: { path.removeLast() }
                    )
                    .toolbar(.hidden, for: .tabBar)
                    .environmentObject(viewModel)
                    .navigationBarBackButtonHidden(true)
                    .enableSwipeBack()
                case .defaultMap:
                    DefaultMapSettingView(
                        onClickBackButton: { path.removeLast() }
                    )
                    .toolbar(.hidden, for: .tabBar)
                    .environmentObject(viewModel)
                    .navigationBarBackButtonHidden(true)
                    .enableSwipeBack()
                case .withdrawal:
                    AccountWithdrawalView(
                        onClickBackButton: { path.removeLast() }
                    )
                    .toolbar(.hidden, for: .tabBar)
                    .environmentObject(viewModel)
                    .navigationBarBackButtonHidden(true)
                    .enableSwipeBack()
                }
            }
            .fullScreenCover(isPresented: $viewModel.isPolicyViewPresented) {
                if let url = URL(string: viewModel.privacyPolicyLink) {
                    WebViewScreen(url: url)
                }
            }
            .fullScreenCover(isPresented: $viewModel.isTermsViewPresented) {
                if let url = URL(string: viewModel.termsLink) {
                    WebViewScreen(url: url)
                }
            }
        }
    }
}

struct MyPageMenuView: View {
    let title: String
    let content1: String
    let content2: String
    var content3: String = ""
    
    var onClickContent1: () -> Void = {}
    var onClickContent2: () -> Void = {}
    var onClickContent3: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(OnDotTypo.bodyMediumM)
                .foregroundStyle(Color.gray200)
                .padding(.horizontal, 20)
            
            Spacer().frame(height: 16)
            
            Rectangle().fill(Color.gray600).frame(maxWidth: .infinity).frame(height: 0.5)
            
            Spacer().frame(height: 16)
            
            menuItem(content: content1, onClickContent: onClickContent1)
            
            Spacer().frame(height: 20)
            
            menuItem(content: content2, onClickContent: onClickContent2)
            
            if !content3.isEmpty {
                Spacer().frame(height: 20)
                
                menuItem(content: content3, onClickContent: onClickContent3)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    @ViewBuilder
    private func menuItem(
        content: String,
        onClickContent: @escaping () -> Void = {}
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
        .contentShape(Rectangle())
        .onTapGesture {
            onClickContent()
        }
    }
}
