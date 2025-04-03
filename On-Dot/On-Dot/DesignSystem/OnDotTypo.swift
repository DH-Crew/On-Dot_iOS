//
//  OnDotTypo.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/3/25.
//

import SwiftUI

struct PoptatoTypo {
    static let pretendardBlack = "Pretendard-Black"
    static let pretendardBold = "Pretendard-Bold"
    static let pretendardExtraBold = "Pretendart-ExtraBold"
    static let pretendardExtraLight = "Pretendard-ExtraLight"
    static let pretendardLight = "Pretendard-Light"
    static let pretendardMedium = "Pretendard-Medium"
    static let pretendardRegular = "Pretendard-Regular"
    static let pretendardSemiBold = "Pretendard-SemiBold"
    static let pretendardThin = "Pretendard-Thin"
    
    // Title
    static let titleLargeL: Font = .custom(pretendardLight, size: 42).weight(.light)
    
    static let titleMediumSB: Font = .custom(pretendardSemiBold, size: 24).weight(.semibold)
    static let titleMediumM: Font = .custom(pretendardMedium, size: 24).weight(.medium)
    static let titleMediumL: Font = .custom(pretendardLight, size: 24).weight(.light)
    static let titleMediumR: Font = .custom(pretendardRegular, size: 20).weight(.regular)
    
    static let titleSmallM: Font = .custom(pretendardMedium, size: 18).weight(.medium)
    static let titleSmallR: Font = .custom(pretendardRegular, size: 18).weight(.regular)
    static let titleSmallSB: Font = .custom(pretendardSemiBold, size: 17).weight(.semibold)

    // Body
    static let bodyLargeSB: Font = .custom(pretendardSemiBold, size: 16).weight(.semibold)
    static let bodyLargeR1: Font = .custom(pretendardRegular, size: 16).weight(.regular)
    static let bodyLargeR2: Font = .custom(pretendardRegular, size: 15).weight(.regular)
    
    static let bodyMediumM: Font = .custom(pretendardMedium, size: 14).weight(.medium)
    static let bodyMediumR: Font = .custom(pretendardRegular, size: 14).weight(.regular)
    static let bodyMediumSB: Font = .custom(pretendardSemiBold, size: 12).weight(.semibold)
    
    static let bodySmallR1: Font = .custom(pretendardRegular, size: 12).weight(.regular)
    static let bodySmallR2: Font = .custom(pretendardRegular, size: 11).weight(.regular)
    static let bodySmallR3: Font = .custom(pretendardRegular, size: 8).weight(.regular)
}
