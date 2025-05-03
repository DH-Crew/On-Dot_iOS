//
//  MyPageViewModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/29/25.
//

import SwiftUI

final class MyPageViewModel: ObservableObject {
    private let locationRepository: LocationRepository
    private let memberRepository: MemberRepository
    
    init(
        locationRepository: LocationRepository = LocationRepositoryImpl(),
        memberRepository: MemberRepository = MemberRepositoryImpl()
    ) {
        self.locationRepository = locationRepository
        self.memberRepository = memberRepository
        
        Task {
            await getHomeAddress()
        }
    }
    
    // MARK: - MyPageView State
    @Published var isPolicyViewPresented: Bool = false
    @Published var isTermsViewPresented: Bool = false
    @Published var showLogoutDialog: Bool = false
    @Published var showWithdrawalCompletedDialog: Bool = false
    @Published var selectedReason: ReasonItem = .placeholder
    @Published var withdrawalReason: String = ""
    let customerServiceChatLink = "http://pf.kakao.com/_xfdLfn/chat"
    let privacyPolicyLink = "https://ondotdh.notion.site/Ondot-1e1d775a8a04802495c7cc44cac766cc?pvs=4"
    let termsLink = "https://ondotdh.notion.site/Ondot-1e1d775a8a04808782acc823d631d74b?pvs=4"
    let reasonList: [ReasonItem] = [
        ReasonItem(id: 1, content: "지각 방지에 효과를 못 느꼈어요."),
        ReasonItem(id: 2, content: "일정 등록이나 사용이 번거로웠어요."),
        ReasonItem(id: 3, content: "알림이 너무 많거나 타이밍이 맞지 않았어요."),
        ReasonItem(id: 4, content: "제 생활에 딱히 쓸 일이 없었어요.")
    ]
    
    // MARK: - HomeAddressSettingView State
    var homeAddress: HomeAddressInfo = .placeholder
    
    // MARK: - HomeAddressEditView State
    @Published var addressInput: String = ""
    @Published var searchResult: [LocationInfo] = []
    @Published var selectedLocation: LocationInfo = .placeholder
    
    // MARK: - DefaultMapSettingView State
    @Published var selectedMapType: MapProvider.MapType = .naver
    
    // MARK: - HomeAddressEditView Handler
    func onValueChanged(newValue: String) async {
        do {
            let response = try await locationRepository.searchLocation(query: newValue)
            
            await MainActor.run {
                searchResult = response
            }
        } catch {
            print("Search Location Failed: \(error)")
        }
    }
    
    func getHomeAddress() async {
        do {
            let response = try await memberRepository.getHomeAddress()
            
            await MainActor.run {
                homeAddress = response
            }
        } catch {
            print("집 주소 조회 실패: \(error)")
        }
    }
    
    func editHomeAddress(location: LocationInfo) async {
        do {
            let newAddress = HomeAddressInfo(
                roadAddress: location.roadAddress,
                longitude: location.longitude,
                latitude: location.latitude
            )
            
            try await memberRepository.editHomeAddress(
                address: newAddress
            )
            
            await MainActor.run {
                homeAddress = newAddress
                addressInput = ""
            }
        } catch {
            print("집 주소 수정 실패: \(error)")
        }
    }
    
    // MARK: - AccountWithdrawalView Handler
    func deleteAccount() async {
        do {
            let request = WithdrawalRequest(
                withdrawalReasonId: selectedReason.id,
                customReason: selectedReason.content
            )
            
            try await memberRepository.deleteAccount(request: request)
        } catch {
            print("회원 탈퇴 실패: \(error)")
        }
    }
}
