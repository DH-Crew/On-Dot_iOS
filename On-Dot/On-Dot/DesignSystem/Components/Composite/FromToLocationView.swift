//
//  FromToLocationView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct FromToLocationView: View {
    @Binding var fromLocation: String
    @Binding var toLocation: String
    @Binding var lastFocusedField: FocusField
    @FocusState.Binding var focusedField: FocusField?
    
    var isConfirmMode: Bool = false
    var backgroundColor: Color = .gray700
    var closeButtonColor: Color = .gray400
    
    var onValueChanged: (String) -> Void
    var onClickClose: (FocusField) -> Void
    
    init(
        fromLocation: Binding<String>,
        toLocation: Binding<String>,
        lastFocusedField: Binding<FocusField>,
        focusedField: FocusState<FocusField?>.Binding,
        isConfirmMode: Bool = false,
        backgroundColor: Color = .gray700,
        closeButtonColor: Color = .gray400,
        onValueChanged: @escaping (String) -> Void = { _ in },
        onClickClose: @escaping (FocusField) -> Void = { _ in }
    ) {
        self._fromLocation = fromLocation
        self._toLocation = toLocation
        self._lastFocusedField = lastFocusedField
        self._focusedField = focusedField
        self.isConfirmMode = isConfirmMode
        self.backgroundColor = backgroundColor
        self.closeButtonColor = closeButtonColor
        self.onValueChanged = onValueChanged
        self.onClickClose = onClickClose
    }
    
    var body: some View {
        HStack(spacing: 0) {
//            Spacer().frame(width: 10)
            
//            Image("ic_swap_vertical")
//                .onTapGesture { swapLocation() }
//            
//            Spacer().frame(width: 10)
            
            VStack(alignment: .leading, spacing: 0) {
                locationView(image: "ic_from_location", title: "출발지", content: $fromLocation, focusType: .from)
                Spacer().frame(height: 16)
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: 0.5)
                    .background(isConfirmMode ? Color.green800 : Color.gray600)
                Spacer().frame(height: 16)
                locationView(image: "ic_to_location", title: "도착지", content: $toLocation, focusType: .to)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    @ViewBuilder
    private func locationView(
        image: String,
        title: String,
        content: Binding<String>,
        focusType: FocusField
    ) -> some View {
        HStack(alignment: .center, spacing: 0) {
            Image(image)
            Spacer().frame(width: 8)
            Text("\(title): ")
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(content.wrappedValue.isEmpty ? Color.gray300 : Color.gray0)
            
            ZStack(alignment: .leading) {
                if content.wrappedValue.isEmpty {
                    Text("입력")
                        .foregroundColor(.gray300)
                        .font(OnDotTypo.bodyLargeR1)
                }
                
                TextField("입력", text: content)
                    .font(OnDotTypo.bodyLargeR1)
                    .foregroundColor(Color.gray0)
                    .focused($focusedField, equals: focusType)
                    .onChange(of: content.wrappedValue) { newValue in
                        onValueChanged(newValue)
                    }
                    .disabled(isConfirmMode)
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .onChange(of: focusedField) { newValue in
                        if let field = newValue {
                            lastFocusedField = field
                        }
                    }
            }
            
            Spacer().frame(width: 8)
            
            if !content.wrappedValue.isEmpty && !isConfirmMode {
                Button(action: {
                    content.wrappedValue = ""
                    if title == "출발지" {
                        onClickClose(FocusField.from)
                    } else {
                        onClickClose(FocusField.to)
                    }
                }) {
                    Image("ic_close")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(closeButtonColor)
                }
                Spacer().frame(width: 20)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
    
    private func swapLocation() {
        let temp = fromLocation
        fromLocation = toLocation
        toLocation = temp
    }
}
