//
//  OnboardingStep1View.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/21/25.
//

import SwiftUI

struct OnboardingStep1View: View {
    @Binding var hourText: String
    @Binding var minuteText: String
    @FocusState.Binding var focusField: TimeFocusField?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Text("평소 ").font(OnDotTypo.titleMediumM).foregroundColor(Color.gray0)
                    Text("외출 준비").font(OnDotTypo.titleMediumM).foregroundColor(Color.green500)
                    Text("하는데").font(OnDotTypo.titleMediumM).foregroundColor(Color.gray0)
                }
                Text("얼마나 소요되나요?").font(OnDotTypo.titleMediumM).foregroundColor(Color.gray0)
            }
            
            Spacer().frame(height: 16)
            
            Text("30분, 1시간 20분 등 자유롭게 적어주세요!")
                .font(OnDotTypo.bodyMediumR)
                .foregroundStyle(Color.green300)
            
            Spacer().frame(height: 40)
            
            HStack(spacing: 11) {
                TimeInputView(
                    content: $hourText,
                    subText: "시간",
                    focusType: .hour
                )
                
                TimeInputView(
                    content: $minuteText,
                    subText: "분",
                    focusType: .minute
                )
            }
        }
    }
    
    @ViewBuilder
    private func TimeInputView(
        content: Binding<String>,
        subText: String,
        focusType: TimeFocusField
    ) -> some View {
        HStack(alignment: .center, spacing: 8) {
            ZStack(alignment: .leading) {
                if content.wrappedValue.isEmpty {
                    Text("5자 이내의 숫자")
                        .font(OnDotTypo.bodyLargeR1)
                        .foregroundStyle(Color.gray300)
                }
                
                TextField("", text: content)
                    .onChange(of: content.wrappedValue) { newValue in
                        if newValue.count > 5 {
                            content.wrappedValue = String(content.wrappedValue.prefix(5))
                        }
                    }
                    .keyboardType(.numberPad)
                    .frame(maxWidth: .infinity)
                    .font(OnDotTypo.bodyLargeR1)
                    .foregroundStyle(Color.gray0)
                    .focused($focusField, equals: focusType)
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, 20)
            .padding(.vertical, 16)
            .background(Color.gray700)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(subText)
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(Color.gray200)
        }
    }
}
