//
//  ContentView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/2/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = AppRouter()
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            
            switch router.state {
            case .splash:
                SplashView(onSplashCompleted: {
                    router.state = .main
                })
            case .main:
                NavigationStack {
                    MainView()
                }
            default:
                Color.clear
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

