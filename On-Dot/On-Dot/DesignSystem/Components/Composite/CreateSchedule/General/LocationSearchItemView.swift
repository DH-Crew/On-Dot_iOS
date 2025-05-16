//
//  LocationSearchItemView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

import SwiftUI

struct LocationSearchItemView: View {
    let keyword: String
    let title: String
    let detail: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image("ic_search")
            
            VStack(alignment: .leading, spacing: 4) {
                highlightedText(fullText: title, keyword: keyword)
                    .font(OnDotTypo.bodyLargeR1)
                
                Text(detail)
                    .font(OnDotTypo.bodyLargeR2)
                    .foregroundStyle(Color.gray300)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

@ViewBuilder
func highlightedText(fullText: String, keyword: String) -> some View {
    if let range = fullText.range(of: keyword) {
        let prefix = String(fullText[..<range.lowerBound])
        let highlighted = String(fullText[range])
        let suffix = String(fullText[range.upperBound...])

        (
            Text(prefix)
                .foregroundColor(.gray0)
            + Text(highlighted)
                .foregroundColor(.green600)
            + Text(suffix)
                .foregroundColor(.gray0)
        )
    } else {
        Text(fullText)
            .foregroundStyle(Color.gray0)
    }
}
