//
//  SplashView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/12/25.
//

import SwiftUI

struct SplashView: View {
    var onSplashCompleted: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.gray900.ignoresSafeArea()
            
            LottieView(name: "Splash", loopMode: .playOnce, onCompleted: onSplashCompleted)
                .frame(width: 206, height: 40)
        }
    }
}
