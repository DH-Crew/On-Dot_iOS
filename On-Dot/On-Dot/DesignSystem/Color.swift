//
//  Color.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/4/25.
//

import SwiftUI
import UIKit

extension UIColor {
    var rgba: Int {
        guard let components = cgColor.components, cgColor.numberOfComponents == 4 else {
            return 0
        }
        
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components[3]
        
        return Int(red * 255.0) << 24 | Int(green * 255.0) << 16 | Int(blue * 255.0) << 8 | Int(alpha * 255.0)
    }

    var alpha: CGFloat {
        return cgColor.alpha
    }

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = (CGFloat((hex & 0xff0000) >> 16) / 255.0)
        let green = (CGFloat((hex & 0x00ff00) >> 8) / 255.0)
        let blue = (CGFloat(hex & 0x0000ff) / 255.0)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// SwiftUI Color 확장
extension Color {
    init(hex: Int) {
        self.init(UIColor(hex: hex))
    }
}

// Main
extension UIColor {
    static let green50 = UIColor(hex: 0xFFF9FFE6)
    static let green100 = UIColor(hex: 0xFFEBFFB0)
    static let green200 = UIColor(hex: 0xFFE2FF8A)
    static let green300 = UIColor(hex: 0xFFD4FF54)
    static let green400 = UIColor(hex: 0xFFCCFF33)
    static let green500 = UIColor(hex: 0xFFBFFF00)
    static let green600 = UIColor(hex: 0xFFAEE800)
    static let green700 = UIColor(hex: 0xFF88B500)
    static let green800 = UIColor(hex: 0xFF698C00)
    static let green900 = UIColor(hex: 0xFF506B00)
    static let green1000 = UIColor(hex: 0xFF374A00)
}

// Gray Scale
extension UIColor {
    static let gray0 = UIColor(hex: 0xFFECECEC)
    static let gray50 = UIColor(hex: 0xFFFFFFFF)
    static let gray100 = UIColor(hex: 0xFFC4C4C4)
    static let gray200 = UIColor(hex: 0xFFA7A7A7)
    static let gray300 = UIColor(hex: 0xFF7F7F7F)
    static let gray400 = UIColor(hex: 0xFF666666)
    static let gray500 = UIColor(hex: 0xFF404040)
    static let gray600 = UIColor(hex: 0xFF3A3A3A)
    static let gray700 = UIColor(hex: 0xFF2D2D2D)
    static let gray800 = UIColor(hex: 0xFF232323)
    static let gray900 = UIColor(hex: 0xFF1B1B1B)
}

extension UIColor {
    static let red = UIColor(hex: 0xFFFF196D)
}

// SwiftUI Color 대응
extension Color {
    static let green50 = Color(uiColor: .green50)
    static let green100 = Color(uiColor: .green100)
    static let green200 = Color(uiColor: .green200)
    static let green300 = Color(uiColor: .green300)
    static let green400 = Color(uiColor: .green400)
    static let green500 = Color(uiColor: .green500)
    static let green600 = Color(uiColor: .green600)
    static let green700 = Color(uiColor: .green700)
    static let green800 = Color(uiColor: .green800)
    static let green900 = Color(uiColor: .green900)
    static let green1000 = Color(uiColor: .green1000)
    
    static let gray0 = Color(uiColor: .gray0)
    static let gray50 = Color(uiColor: .gray50)
    static let gray100 = Color(uiColor: .gray100)
    static let gray200 = Color(uiColor: .gray200)
    static let gray300 = Color(uiColor: .gray300)
    static let gray400 = Color(uiColor: .gray400)
    static let gray500 = Color(uiColor: .gray500)
    static let gray600 = Color(uiColor: .gray600)
    static let gray700 = Color(uiColor: .gray700)
    static let gray800 = Color(uiColor: .gray800)
    static let gray900 = Color(uiColor: .gray900)
    
    static let red = Color(uiColor: .red)
    static let gradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: 0xFFBFFF00).opacity(0.5),
                Color(hex: 0xFFFF196D)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
}
