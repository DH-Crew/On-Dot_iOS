//
//  AddScheduleButtonView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct AddScheduleButtonView: View {
    @Binding var isShrunk: Bool
    var onClickButton: () -> Void

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                onClickButton()
            }
        }) {
            HStack(alignment: .center, spacing: isShrunk ? 0 : 6) {
                Image("ic_plus_20")
                    .transition(.opacity)
                if !isShrunk {
                    Text("알람 추가")
                        .font(OnDotTypo.bodyLargeSB)
                        .foregroundStyle(Color.gray800)
                        .transition(.opacity)
                }
            }
            .padding(.horizontal, isShrunk ? 12 : 10)
            .padding(.vertical, 9)
            .frame(width: isShrunk ? 40 : nil, height: 40)
            .background(Color.green500)
            .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

