//
//  MainViewModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/8/25.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    @Published var appState: AppState = AppState.Quick
}
