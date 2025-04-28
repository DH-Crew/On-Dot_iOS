
import SwiftUI
import CoreLocation

final class OnboardingViewModel: ObservableObject {
    private let appStorageManager: AppStorageManager
    private let memberRepository: MemberRepository
    
    init(
        appStorageManager: AppStorageManager = AppStorageManager.shared,
        memberRepository: MemberRepository = MemberRepositoryImpl()
    ) {
        self.appStorageManager = appStorageManager
        self.memberRepository = memberRepository
    }
    
    @Published var onboardingCompleted: Bool = false
    
    @Published var currentStep = 1
    @Published var hourText: String = ""
    @Published var minuteText: String = ""
    @Published var address: String = ""
    @Published var selectedCategory: AlarmCategory = .category1
    @Published var selectedSound: AlarmSound?
    @Published var isMuteMode: Bool = false
    @Published var selectedVolume: Float = 0.5
    @Published var isDelayMode: Bool = false
    @Published var selectedInterval: AlarmInterval = .five
    @Published var selectedRepeatCount: RepeatCount = .infinite
    
    var isNextButtonEnabled: Bool {
        switch currentStep {
        case 1:
            return !hourText.isEmpty || !minuteText.isEmpty
        case 2:
            return !address.isEmpty
        case 3:
            return (isMuteMode || selectedSound != nil)
        case 4:
            return selectedExpectationItem != nil
        case 5:
            return selectedReasonItem != nil
        default:
            return false
        }
    }
    
    let totalStep = 5
    let alarmLibrary: [AlarmCategory: [AlarmSound]] = [
        .category1: [
            AlarmSound(name: "Dancing in the Stardust", fileName: "dancing_in_the_stardust.mp3"),
            AlarmSound(name: "In The City Lights Mist", fileName: "in_the_city_lights_mist.mp3"),
            AlarmSound(name: "Fractured Love", fileName: "fractured_love.mp3"),
            AlarmSound(name: "Chasing Lights", fileName: "chasing_lights.mp3"),
            AlarmSound(name: "Ashes of Us", fileName: "ashes_of_us.mp3"),
            AlarmSound(name: "Heating Sun", fileName: "heating_sun.mp3")
        ],
        .category2: [
            AlarmSound(name: "Medal", fileName: "medal.mp3"),
            AlarmSound(name: "Exciting Sports Competitions", fileName: "exciting_sports_competitions.mp3"),
            AlarmSound(name: "Positive Way", fileName: "positive_way.mp3"),
            AlarmSound(name: "Energetic Happy & Upbeat Rock Music", fileName: "energetic_happy_amp_upbeat_rock_music.mp3"),
            AlarmSound(name: "Energy Catcher (A sport rock)", fileName: "energy_catcher_a_sport_rock.mp3")
        ]
    ]
    var currentAlarmList: [AlarmSound] {
        alarmLibrary[selectedCategory] ?? []
    }
    let intervalList: [AlarmInterval] = AlarmInterval.allCases
    let repeatCountList: [RepeatCount] = RepeatCount.allCases
    
    // MARK: OnboardingStep4View
    @Published var selectedExpectationItem: ExpectationItem?
    let gridItems = [
        ExpectationItem(id: 1, imageName: "ic_hurry_up", title: "지각방지"),
        ExpectationItem(id: 2, imageName: "ic_mind_peace", title: "신경 쓰임 해소"),
        ExpectationItem(id: 3, imageName: "ic_calendar_check", title: "간편한 일정 관리"),
        ExpectationItem(id: 4, imageName: "ic_alarm_clock", title: "정확한 출발 타이밍 알림")
    ]
    
    // MARK: OnboardingStep5View
    @Published var selectedReasonItem: ReasonItem?
    let reasonItems = [
        ReasonItem(id: 5, content: "여유 있는 하루를 보내고 싶어서"),
        ReasonItem(id: 6, content: "중요한 사람과의 약속을 잘 지키고 싶어서"),
        ReasonItem(id: 7, content: "계획한 하루를 흐트러짐 없이 보내고 싶어서"),
        ReasonItem(id: 8, content: "시간 약속을 잘 지키는 사람이 되고 싶어서")
    ]
    
    // MARK: Handler
    func onClickButton() {
        if currentStep < 5 {
            if currentStep == 3 { saveAlarmSettings() }
            currentStep += 1
        } else if currentStep == 5 {
            Task {
                await saveOnboardingInfo()
            }
        }
    }
    
    func saveAlarmSettings() {
        appStorageManager.saveMuteMode(value: isMuteMode)
        
        if !isMuteMode {
            if let sound = selectedSound {
                appStorageManager.saveSelectedSound(fileName: sound.fileName)
            }
            appStorageManager.saveSelectedVolume(volume: selectedVolume)
        }
        
        if isDelayMode {
            appStorageManager.saveInterval(interval: selectedInterval)
            appStorageManager.saveRepeatCount(repeatCount: selectedRepeatCount)
        }
    }
    
    private func saveOnboardingInfo() async {
        let hours = Int(hourText) ?? 0
        let minutes = Int(minuteText) ?? 0
        let totalMinutes = (hours * 60) + minutes
        
        guard let coordinate = await getCoordinate(address: address) else {
            print("좌표를 가져올 수 없습니다.")
            return
        }
        
        do {
            try await memberRepository.saveOnboardingInfo(
                request: OnboardingRequest(
                    preparationTime: totalMinutes,
                    roadAddress: address,
                    longitude: coordinate.longitude,
                    latitude: coordinate.latitude,
                    soundCategory: "DEFAULT",
                    ringTone: "DEFAULT",
                    volume: selectedVolume,
                    questions: [
                        OnboardingRequest.Question(questionId: 1, answerId: selectedExpectationItem?.id ?? -1),
                        OnboardingRequest.Question(questionId: 2, answerId: selectedReasonItem?.id ?? -1)
                    ],
                    alarmMode: isMuteMode ? "VIBRATE" : "SOUND",
                    isSnoozeEnabled: isDelayMode,
                    snoozeInterval: selectedInterval.rawValue,
                    snoozeCount: selectedRepeatCount.count
                )
            )
            
            await MainActor.run {
                onboardingCompleted = true
            }
        } catch {
            print("Onboarding 저장 실패: \(error)")
        }
    }
    
    func getCoordinate(address: String) async -> CLLocationCoordinate2D? {
        await withCheckedContinuation { continuation in
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { placemarks, error in
                if let coordinate = placemarks?.first?.location?.coordinate {
                    continuation.resume(returning: coordinate)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
