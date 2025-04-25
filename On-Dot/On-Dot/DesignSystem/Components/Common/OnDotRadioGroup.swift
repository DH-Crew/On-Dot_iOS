//
//  OnDotRadioGroup.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/8/25.
//

import SwiftUI

struct OnDotRadioGroup<T: Hashable & Identifiable>: View {
    var items: [T]
    var label: (T) -> String
    var callback: () -> Void = {}
    @Binding var selected: T
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(items) { item in
                HStack(spacing: 8) {
                    Circle()
                        .fill(selected == item ? Color.green800 : Color.gray400)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle()
                                .fill(Color.green500)
                                .frame(width: selected == item ? 10 : 0, height: selected == item ? 10 : 0)
                        )
                    
                    Text(label(item))
                        .font(OnDotTypo.bodyMediumR)
                        .foregroundColor(.gray0)
                }
                .onTapGesture {
                    selected = item
                    callback()
                }
            }
        }
    }
}
