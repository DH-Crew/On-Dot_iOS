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
    
    init(
        onDismissRequest: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.onDismissRequest = onDismissRequest
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onDismissRequest() }
            
            VStack {
                Spacer()
                
                content
                    .frame(maxWidth: .infinity, maxHeight: 600)
                    .padding(.horizontal, 22)
                    .padding(.top, 16)
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
