//
//  MemberRepositoryImpl.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

final class MemberRepositoryImpl: MemberRepository {
    private let networkManager: NetworkManager
    
    init(
        networkManager: NetworkManager = NetworkManager.shared
    ) {
        self.networkManager = networkManager
    }
    
    func saveOnboardingInfo(request: OnboardingRequest) async throws {
        _ = try await networkManager.request(type: EmptyResponse.self, api: .onboarding(onboardingRequest: request))
    }
    
    func getHomeAddress() async throws -> HomeAddressInfo {
        return try await networkManager.request(type: HomeAddressInfo.self, api: .getHomeAddress)
    }
    
    func editHomeAddress(address: HomeAddressInfo) async throws {
        _ = try await networkManager.request(type: EmptyResponse.self, api: .editHomeAddress(address: address))
    }
}
