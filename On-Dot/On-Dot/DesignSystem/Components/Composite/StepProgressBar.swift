//
//  StepProgressBar.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/9/25.
//

import SwiftUI

struct StepProgressBar: View {
    var totalStep: Int = 2
    var currentStep: Int = 1
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray700)

                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.green600)
                    .frame(width: geometry.size.width * CGFloat(currentStep) / CGFloat(totalStep))
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
        .frame(height: 4)
        .clipShape(RoundedRectangle(cornerRadius: 2))
    }
}
