//
//  QuickScheduleCreateViewModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/18/25.
//

import SwiftUI

final class QuickScheduleCreateViewModel: ObservableObject {
    private let scheduleRepository: ScheduleRepository
    
    @Published var isChecked: Bool = false
    @Published var voiceInput: String = ""
    @Published var voiceInputPreview: String = ""
    @Published var isActiveSTT: Bool = false
    
    init(
        scheduleRepository: ScheduleRepository = ScheduleRepositoryImpl()
    ) {
        self.scheduleRepository = scheduleRepository
    }
    
    func parseSTT() async {
        if voiceInput.isEmpty { return }
        
        do {
            let response = try await scheduleRepository.parseSTT(request: STTRequest(text: voiceInput))
            print("STT 파싱 결과: \(response)")
        } catch {
            print("STT 파싱 실패: \(error)")
        }
    }
}
