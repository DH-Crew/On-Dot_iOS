
import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 1
    @Published var hourText: String = ""
    @Published var minuteText: String = ""
    @Published var address: String = ""
    
    let totalStep = 5
    
    func onClickButton() {
        if currentStep < 5 {
            currentStep += 1
        } else if currentStep == 5 {
            // TODO: 온보딩 완료 메서드 호출
        }
    }
}
