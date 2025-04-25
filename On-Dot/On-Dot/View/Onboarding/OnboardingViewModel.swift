
import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 1
    @Published var hourText: String = ""
    @Published var minuteText: String = ""
    @Published var address: String = ""
    @Published var selectedCategory: AlarmCategory = .category1
    @Published var selectedSound: AlarmSound?
    @Published var isMuteMode: Bool = false
    @Published var selectedVolume: Float = 0.5
    
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
    
    func onClickButton() {
        if currentStep < 5 {
            currentStep += 1
        } else if currentStep == 5 {
            // TODO: 온보딩 완료 메서드 호출
        }
    }
}
