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
    @State private var selectedDate: Date? = nil
    @State private var isShrunk: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.gray900
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                RemainingTimeView(day: 1, hour: 2, minute: 30)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            isShrunk = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

