//
//  LocationListItemView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct LocationListItemView: View {
    var locationName: String = "장소명"
    var monthAndDay: String = "06월 13일"
    
    var onClickClose: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Text(locationName)
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(Color.gray0)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer()
            
            Text(monthAndDay)
                .font(OnDotTypo.bodyMediumR)
                .foregroundStyle(Color.gray300)
            
            Spacer().frame(width: 8)
            
            Button(action: onClickClose) {
                Image("ic_close")
                    .resizable()
                    .frame(width: 12, height: 12)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
