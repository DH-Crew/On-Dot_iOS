//
//  AlarmRepositoryImpl.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/28/25.
//

final class AlarmRepositoryImpl: AlarmRepository {
    let networkManager: NetworkManager
    
    init(
        networkManager: NetworkManager = NetworkManager.shared
    ) {
        self.networkManager = networkManager
    }
    
    func calculateAlarm(request: CalculateRequest) async throws -> CalculatedAlarmResponse {
        return try await networkManager.request(type: CalculatedAlarmResponse.self, api: .calculate(calculateRequest: request))
    }
}
