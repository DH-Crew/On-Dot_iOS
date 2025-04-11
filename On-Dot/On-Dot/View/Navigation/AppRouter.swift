//
//  AppRouter.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/12/25.
//

import SwiftUI

final class AppRouter: ObservableObject {
    @Published var state: AppState = .splash
    @Published var path: [AppState] = []
    
    func navigate(to newState: AppState) {
        path.append(newState)
    }
    
    func replace(with newState: AppState) {
        path = [newState]
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
