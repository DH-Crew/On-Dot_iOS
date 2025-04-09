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
    @State private var fromLocation: String = "시작점"
    @State private var toLocation: String = "도착점"
    
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                FromToLocationView(fromLocation: $fromLocation, toLocation: $toLocation)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

