//
//  AlarmPlayer.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/23/25.
//

import AVFoundation
import SwiftUI

final class AlarmPlayer {
    static let shared = AlarmPlayer()
    private init() {
        configureAudioSession()
        setupNotifications()
        startBackgroundSilence()
    }
    
    private var player: AVAudioPlayer?
    private var silentPlayer: AVAudioPlayer?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("오디오 세션 설정 실패: \(error.localizedDescription)")
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
    }
    
    private func startBackgroundSilence() {
        guard let url = Bundle.main.url(forResource: "silence", withExtension: "caf") else {
            print("무음 파일 없음: silence.caf")
            return
        }
        do {
            silentPlayer = try AVAudioPlayer(contentsOf: url)
            silentPlayer?.numberOfLoops = -1
            silentPlayer?.volume = 0
            silentPlayer?.prepareToPlay()
            silentPlayer?.play()
        } catch {
            print("무음 재생 실패: \(error)")
        }
    }
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            player?.pause()
        case .ended:
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt,
               AVAudioSession.InterruptionOptions(rawValue: optionsValue).contains(.shouldResume) {
                player?.play()
            }
        @unknown default:
            break
        }
    }
    
    func play(soundFileName: String, numberOfLoops: Int) {
        if player?.isPlaying == true {
            print("⏸️ 이미 다른 알람이 재생 중입니다. 새로운 알람은 실행되지 않습니다.")
            return
        }
        
        guard let url = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
            print("파일을 찾을 수 없습니다: \(soundFileName)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = numberOfLoops // 0: 1회 재생, -1: 무한 반복, n: n + 1번 재생
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("재생 실패: \(error.localizedDescription)")
        }
    }

    func stop() {
        player?.stop()
    }

    func setVolume(_ volume: Float) {
        player?.volume = max(0.0, min(volume, 1.0))
    }
}
