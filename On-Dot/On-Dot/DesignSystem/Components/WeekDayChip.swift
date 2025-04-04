//
//  WeekDayChip.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/5/25.
//

import SwiftUI

struct WeekDayChip: View {
    let title: String
    var style: Style
    
    enum Style {
        case active
        case inactive
        case normal
    }
    
    var body: some View {
        Text(title)
            .font(OnDotTypo.bodyMediumR)
            .foregroundStyle(style.foregroundColor)
            .padding(.horizontal, 6.5)
            .padding(.vertical, 7)
            .background(Color.gray500)
            .cornerRadius(6)
    }
}

private extension WeekDayChip.Style {
    var foregroundColor: Color {
        switch self {
        case .active: return Color.green500
        case .inactive: return Color.gray400
        case .normal: return Color.gray50
        }
    }
}
