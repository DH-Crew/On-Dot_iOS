//
//  UserBadgeBannerView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/10/25.
//

import SwiftUI

struct UserBadgeBannerView: View {
    var image: String = "ic_free_badge"
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image("ic_logo")
            Image(image)
        }
    }
}
