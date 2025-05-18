//
//  HomeAddressEditView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/30/25.
//

import SwiftUI

struct HomeAddressEditView: View {
    @EnvironmentObject private var viewModel: MyPageViewModel
    
    @FocusState private var focusState: Bool
    
    var onClickBackButton: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.gray900.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                TopBar(
                    image: "ic_back",
                    onClickButton: onClickBackButton
                )
                .padding(.horizontal, 16)
                
                Spacer().frame(height: 32)
                
                Text("주소를 입력해 주세요.")
                    .font(OnDotTypo.titleMediumM)
                    .foregroundStyle(Color.gray0)
                    .padding(.horizontal, 22)
                
                Spacer().frame(height: 40)
                
                VStack(alignment: .leading, spacing: 0) {
                    SingleTextFieldView(
                        focusState: $focusState,
                        input: $viewModel.addressInput,
                        onValueChanged: { newValue in
                            Task {
                                await viewModel.onValueChanged(newValue: newValue)
                            }
                        }
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 22)
                
                Spacer().frame(height: 24)
                
                Rectangle().fill(Color.gray800).frame(maxWidth: .infinity).frame(height: 8)
                
                ScrollView {
                    if viewModel.searchResult.isEmpty {
                        Spacer().frame(height: 80)
                        EmptySearchResultView()
                    } else {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            Spacer().frame(height: 20)
                            ForEach(viewModel.searchResult) { location in
                                LocationSearchItemView(keyword: viewModel.addressInput, title: location.title, detail: location.roadAddress)
                                    .onTapGesture {
                                        Task {
                                            await viewModel.editHomeAddress(location: location)
                                            await MainActor.run { onClickBackButton() }
                                        }
                                    }
                                Rectangle().fill(Color.gray800).frame(maxWidth: .infinity).frame(height: 0.5)
                            }
                        }
                        .padding(.horizontal, 22)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    focusState = false
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .onTapGesture {
            focusState = false
        }
    }
}
