//
//  MyPageViewModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/29/25.
//

import SwiftUI

final class MyPageViewModel: ObservableObject {
    private let locationRepository: LocationRepository
    
    init(
        locationRepository: LocationRepository = LocationRepositoryImpl()
    ) {
        self.locationRepository = locationRepository
    }
    
    // MARK: - MyPageView State
    @Published var isPolicyViewPresented: Bool = false
    @Published var isTermsViewPresented: Bool = false
    
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
}
