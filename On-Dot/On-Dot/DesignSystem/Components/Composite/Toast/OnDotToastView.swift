//
//  OnDotToastView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/10/25.
//

import SwiftUI

struct OnDotToastView: View {
    let isDelete: Bool
    var minute: Int = 0
    var dateTime: String = ""
    var message: String = ""
    
    var onClickBtnRevert: () -> Void = {}
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(isDelete ? "ic_check_bg_red" : message.isEmpty ? "ic_check_bg_green" : "ic_check_bg_red")
                .resizable()
                .frame(width: 16, height: 16)
            
            Spacer().frame(width: 10)
            
            if isDelete {
                Text("알람이 삭제되었습니다.")
                    .font(OnDotTypo.bodyLargeSB)
                    .foregroundStyle(Color.red)
                
                Spacer()
                
                Button(action: onClickBtnRevert) {
                    Text("되돌리기")
                        .font(OnDotTypo.bodyMediumR)
                        .foregroundStyle(Color.gray200)
                }
            } else {
                Text(message.isEmpty ? "소요시간이 \(minute)분이 예상되어,\n[\(dateTime)]에 알람이 설정되었습니다." : message)
                    .font(OnDotTypo.bodyLargeSB)
                    .foregroundStyle(message.isEmpty ? Color.green700 : Color.red)
                
                Spacer()
            }
        }
        .padding(.horizontal, 22)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.gray500)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
    }
}

private struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let isDelete: Bool
    var minute: Int = 0
    var dateTime: String = ""
    var message: String = ""
    
    var onClickBtnRevert: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    Spacer()
                    OnDotToastView(isDelete: isDelete, minute: minute, dateTime: dateTime, message: message, onClickBtnRevert: onClickBtnRevert)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 40)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    isPresented = false
                                }
                            }
                        }
                }
            }
        }
    }
}

extension View {
    func toast(
        isPresented: Binding<Bool>,
        isDelete: Bool,
        minute: Int = 0,
        dateTime: String = "",
        message: String = "",
        onClickBtnRevert: @escaping () -> Void = {}
    ) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, isDelete: isDelete, minute: minute, dateTime: dateTime, message: message, onClickBtnRevert: onClickBtnRevert))
    }
}
