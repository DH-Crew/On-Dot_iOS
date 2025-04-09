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
            let barWidth = (geometry.size.width - CGFloat(totalStep - 1) * 4) / CGFloat(totalStep)
            
            HStack(spacing: 4) {
                ForEach(0..<totalStep, id: \.self) { index in
                    if index < currentStep {
                        Rectangle()
                            .fill(Color.green600)
                            .frame(width: barWidth, height: 4)
                            .cornerRadius(2)
                            .animation(.easeInOut(duration: 0.3), value: currentStep)
                    } else {
                        Rectangle()
                            .fill(Color.gray700)
                            .frame(width: barWidth, height: 4)
                            .cornerRadius(2)
                            .animation(.easeInOut(duration: 0.3), value: currentStep)
                    }
                }
            }
        }
        .frame(height: 4)
    }
}
