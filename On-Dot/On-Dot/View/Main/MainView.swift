//
//  MainView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/8/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.gray900.ignoresSafeArea()
            
            OnDotTabView(selectedTab: $viewModel.selectedTab)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct OnDotTabView: View {
    @Binding var selectedTab: Int
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab

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
            TabView(selection: Binding(
                get: { selectedTab },
                set: { newValue in self.selectedTab = newValue }
            )) {
                
                HomeView(
                     
                )
                .tabItem {
                    Label("", image: selectedTab == 0 ? "ic_home_selected" : "ic_home_unselected")
                }
                .tag(0)
                
                HomeView(
                     
                )
                .tabItem {
                    Label("", image: selectedTab == 1 ? "ic_settings_selected" : "ic_settings_unselected")
                }
                .tag(1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
