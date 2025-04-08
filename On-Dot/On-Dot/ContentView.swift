//
//  ContentView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/2/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                SelectedTimeView()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
