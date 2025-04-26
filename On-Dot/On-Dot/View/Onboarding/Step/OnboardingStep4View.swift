//
//  OnboardingStep4View.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

import SwiftUI

struct OnboardingStep4View: View {
    @Binding var selectedItem: ExpectationItem?
    
    let gridItems: [ExpectationItem]
    
    private let columns = [
        GridItem(.flexible(), spacing: 17),
        GridItem(.flexible(), spacing: 17)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("ONDOT을 사용하면서")
                    .font(OnDotTypo.titleMediumM)
                    .foregroundColor(Color.gray0)
                HStack(spacing: 0) {
                    Text("어떤 것을 가장 ")
                        .font(OnDotTypo.titleMediumM)
                        .foregroundColor(Color.gray0)
                    Text("기대")
                        .font(OnDotTypo.titleMediumM)
                        .foregroundColor(Color.green500)
                    Text("하나요?")
                        .font(OnDotTypo.titleMediumM)
                        .foregroundColor(Color.gray0)
                }
            }
            
            Spacer().frame(height: 16)
            
            Text("한 개의 항목만 선택이 가능해요.")
                .font(OnDotTypo.bodyMediumR)
                .foregroundStyle(Color.green300)
            
            Spacer().frame(height: 40)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(gridItems) { item in
                    GridItemView(item: item, isSelected: selectedItem == item)
                        .onTapGesture {
                            selectedItem = item
                        }
                }
            }
        }
    }
}

private struct GridItemView: View {
    let item: ExpectationItem
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(item.imageName)
            
            Text(item.title)
                .font(OnDotTypo.bodyMediumR)
                .foregroundColor(Color.gray0)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 28)
        .padding(.bottom, 16)
        .background(Color.gray600)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.green600 : Color.clear, lineWidth: 1)
        )
    }
}
