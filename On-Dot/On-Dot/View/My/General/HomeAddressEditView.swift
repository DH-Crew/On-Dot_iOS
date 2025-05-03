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
                    image: "ic_back"
                )
                .padding(.horizontal, 16)
                
                Spacer().frame(height: 32)
                
                Text("주소를 입력해 주세요.")
                    .font(OnDotTypo.titleMediumM)
                    .foregroundStyle(Color.gray0)
                    .padding(.horizontal, 22)
                
                Spacer().frame(height: 40)
                
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .leading) {
                        HStack(spacing: 4) {
                            TextField(
                                "",
                                text: $viewModel.addressInput
                            )
                            .frame(maxWidth: .infinity)
                            .focused($focusState)
                            .font(OnDotTypo.bodyLargeR1)
                            .foregroundStyle(Color.gray0)
                            .onChange(of: viewModel.addressInput) { newValue in
                                Task {
                                    await viewModel.onValueChanged(newValue: newValue)
                                }
                            }
                            
                            if !viewModel.addressInput.isEmpty {
                                Image("ic_close")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.gray400)
                                    .frame(width: 16, height: 16)
                                    .onTapGesture {
                                        viewModel.addressInput = ""
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color.gray700)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        if viewModel.addressInput.isEmpty {
                            Text("입력")
                                .font(OnDotTypo.bodyLargeR1)
                                .foregroundStyle(Color.gray300)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 22)
                
                Spacer().frame(height: 24)
                
                Rectangle().fill(Color.gray800).frame(maxWidth: .infinity).frame(height: 8)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        Spacer().frame(height: 20)
                        ForEach(viewModel.searchResult) { location in
                            LocationSearchItemView(keyword: viewModel.addressInput, title: location.title, detail: location.roadAddress)
                                .onTapGesture {
                                    // TODO: 집 주소 변경 API 호출
                                    viewModel.selectedLocation = location
                                    onClickBackButton()
                                }
                            Rectangle().fill(Color.gray800).frame(maxWidth: .infinity).frame(height: 0.5)
                        }
                    }
                    .padding(.horizontal, 22)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    focusState = false
                }
                .gesture(
                    DragGesture()
                        .onChanged { _ in
                            focusState = false
                        }
                )
            }
            .frame(maxWidth: .infinity)
        }
        .onTapGesture {
            focusState = false
        }
    }
}
