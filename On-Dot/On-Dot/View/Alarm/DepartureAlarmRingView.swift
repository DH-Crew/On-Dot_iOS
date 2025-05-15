//
//  DepartureAlarmRingView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/5/25.
//

import SwiftUI
import Combine

struct DepartureAlarmRingView: View {
    @State private var remainingSeconds: Int = 0
    @State private var timerCancellable: AnyCancellable? = nil
    
    let isSnoozed: Bool
    let schedule: HomeScheduleInfo
    let interval: Int
    let repeatCount: Int
    let type: String
    
    var onClickNavigateButton: () -> Void
    var onClickDelayButton: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.gray900.ignoresSafeArea()
            
            if isSnoozed {
                LottieView(name: "departure_alarm_snoozed", loopMode: .loop)
                    .padding(.top, -85)
                    .offset(y: 69)
            }
            
            VStack(alignment: .center) {
                Spacer().frame(height: 69)
                
                if isSnoozed {
                    HStack(spacing: 0) {
                        Text("일정까지 ")
                            .font(OnDotTypo.titleMediumSB)
                            .foregroundStyle(Color.gray0)
                        
                        Text(DateFormatterUtil.timeLeftUntil(schedule.departureTriggeredAt))
                            .font(OnDotTypo.titleMediumSB)
                            .foregroundStyle(Color.green500)
                        
                        Text(" 전")
                            .font(OnDotTypo.titleMediumSB)
                            .foregroundStyle(Color.gray0)
                    }
                    
                    Text("어서 출발하세요!")
                        .font(OnDotTypo.titleMediumSB)
                        .foregroundStyle(Color.gray0)
                    
                    Spacer().frame(height: 79)
                    
                    Text("\(formatTime(remainingSeconds))")
                        .font(OnDotTypo.titleLargeM)
                        .foregroundStyle(Color.red)
                    
                    Spacer()
                } else {
                    Text("지금 출발해야\n일정에 늦지 않을 수 있어요!")
                        .font(OnDotTypo.titleMediumSB)
                        .foregroundStyle(Color.gray0)
                        .multilineTextAlignment(.center)
                    
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
                            startCountdown()
                        }
                    
                    Spacer().frame(height: 140)
                }
                
                OnDotButton(
                    content: "경로안내 보기",
                    action: {
                        onClickNavigateButton()
                        AlarmPlayer.shared.stop()
                    },
                    style: .outline
                )
                
                Spacer().frame(height: 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 22)
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
