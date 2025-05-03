//
//  MemberRepository.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

protocol MemberRepository {
    func saveOnboardingInfo(request: OnboardingRequest) async throws -> Void
    func getHomeAddress() async throws -> HomeAddressInfo
    func editHomeAddress(address: HomeAddressInfo) async throws -> Void
    func deleteAccount(request: WithdrawalRequest) async throws -> Void
    func editMapProvider(request: MapProvider) async throws -> Void
}
