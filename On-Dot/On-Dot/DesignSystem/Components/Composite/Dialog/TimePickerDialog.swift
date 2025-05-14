//
//  TimePickerDialog.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/11/25.
//

import SwiftUI

struct TimePickerDialog: View {
    @State var meridiem: String = ""
    @State var hour: Int = 0
    @State var minute: Int = 0
    
    var onDismissRequest: () -> Void
    var onClickSaveButton: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onDismissRequest() }
            
            ZStack {
                Color.gray100
                
                VStack(spacing: 0) {
                    HStack {
                        textButton(title: "취소", action: onDismissRequest)
                        
                        Spacer()
                        
                        Text("알람 시간 수정")
                            .font(OnDotTypo.bodyLargeR1)
                            .foregroundStyle(Color.gray0)
                        
                        Spacer()
                        
                        textButton(title: "저장", action: onClickSaveButton)
                    }
                    .padding(.horizontal, 22)
                    
                    Spacer().frame(height: 18)
                    
                    Rectangle().fill(Color.gray600).frame(height: 0.5).padding(.horizontal, 4)
                    
                    Spacer().frame(height: 16)
                    
                    DialTimePickerView(
                        meridiem: $meridiem,
                        hour: $hour,
                        minute: $minute
                    )
                    .padding(.horizontal, 22)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray100)
                )
                .padding(.top, 14)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 22)
            .frame(maxWidth: .infinity)
            
        }
    }
    
    @ViewBuilder
    private func textButton(
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(Color.green500)
        }
    }
}
