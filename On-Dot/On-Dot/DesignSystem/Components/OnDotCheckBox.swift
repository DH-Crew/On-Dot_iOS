//
//  OnDotCheckBox.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/4/25.
//

import SwiftUI

struct OnDotCheckBox: View {
    @Binding var isChecked: Bool
    var size: CGFloat = 23
    var action: () -> Void = {}
    
    var body: some View {
        Image(isChecked ? "ic_checked" : "ic_unchecked")
            .resizable()
            .frame(width: size, height: size)
            .onTapGesture {
                withAnimation { isChecked.toggle() }
                action()
            }
    }
}
