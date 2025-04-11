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
        NavigationStack(path: $router.path) {
            ZStack {
                Color.gray900.ignoresSafeArea()
                
                switch router.state {
                case .splash:
                    SplashView(onSplashCompleted: {
                        router.state = .main
                        router.replace(with: .main)
                    })
                default:
                    Color.clear
                }
            }
            .navigationDestination(for: AppState.self) { state in
                switch state {
                case .main:
                    MainView()
                default:
                    Color.clear
                }
            }
        }
        .environmentObject(router)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

