//
//  On_DotApp.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/2/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // 🔥 ADDED: 백그라운드 오디오 허용을 위한 설정 (Info.plist에도 UIBackgroundModes=audio 필요)
//        let _ = AlarmPlayer.shared // 싱글톤 초기화 → 무음 재생 시작
        let center = UNUserNotificationCenter.current()
        center.delegate = NotificationDelegate.shared
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
            } else {
                print("알림 권한 상태: \(granted)")
            }
        }
        return true
    }
    
    func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url, options: options)
        }
        return false
    }
}

@main
struct On_DotApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        KakaoSDK.initSDK(appKey: KAKAO_NATIVE_APP_KEY)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .dynamicTypeSize(.medium)
        }
    }
}

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()

    // 포그라운드 수신 시: 사운드 재생
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
//        AlarmService.shared.playAlarm()
//        NotificationCenter.default.post(
//            name: .didReceivePush,
//            object: nil,
//            userInfo: response.notification.request.content.userInfo
//        )
        return [.banner, .sound]
    }

    // 알림 탭했을 때 (잠금 해제 포함)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
//        AlarmService.shared.playAlarm()
//        NotificationCenter.default.post(
//            name: .didReceivePush,
//            object: nil,
//            userInfo: response.notification.request.content.userInfo
//        )
        completionHandler()
    }
}

extension Notification.Name {
    static let didReceivePush = Notification.Name("didReceivePush")
}
