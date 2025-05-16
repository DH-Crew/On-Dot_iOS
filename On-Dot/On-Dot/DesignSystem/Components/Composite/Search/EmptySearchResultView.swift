//
//  EmptySearchResultView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/15/25.
//

import SwiftUI

struct EmptySearchResultView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image("ic_caution")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.gray500)
                .frame(width: 63, height: 63)
            
            Spacer().frame(height: 23)
            
            Text("검색결과를 찾을 수 없습니다.\n검색어를 확인해주세요.")
                .font(OnDotTypo.titleSmallM)
                .foregroundStyle(Color.gray500)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
