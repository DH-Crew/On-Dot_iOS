//
//  DialTimePickerView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct DialTimePickerView: View {
    @Binding var meridiem: String
    @Binding var hour: Int
    @Binding var minute: Int
    
    var by: Int = 5
    
    private let meridiems = ["오전", "오후"]
    private let hours = Array(1...12)
    private var minutes: [Int] = []
    
    init(meridiem: Binding<String>, hour: Binding<Int>, minute: Binding<Int>, by: Int = 5) {
        self._meridiem = meridiem
        self._hour = hour
        self._minute = minute
        self.by = by
        self.minutes = stride(from: 0, through: 55, by: by).map { $0 }
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Picker(selection: $meridiem, label: Text("")) {
                    ForEach(meridiems, id: \.self) { value in
                        Text(value)
                            .font(OnDotTypo.titleSmallR)
                            .foregroundStyle(Color.gray0)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .padding(.trailing, -15)
                .clipped()

                Picker(selection: $hour, label: Text("")) {
                    ForEach(hours, id: \.self) { value in
                        HStack {
                            Text(String(format: "%02d", value))
                                .font(OnDotTypo.titleSmallR)
                                .foregroundStyle(Color.gray0)
                        }
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, -15)
                .clipped()

                Picker(selection: $minute, label: Text("")) {
                    ForEach(minutes, id: \.self) { value in
                        Text(String(format: "%02d", value))
                            .font(OnDotTypo.titleSmallR)
                            .foregroundStyle(Color.gray0)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .padding(.leading, -15)
                .clipped()
            }
            .frame(height: 169)
            .padding(.horizontal, 50)
        }
        .frame(maxWidth: .infinity)
    }
}
