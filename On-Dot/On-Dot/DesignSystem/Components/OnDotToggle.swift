//
//  OnDotToggle.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/4/25.
//

import SwiftUI

struct OnDotToggle: View {
    @Binding var isOn: Bool
    var action: () -> Void = {}
    
    var body: some View {
        Toggle("", isOn: $isOn)
            .labelsHidden()
            .tint(isOn ? Color.green600 : Color.gray400)
            .onChange(of: isOn) { newValue in
                action()
            }
    }
}
