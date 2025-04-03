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

struct StatefulPreviewWrapper<Value>: View {
    @State var value: Value
    var content: (Binding<Value>) -> AnyView

    init(_ value: Value, @ViewBuilder content: @escaping (Binding<Value>) -> some View) {
        self._value = State(wrappedValue: value)
        self.content = { binding in AnyView(content(binding)) }
    }

    var body: some View {
        content($value)
    }
}

#Preview {
    StatefulPreviewWrapper(false) { isChecked in
        OnDotCheckBox(isChecked: isChecked, size: 40, action: {})
    }
}
