//
//  OnboardingRequest.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

struct OnboardingRequest: Codable {
    let preparationTime: Int
    let roadAddress: String
    let longitude: Double
    let latitude: Double
    let soundCategory: String
    let ringTone: String
    let volume: Float
    let questions: [Question]
    let alarmMode: String
    let isSnoozeEnabled: Bool
    let snoozeInterval: Int
    let snoozeCount: Int

    struct Question: Codable {
        let questionId: Int
        let answerId: Int
    }
}
