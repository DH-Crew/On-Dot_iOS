//
//  ContentView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var meridiem: String = "오전"
    @State private var hour: Int = 1
    @State private var minute: Int = 0
    
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                StepProgressBar(totalStep: 3, currentStep: 2)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
