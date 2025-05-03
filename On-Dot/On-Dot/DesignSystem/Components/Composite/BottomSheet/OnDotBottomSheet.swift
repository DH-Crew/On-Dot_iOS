//
//  OnDotBottomSheet.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/3/25.
//

import SwiftUI

struct OnDotBottomSheet<Content: View>: View {
    var onDismissRequest: () -> Void
    
    let content: Content
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onDismissRequest() }
            
            VStack {
                Spacer()
                
                content
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 22)
                    .padding(.top, 32)
                    .padding(.bottom, 16)
                    .background(
                        Color.gray700
                            .clipShape(
                                RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                            )
                    )
            }
        }
    }
}

private struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
