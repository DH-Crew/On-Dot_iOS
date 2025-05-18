//
//  SingleTextFieldView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/18/25.
//

import SwiftUI

struct SingleTextFieldView: View {
    @FocusState.Binding var focusState: Bool
    @Binding var input: String
    
    var isReadOnly: Bool = false
    var onValueChanged: (String) -> Void = {_ in}
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 4) {
                if isReadOnly {
                    Text(input)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(OnDotTypo.bodyLargeR1)
                        .foregroundStyle(Color.gray0)
                        .multilineTextAlignment(.leading)
                } else {
                    TextField(
                        "",
                        text: $input
                    )
                    .frame(maxWidth: .infinity)
                    .focused($focusState)
                    .font(OnDotTypo.bodyLargeR1)
                    .foregroundStyle(Color.gray0)
                    .onChange(of: input) { newValue in
                        onValueChanged(newValue)
                    }
                }
                
                if !input.isEmpty && !isReadOnly {
                    Image("ic_close")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.gray400)
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                            input = ""
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.gray700)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            if input.isEmpty {
                Text("입력")
                    .font(OnDotTypo.bodyLargeR1)
                    .foregroundStyle(Color.gray300)
                    .padding(.horizontal, 20)
            }
        }
    }
}
