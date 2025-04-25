//
//  DimmedModifier.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

import SwiftUI

struct DimmedModifier: ViewModifier {
    let isDimmed: Bool
    let overlayColor: Color = .gray900.opacity(0.7)
    
    func body(content: Content) -> some View {
        content
            .disabled(isDimmed)
            .overlay(
                Group {
                  if isDimmed {
                    overlayColor
                  }
                }
            )
    }
}

extension View {
    func dimmed(_ flag: Bool) -> some View {
        self.modifier(DimmedModifier(isDimmed: flag))
    }
}
