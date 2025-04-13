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
    
    enum Style {
        case active
        case inactive
        case normal
    }
    
    var body: some View {
        Text(title)
            .font(OnDotTypo.bodyMediumR)
            .foregroundColor(style.foregroundColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.gray500)
            .cornerRadius(6)
    }
}

private extension TextChip.Style {
    var foregroundColor: Color {
        switch self {
        case .active: return Color.green500
        case .inactive: return Color.gray400
        case .normal: return Color.gray50
        }
    }
}
