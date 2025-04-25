//
//  OnDotSlider.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

import SwiftUI

struct OnDotSlider: UIViewRepresentable {
    @Binding var value: Float
    
    var minimumValue: Float = 0.0
    var maximumValue: Float = 1.0
    var thumbSize: CGSize = CGSize(width: 24, height: 24)
    var thumbColor: UIColor = UIColor(Color.green500)
    var minimumTrackColor: UIColor = UIColor(Color.green500)
    var maximumTrackColor: UIColor = UIColor(Color.gray800)

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        slider.value = value
        
        slider.minimumTrackTintColor = minimumTrackColor
        slider.maximumTrackTintColor = maximumTrackColor
        
        slider.setThumbImage(makeThumbImage(size: thumbSize, color: thumbColor), for: .normal)
        
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = value
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value)
    }
    
    class Coordinator: NSObject {
        var value: Binding<Float>

        init(value: Binding<Float>) {
            self.value = value
        }

        @objc func valueChanged(_ sender: UISlider) {
            value.wrappedValue = sender.value
        }
    }
    
    private func makeThumbImage(size: CGSize, color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let cgContext = context.cgContext
            cgContext.setFillColor(color.cgColor)
            cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
        }
    }
}
