//
//  MainViewModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/8/25.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    private let memberRepository: MemberRepository
    private let appStorageManager: AppStorageManager
    
    @Published var selectedTab: Int = 0
    
    init(
        memberRepository: MemberRepository = MemberRepositoryImpl(),
        appStorageManager: AppStorageManager = AppStorageManager.shared
    ) {
        self.memberRepository = memberRepository
        self.appStorageManager = appStorageManager
    }
    
    func saveDefaultMap(mapType: MapProvider.MapType) async {
        do {
            try await memberRepository.editMapProvider(request: MapProvider(mapProvider: mapType))
            appStorageManager.saveDefaultMap(mapType: mapType)
        } catch {
            print("지도 설정 저장 실패: \(error)")
        }
    }
}
