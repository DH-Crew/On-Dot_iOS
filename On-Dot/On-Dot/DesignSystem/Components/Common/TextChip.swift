//
//  TextChip.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/4/25.
//

import SwiftUI

struct TextChip: View {
    var title: String = ""
    var style: Style = .normal
    
    var onClickChip: () -> Void = {}
    
    enum Style {
        case active
        case inactive
        case normal
        case confirm
    }
    
    var body: some View {
        Text(title)
            .font(OnDotTypo.bodyMediumR)
            .foregroundColor(style.foregroundColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(style.backgroundColor)
            .cornerRadius(6)
            .onTapGesture {
                onClickChip()
            }
    }
}

private extension TextChip.Style {
    var foregroundColor: Color {
        switch self {
        case .active: return Color.green500
        case .inactive: return Color.gray400
        case .normal: return Color.gray50
        case .confirm: return Color.gray0
        }
    }
    var backgroundColor: Color {
        switch self {
        case .active, .inactive, .normal: return Color.gray500
        case .confirm: return Color.green800
        }
    }
}
