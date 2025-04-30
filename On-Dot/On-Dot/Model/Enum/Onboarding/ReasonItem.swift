//
//  ReasonItem.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

struct ReasonItem: Identifiable, Equatable {
    let id: Int
    let content: String
    
    static let placeholder = ReasonItem(id: -1, content: "")
}
