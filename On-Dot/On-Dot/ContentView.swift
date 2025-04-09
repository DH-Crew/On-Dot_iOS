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
    @State private var schedule = ScheduleModel(id: 1, title: "일정1", isRepeat: true, repeatDays: [1,4], appointmentAt: Date(), preparationTriggeredAt: Date(), departureTriggeredAt: Date(), isEnabled: true)
    @State private var showToast = false
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.gray900
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Button("토스트 띄우기") {
                    showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showToast = false
                    }
                }
            }
            .padding()
            .toast(isPresented: $showToast, isDelete: false, minute: 30, dateTime: DateFormatterUtil.formatShortKoreanDateTime(Date()), onClickBtnRevert: {})
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

