//
//  OnDotButton.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/4/25.
//

import SwiftUI

struct OnDotButton: View {
    let content: String
    let action: () -> Void
    var style: Style = .green500
    
    enum Style {
        case green500
        case green600
        case gray300
        case outline
    }
    
    var body: some View {
        Button(action: action) {
            Text(content)
                .font(OnDotTypo.titleSmallSB)
                .foregroundColor(style.foregroundColor)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity)
                .background(style.backgroundColor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            style == .outline
                            ? AnyShapeStyle(Color.gradient)
                            : AnyShapeStyle(Color.clear),
                            lineWidth: 1
                        )
                )
        }
    }
}

private extension OnDotButton.Style {
    var backgroundColor: Color {
        switch self {
        case .green500: return .green500
        case .green600: return .green600
        case .gray300: return .gray300
        case .outline: return .gray700
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .green500, .green600, .gray300: return .gray900
        case .outline: return .gray0
        }
    }
}
