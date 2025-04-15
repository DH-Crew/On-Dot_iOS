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
    
    var onValueChanged: (String) -> Void
    
    init(
        fromLocation: Binding<String>,
        toLocation: Binding<String>,
        onValueChanged: @escaping (String) -> Void = { _ in }
    ) {
        self._fromLocation = fromLocation
        self._toLocation = toLocation
        self.onValueChanged = onValueChanged
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer().frame(width: 10)
            
            Image("ic_swap_vertical")
                .onTapGesture { swapLocation() }
            
            Spacer().frame(width: 10)
            
            VStack(alignment: .leading, spacing: 0) {
                locationView(image: "ic_from_location", title: "출발지", content: fromLocation)
                    .onChange(of: fromLocation) { newValue in
                        onValueChanged(newValue)
                    }
                Spacer().frame(height: 16)
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: 0.5)
                    .background(Color.gray600)
                Spacer().frame(height: 16)
                locationView(image: "ic_to_location", title: "도착지", content: toLocation)
                    .onChange(of: toLocation) { newValue in
                        onValueChanged(newValue)
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    @ViewBuilder
    private func locationView(
        image: String,
        title: String,
        content: String
    ) -> some View {
        HStack(alignment: .center, spacing: 0) {
            Image(image)
            Spacer().frame(width: 8)
            Text("\(title): ")
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(content.isEmpty ? Color.gray300 : Color.gray0)
            if content.isEmpty {
                Text("입력")
                    .font(OnDotTypo.bodyLargeR1)
                    .foregroundStyle(Color.gray300)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text(content)
                    .font(OnDotTypo.bodyLargeR1)
                    .foregroundStyle(Color.gray0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            Spacer().frame(width: 8)
            if !content.isEmpty {
                Button(action: {
                    if title == "출발지" {
                        fromLocation = ""
                    } else {
                        toLocation = ""
                    }
                }) {
                    Image("ic_close")
                }
                Spacer().frame(width: 20)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func swapLocation() {
        let temp = fromLocation
        fromLocation = toLocation
        toLocation = temp
    }
}
