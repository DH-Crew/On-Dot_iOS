//
//  TextChip.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/4/25.
//

import SwiftUI

struct TextChip: View {
    var title: String = ""
    var isActive: Bool = false
    
    var body: some View {
        Text(title)
            .font(OnDotTypo.bodyMediumR)
            .foregroundColor(isActive ? Color.green600 : Color.gray50)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.gray500)
            .cornerRadius(6)
    }
}
