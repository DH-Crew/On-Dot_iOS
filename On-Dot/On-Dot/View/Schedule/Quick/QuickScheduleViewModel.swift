//
//  QuickScheduleCreateViewModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/18/25.
//

import SwiftUI
import Speech
import Combine

final class QuickScheduleViewModel: ObservableObject {
    private let scheduleRepository: ScheduleRepository
    private var speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "ko_KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @Published var isChecked: Bool = false
    @Published var voiceInput: String = ""
    @Published var voiceInputPreview: String = ""
    @Published var isActiveSTT: Bool = false
    @Published var isRecording: Bool = false
    @Published var totalStep: Int = 2
    @Published var currentStep: Int = 1
    
    init(
        scheduleRepository: ScheduleRepository = ScheduleRepositoryImpl()
    ) {
        self.scheduleRepository = scheduleRepository
    }
    
    func parseSTT() async {
        if voiceInput.isEmpty { return }
        
        do {
            let response = try await scheduleRepository.parseSTT(request: STTRequest(text: voiceInput))
            print("STT 파싱 결과: \(response)")
        } catch {
            print("STT 파싱 실패: \(error)")
        }
    }
    
    func toggleSTT() {
        if audioEngine.isRunning {
            stopSTT()
        } else {
            startSTT()
        }
    }
    
    // STT 시작
    func startSTT() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            if status == .authorized {
                DispatchQueue.main.async { [weak self] in
                    self?.isRecording = true
                    self?.startRecording()
                }
            } else {
                print("STT 권한이 없습니다.")
            }
        }
    }
    
    // STT 종료
    func stopSTT() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        DispatchQueue.main.async {
            self.isRecording = false
            self.voiceInput = self.voiceInputPreview
        }
        
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        
        // 오디오 세션 해제
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("오디오 세션 해제 실패: \(error.localizedDescription)")
        }
        
        Task {
            await parseSTT()
        }
    }
    
    // 녹음 시작
    private func startRecording() {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            print("STT 요청 생성 실패")
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // 오디오 세션 설정
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(
                .playAndRecord,
                mode: .default,
                options: [.defaultToSpeaker, .allowBluetooth, .allowAirPlay]
            )
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("오디오 세션 설정 실패: \(error.localizedDescription)")
            return
        }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.inputFormat(forBus: 0)
        
        // 샘플 레이트 체크
        if recordingFormat.sampleRate == 0 {
            print("샘플 레이트가 0Hz 입니다. 오디오 세션이 제대로 설정되지 않았습니다.")
            return
        }

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            print("오디오 엔진이 시작되었습니다.")
        } catch {
            print("오디오 엔진 시작 실패: \(error.localizedDescription)")
        }
        
        // 실시간 텍스트 업데이트
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.voiceInputPreview = result.bestTranscription.formattedString
                }
            }
            
            if error != nil || result?.isFinal == true {
                self.stopSTT()
            }
        }
    }
}
