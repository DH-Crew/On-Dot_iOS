//
//  CreateScheduleMenu.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/8/25.
//

import SwiftUI

struct CreateScheduleMenu: View {
    var onClickQuickSchedule: () -> Void
    var onClickGeneralSchedule: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            MenuItem(image: "ic_bolt", title: "빠른 일정 생성", action: onClickQuickSchedule)
            MenuItem(image: "ic_clock", title: "일반 일정 생성", action: onClickGeneralSchedule)
        }
        .frame(width: 162, height: 92)
        .background(Color.gray600)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(8)
    }
    
    @ViewBuilder
    private func MenuItem(
        image: String,
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 0) {
                Image(image)
                Spacer().frame(width: 4)
                Text(title)
                    .foregroundStyle(Color.gray0)
                    .font(OnDotTypo.bodyLargeR1)
            }
            .frame(width: 146, height: 38)
        }
        .buttonStyle(PressedBackgroundStyle())
    }
}

struct PressedBackgroundStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.gray700 : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
