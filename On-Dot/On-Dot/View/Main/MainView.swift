//
//  MainView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/8/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State var isSnoozed: Bool
    @State var fromOnboarding: Bool
    
    var convertAppState: (AppState) -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.gray900.ignoresSafeArea()
            
            OnDotTabView(
                isSnoozed: isSnoozed,
                fromOnboarding: fromOnboarding,
                convertAppState: convertAppState
            )
            .environmentObject(viewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct OnDotTabView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    
    @State var fromOnboarding: Bool
    
    let isSnoozed: Bool
    
    var convertAppState: (AppState) -> Void
    
    init(
        isSnoozed: Bool,
        fromOnboarding: Bool,
        convertAppState: @escaping (AppState) -> Void
    ) {
        self.isSnoozed = isSnoozed
        self.fromOnboarding = fromOnboarding
        self.convertAppState = convertAppState

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.gray800) // 탭바의 배경 색
        appearance.shadowColor = UIColor(Color.gray500) // 탭바의 상단 경계선

        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $viewModel.selectedTab) {
                HomeView(
                    isSnoozed: isSnoozed,
                    navigateToGeneralScheduleCreateView: { convertAppState(AppState.general) }
                )
                .tabItem {
                    Label("", image: viewModel.selectedTab == 0 ? "ic_home_selected" : "ic_home_unselected")
                }
                .tag(0)
                
                MyPageView(
                    navigateToLoginView: { convertAppState(AppState.auth) }
                )
                .tabItem {
                    Label("", image: viewModel.selectedTab == 1 ? "ic_settings_selected" : "ic_settings_unselected")
                }
                .tag(1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if fromOnboarding {
                MapSettingDialogView(onMapSelected: { mapType in
                    Task {
                        await viewModel.saveDefaultMap(mapType: mapType)
                    }
                    fromOnboarding = false
                })
            }
        }
    }
}

private struct MapSettingDialogView: View {
    @State private var selectedMapType: MapProvider.MapType? = nil
    
    var onMapSelected: (MapProvider.MapType) -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                Text("어떤 지도 앱을\n자주 사용하시나요?")
                    .font(OnDotTypo.titleSmallSB)
                    .foregroundStyle(Color.gray0)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: 8)
                
                Text("길 안내에 사용될 예정이며,\n세팅 > 지도 설정에서 바꿀 수 있어요.")
                    .font(OnDotTypo.bodyMediumR)
                    .foregroundStyle(Color.gray0)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: 16)
                
                HStack(spacing: 8) {
                    mapItem(type: .naver)
                    mapItem(type: .kakao)
                    mapItem(type: .apple)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        Color.gray600
                    )
            )
            .padding(.horizontal, 52)
        }
    }
    
    @ViewBuilder
    private func mapItem(
        type: MapProvider.MapType
    ) -> some View {
        VStack(alignment: .center, spacing: 16) {
            Image(type.image)
                .resizable()
                .frame(width: 46, height: 46)
            
            Text(type.title)
                .font(OnDotTypo.bodyMediumR)
                .foregroundStyle(Color.gray0)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 13)
        .background(Color.gray400)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(selectedMapType == type ? Color.green600 : Color.clear, lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                selectedMapType = type
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                onMapSelected(type)
            }
        }
    }
}
