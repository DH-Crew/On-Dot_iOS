//
//  PreparationAlarmRingView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/5/25.
//

import SwiftUI
import Combine

struct PreparationAlarmRingView: View {
    @State private var remainingSeconds: Int = 0
    @State private var timerCancellable: AnyCancellable? = nil
    
    let isSnoozed: Bool
    let schedule: HomeScheduleInfo
    let interval: Int
    let repeatCount: Int
    let type: String
    
    var onPreparationStarted: () -> Void
    var onClickDelayButton: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.gray900.ignoresSafeArea()
            
            if isSnoozed {
                LottieView(name: "preparation_alarm_snoozed", loopMode: .loop)
                    .padding(.top, -85)
                    .offset(y: 69)
            }
            
            VStack(alignment: .center) {
                Spacer().frame(height: 69)
                
                HStack(spacing: 0) {
                    Text("출발하기까지 ")
                        .font(OnDotTypo.titleMediumSB)
                        .foregroundStyle(Color.gray0)
                    
                    Text(DateFormatterUtil.timeLeftUntil(schedule.appointmentAt))
                        .font(OnDotTypo.titleMediumSB)
                        .foregroundStyle(Color.green500)
                }
                
                Text(isSnoozed ? "어서 준비를 시작하세요!" : "준비를 시작하세요!")
                    .font(OnDotTypo.titleMediumSB)
                    .foregroundStyle(Color.gray0)
                
                if isSnoozed {
                    Spacer().frame(height: 79)
                    
                    Text("\(formatTime(remainingSeconds))")
                        .font(OnDotTypo.titleLargeM)
                        .foregroundStyle(Color.red)
                    
                    Spacer()
                } else {
                    Spacer().frame(height: 54)
                    
                    Text(DateFormatterUtil.formatShortKoreanMonthDay(schedule.appointmentAt))
                        .font(OnDotTypo.titleSmallM)
                        .foregroundStyle(Color.gray0)
                    
                    Text(DateFormatterUtil.formatTimeNumber(schedule.appointmentAt))
                        .font(OnDotTypo.titleLargeM)
                        .foregroundStyle(Color.gray0)
                    
                    Spacer().frame(height: 16)
                    
                    Text("새로운 일정")
                        .font(OnDotTypo.bodyLargeR1)
                        .foregroundStyle(Color.gray0)
                    
                    Spacer()
                    
                    Text("\(interval)분 알람 미루기")
                        .font(OnDotTypo.titleSmallSB)
                        .foregroundStyle(Color.gray200)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray700)
                        )
                        .onTapGesture {
                            onClickDelayButton()
                        }
                    
                    Spacer().frame(height: 140)
                }
                
                OnDotButton(
                    content: type == "prep" ? "준비 시작하기" : "출발하기",
                    action: {
                        onPreparationStarted()
                        AlarmPlayer.shared.stop()
                    },
                    style: .green500
                )
                
                Spacer().frame(height: 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 22)
        }
        .onAppear {
            if isSnoozed {
                remainingSeconds = interval * 60
                startCountdown()
            }
        }
        .onDisappear {
            stopCountdown()
        }
    }
    
    // 타이머 시작
    private func startCountdown() {
        remainingSeconds = interval * 60
        
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if remainingSeconds > 0 {
                    remainingSeconds -= 1
                } else {
                    stopCountdown()
                }
            }
    }
    
    // 타이머 종료
    private func stopCountdown() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    // 시간 포맷팅: 분:초 형식
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
