//
//  DateParsingError.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/29/25.
//

import Foundation

enum DateParsingError: Error, LocalizedError {
    case invalidFormat, missingValue

    var errorDescription: String? {
        switch self {
        case .invalidFormat:   return "날짜 형식이 올바르지 않습니다."
        case .missingValue:    return "입력된 날짜 문자열이 없습니다."
        }
    }
}
