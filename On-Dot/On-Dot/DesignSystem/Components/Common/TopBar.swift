//
//  TopBar.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

import SwiftUI

struct TopBar: View {
    var title: String = ""
    let image: String
    
    var onClickButton: () -> Void = {}
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack {
                Button(action: onClickButton) {
                    Image(image)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 29)
            
            Text(title)
                .font(OnDotTypo.titleSmallM)
                .foregroundStyle(Color.gray0)
        }
    }
}
