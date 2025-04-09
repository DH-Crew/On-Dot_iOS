//
//  MonthNavigatorView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct MonthNavigatorView: View {
    var currentDate: String = "2025년 06월"
    
    var decreaseMonth: () -> Void
    var increaseMonth: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer().frame(width: 9)
            
            Text(currentDate)
                .font(OnDotTypo.titleSmallM)
                .foregroundStyle(Color.gray0)
            
            Spacer()
            
            Image("ic_arrow_left")
                .resizable()
                .frame(width: 19, height: 19)
                .onTapGesture { decreaseMonth() }
            
            Spacer().frame(width: 12)
            
            Image("ic_arrow_right")
                .resizable()
                .frame(width: 19, height: 19)
                .onTapGesture { increaseMonth() }
            
            Spacer().frame(width: 9)
        }
        .frame(maxWidth: .infinity)
    }
}
