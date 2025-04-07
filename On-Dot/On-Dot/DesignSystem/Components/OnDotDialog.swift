//
//  OnDotDialog.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/8/25.
//

import SwiftUI

struct OnDotDialog: View {
    var title: String = ""
    var content: String = ""
    var positiveButtonText: String = ""
    var negativeButtonText: String = ""
    var buttonType: DialogButtonType = .double
    
    var onClickBtnPositive: () -> Void
    var onClickBtnNegative: () -> Void
    var onDismissRequest: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onDismissRequest() }
            
            VStack(spacing: 0) {
                Spacer().frame(height: 20)
                
                if !title.isEmpty {
                    Text(title)
                        .font(OnDotTypo.titleSmallSB)
                        .foregroundStyle(Color.gray0)
                }
                
                if !content.isEmpty {
                    Spacer().frame(height: 8)
                    
                    Text(content)
                        .font(OnDotTypo.bodyMediumR)
                        .foregroundStyle(Color.gray0)
                        .multilineTextAlignment(.center)
                }
                
                Spacer().frame(height: 16)
                
                HStack(spacing: 0) {
                    if buttonType == .double {
                        dialogButton(text: negativeButtonText, backgroundColor: .gray400, textColor: .gray0, action: onClickBtnNegative)
                        Spacer().frame(width: 8)
                        dialogButton(text: positiveButtonText, backgroundColor: .red, textColor: .gray0, action: onClickBtnPositive)
                    } else {
                        dialogButton(text: positiveButtonText, backgroundColor: .red, textColor: .gray0, action: onClickBtnPositive)
                    }
                }
                
                Spacer().frame(height: 20)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: 288)
            .background(Color.gray600)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func dialogButton(
        text: String,
        backgroundColor: Color,
        textColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            ZStack {
                backgroundColor
                Text(text)
                    .font(OnDotTypo.titleSmallSB)
                    .foregroundColor(textColor)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
