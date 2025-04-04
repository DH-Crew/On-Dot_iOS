//
//  CheckTextChip.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/5/25.
//

import SwiftUI

struct CheckTextChip: View {
    let title: String
    var style: Style = .normal
    
    enum Style {
        case active
        case inactive
        case normal
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(OnDotTypo.bodyMediumR)
                .foregroundColor(style.foregroundColor)
                
            Image("ic_check_B")
                .renderingMode(.template)
                .foregroundStyle(style.foregroundColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
        .background(Color.gray500)
        .cornerRadius(6)
    }
}

private extension CheckTextChip.Style {
    var foregroundColor: Color {
        switch self {
        case .active: return Color.green500
        case .inactive: return Color.gray400
        case .normal: return Color.gray50
        }
    }
}
