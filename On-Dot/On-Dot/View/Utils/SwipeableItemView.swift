//
//  SwipeableItemView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/13/25.
//

import SwiftUI

struct SwipeableItemView: View {
    let item: ScheduleModel
    var onClickToggle: (Bool) -> Void
    var onDelete: () -> Void

    @State private var offsetX: CGFloat = 0
    private let swipeThreshold: CGFloat = -60

    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        offsetX = 0
                    }
                    onDelete()
                }) {
                    VStack(spacing: 7) {
                        Image("ic_trash")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 25, height: 24)
                            .foregroundStyle(Color.gray0)
                        
                        Text("삭제")
                            .font(OnDotTypo.bodyMediumR)
                            .foregroundColor(.gray0)
                    }
                }
                .padding(.trailing, 20)
            }

            ScheduleAlarmListItemView(item: item, onClickToggle: onClickToggle)
                .offset(x: offsetX)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width < 0 {
                                offsetX = value.translation.width
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                if value.translation.width < swipeThreshold {
                                    offsetX = swipeThreshold
                                } else {
                                    offsetX = 0
                                }
                            }
                        }
                )
        }
    }
}


