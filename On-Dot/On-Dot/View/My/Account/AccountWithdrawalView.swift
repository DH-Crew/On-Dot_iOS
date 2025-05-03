//
//  AccountWithdrawalView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/30/25.
//

import SwiftUI

struct AccountWithdrawalView: View {
    @EnvironmentObject private var viewModel: MyPageViewModel
    
    var onClickBackButton: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.gray900.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                TopBar(
                    title: "회원탈퇴",
                    image: "ic_back",
                    onClickButton: onClickBackButton
                )
                
                Spacer().frame(height: 32)
                
                ScrollView {
                    HStack(spacing: 24) {
                        Image("ic_caution")
                        
                        Text("회원탈퇴를 하기 전\n안내 사항을 확인해주세요.")
                            .font(OnDotTypo.bodyLargeSB)
                            .foregroundStyle(Color.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color.gray700)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Spacer().frame(height: 28)
                    
                    Text("회원탈퇴를 진행한 뒤, 다시 온닷을 가입해도\n이전 계정 데이터는 복원되지 않아요.")
                        .font(OnDotTypo.bodyMediumR)
                        .foregroundStyle(Color.gray0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                    Spacer().frame(height: 24)
                    
                    Text("탈퇴 시 회원님의 개인정보는 개인정보처리방침에\n따라 탈퇴일로부터 30일간 보관 후 삭제돼요.")
                        .font(OnDotTypo.bodyMediumR)
                        .foregroundStyle(Color.gray0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                    Spacer().frame(height: 24)
                    
                    Text("탈퇴 사유를 선택해주세요.")
                        .font(OnDotTypo.bodyMediumR)
                        .foregroundStyle(Color.gray0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                    Spacer().frame(height: 24)
                    
                    ForEach(viewModel.reasonList, id: \.id) { item in
                        menuItem(item: item)
                        Spacer().frame(height: 16)
                    }
                }
                
                Spacer()
                
                OnDotButton(
                    content: "탈퇴하기",
                    action: {
                        if viewModel.selectedReason.id != -1 {
                            viewModel.showWithdrawalCompletedDialog = true
                        }
                    },
                    style: viewModel.selectedReason.id == -1 && viewModel.withdrawalReason.isEmpty ? .gray300 : .green500
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 22)
            
            if viewModel.showWithdrawalCompletedDialog {
                OnDotDialog(
                    title: "회원탈퇴 완료",
                    content: "그동안 온닷을 이용해주셔서\n감사합니다. 더 좋은 서비스를\n제공하기 위해 노력하겠습니다.",
                    positiveButtonText: "확인",
                    negativeButtonText: "취소",
                    onClickBtnPositive: {
                        Task {
                            await viewModel.deleteAccount()
                            await MainActor.run { viewModel.showWithdrawalCompletedDialog = false }
                        }
                    },
                    onClickBtnNegative: { viewModel.showWithdrawalCompletedDialog = false },
                    onDismissRequest: { viewModel.showWithdrawalCompletedDialog = false }
                )
            }
        }
    }
    
    @ViewBuilder
    private func menuItem(
        item: ReasonItem
    ) -> some View {
        Text(item.content)
            .font(OnDotTypo.bodyMediumR)
            .foregroundStyle(Color.gray0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray700)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(viewModel.selectedReason.id == item.id ? Color.green600 : Color.clear, lineWidth: 1)
                    )
            )
            .onTapGesture {
                viewModel.selectedReason = item
            }
    }
}
