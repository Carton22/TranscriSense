//
//  ContentView.swift
//  tttttestssss
//
//  Created by hualingz on 2023/5/29.
//

import Speech
import SwiftUI

class Speech2Text{
    
    
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var audioEngine = AVAudioEngine()
     
    var startBtn: Bool = true
    var trans_text: String = ""
    
    func get_text()->String{
        return self.trans_text
    }
    
    func start_trans(){
        // 要求用户授予您的应用许可来执行语音识别。
        SFSpeechRecognizer.requestAuthorization { (status) in
            var isButtonenable = false
            // 识别器的授权状态
            switch status {
                // 经过授权
                case .authorized:
                    // 经过授权之后就允许录音按钮点击
                    isButtonenable = true
                // 拒绝授权
                case .denied:
                    isButtonenable = false
                    print("User denied access to speech recognition")
                // 保密，也就是不授权
                case .restricted:
                    isButtonenable = false
                    print("Speech recognition restricted on this device")
                // 未决定
                case .notDetermined:
                    isButtonenable = false
                    print("Speech recognition not yet authorized")
            @unknown default:
                print("Unknown Default")
            }
            if (isButtonenable == false){
                return
            }
        }
        startRecordingPersonSpeech()
    }
    
    
    
    func startRecordingPersonSpeech(){
        // 检查 recognitionTask 任务是否处于运行状态。如果是，取消任务开始新的任务
        if recognitionTask != nil {
            // 取消当前语音识别任务。
            recognitionTask?.finish()
            // 语音识别任务的当前状态 是一个枚举值
            print(recognitionTask!.state)
            recognitionTask = nil
            
        }
        // 建立一个AVAudioSession 用于录音
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // category 设置为 record,录音
            try audioSession.setCategory(AVAudioSession.Category.record)
            // mode 设置为 measurement
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            // 开启 audioSession
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        // 初始化RecognitionRequest，在后边我们会用它将录音数据转发给苹果服务器
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // 检查 iPhone 是否有有效的录音设备
        guard let inputNode = Optional.some(audioEngine.inputNode) else {
            fatalError("Audio engine has no input node")
        }
        
        //
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        // 在用户说话的同时，将识别结果分批次返回
        recognitionRequest.shouldReportPartialResults = true
        
        // 使用recognitionTask方法开始识别。
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            // 用于检查识别是否结束
            var isFinal = false
            // 如果 result 不是 nil,
            if result != nil {
                // 将 textView.text 设置为 result 的最佳音译
                self.trans_text = (result?.bestTranscription.formattedString) ?? "当前无声音"
                print(self.trans_text)
                // 如果 result 是最终，将 isFinal 设置为 true
                isFinal = (result?.isFinal)!
            }
            
            // 如果没有错误发生，或者 result 已经结束，停止audioEngine 录音，终止 recognitionRequest 和 recognitionTask
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                // 开始录音按钮可用
                self.startBtn = true
            }
        })
        
        // 向recognitionRequest加入一个音频输入
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            // 开始录音
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        self.trans_text="请讲话!"
        
    }
    
    
    // 可以通过分贝数来开启或者关闭录音引擎
    func btn_trans(){
        if audioEngine.isRunning {
            // 停止录音
            audioEngine.stop()
            // 表示音频源已完成，并且不会再将音频附加到识别请求。
            recognitionRequest?.endAudio()
            startBtn=false
        } else {
            startBtn=true
            startRecordingPersonSpeech()
        }
    }
}








var time_line = 0.0
struct speech2textui: View {
    @State private var printtext = ""
    var SpeechReco = Speech2Text()
    var body: some View {
        VStack{
            Text(printtext)
                .onAppear{
                    SpeechReco.start_trans()
                    updatePrintText()
                }
            
        }
    }
    
    private func updatePrintText(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            let hour = Calendar.current.component(.hour, from: Date())
            //这里表示获取“分钟”的数据，minute的数据类型是Int
            let minute = Calendar.current.component(.minute, from: Date())
            let second = Calendar.current.component(.second, from: Date())
            printtext = SpeechReco.get_text()
            printtext = printtext.appending(String(hour))
            printtext = printtext.appending(String(minute))
            printtext = printtext.appending(String(second))
            time_line = time_line + 0.1
            if(time_line>1){
                if SpeechReco.audioEngine.isRunning {
                    // 停止录音
                    SpeechReco.audioEngine.stop()
                    // 表示音频源已完成，并且不会再将音频附加到识别请求。
                    SpeechReco.recognitionRequest?.endAudio()
                    SpeechReco.startBtn=false
                    SpeechReco.startBtn=true
                } else {
                    SpeechReco.startBtn=true
                    SpeechReco.startRecordingPersonSpeech()
                }
                time_line = 0.0
            }
            updatePrintText()
        }
    }
    
}

struct speech2textui_Previews: PreviewProvider {
    static var previews: some View {
        speech2textui()
    }
}
