//
//  atmosBubble.swift
//  TranscriSense
//
//  Created by carton22 on 2023/5/22.
//
import SwiftUI
import Speech


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

func mapVoiceDBToColorString(voiceDB: Double, c1: String, c2:String) -> String {
    let startColor = c1
    let endColor = c2

    let startValue = 0.1
    let endValue = 3.0

    let progress = (voiceDB - startValue) / (endValue - startValue)
    let interpolatedColor = interpolateColor(startColor: startColor, endColor: endColor, progress: progress)

    return interpolatedColor
}

func interpolateColor(startColor: String, endColor: String, progress: Double) -> String {
    guard let startRGB = parseRGB(from: startColor),
        let endRGB = parseRGB(from: endColor) else {
            return startColor
    }

    let interpolatedR = interpolateComponent(startValue: startRGB.red, endValue: endRGB.red, progress: progress)
    let interpolatedG = interpolateComponent(startValue: startRGB.green, endValue: endRGB.green, progress: progress)
    let interpolatedB = interpolateComponent(startValue: startRGB.blue, endValue: endRGB.blue, progress: progress)

    let interpolatedColor = RGB(red: interpolatedR, green: interpolatedG, blue: interpolatedB)
    let colorString = colorToHexString(color: interpolatedColor)
    return colorString
}

func interpolateComponent(startValue: Double, endValue: Double, progress: Double) -> Double {
    return startValue + (endValue - startValue) * progress
}

func parseRGB(from colorString: String) -> RGB? {
    guard colorString.count == 7 else {
        return nil
    }

    let start = colorString.index(colorString.startIndex, offsetBy: 1)
    let hexValue = colorString[start...]
    
    var rgbValue: UInt64 = 0
    Scanner(string: String(hexValue)).scanHexInt64(&rgbValue)
    
    let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = Double(rgbValue & 0x0000FF) / 255.0

    return RGB(red: red, green: green, blue: blue)
}

func colorToHexString(color: RGB) -> String {
    let r = String(format: "%02X", Int(color.red*256))
    let g = String(format: "%02X", Int(color.green*256))
    let b = String(format: "%02X", Int(color.blue*256))

    return "#" + r + g + b
}

struct RGB {
    let red: Double
    let green: Double
    let blue: Double
}

var recordManager = RecordManager()

class TimelineNodes: ObservableObject {
    @Published var markedNodes = [Double]()
    @Published var voiceDBList = [Double]()
    @Published var startTime = Date()
    @Published var audioLen: Double = 0.0
    
    func updateMarkedNodes(timeData: Double) {
        markedNodes.append(timeData)
    }
    func removeMarkedNodesLast() {
        markedNodes.removeLast()
    }
    func getMarkedNodes()->[Double]{
        return markedNodes
    }
    
    //VoiceDB Related Options
    func updateVoiceDB(val: Double){
        voiceDBList.append(val)
    }
    func getVoiceDBList()->[Double]{
        return voiceDBList
    }
}

var time_line = 0.0
var turn_off = 0.0

struct atmosBubble: View {
    //speech2textui variables
    var fbM: feedbackManager = feedbackManager()
    @State var startTime = Date()
    @State var isbegin: Bool = false
    @State private var printtext = ""
    @State private var recentRes: [String] = [" "," "," "," "]
    @State private var isAddtime: Bool = true
    @State var textCounter: Int = 0
    @State var currentTime: String = "00:00:00"
    
    //initial variables
    @State private var animationAmount: CGFloat = 5
    @State private var isRecordingFlag: Bool = false
    @State private var recordButtonImage: Image = Image(systemName: "play.circle")
    @State private var recordButtonColor: Color = Color.secondary
    @State private var openResultView: Bool = false
    @State private var frameSize: Int = 480
    @State private var voiceDB: Double = 0.0
    @State private var circleColor: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "#195CA2"), Color(hex: "#83CBA6")]),
        startPoint: .center,
        endPoint: .top)
    @ObservedObject var timeline: TimelineNodes = TimelineNodes()
    @Binding var isRootActive: Bool
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    let volumntimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    func onRecordButtonClicked(){
        if isRecordingFlag == false{
            isRecordingFlag = true
            startTime = Date()
            recordManager.beginRecord()
            UpdateVoiceDB()
            recordButtonImage = Image(systemName: "stop.circle")
            recordButtonColor = Color.secondary
        }
        else{
            isRecordingFlag = false
            timeline.startTime = startTime
            timeline.audioLen = Date().timeIntervalSince(startTime)
            recordManager.stopRecord()
            openResultView = true
        }
    }
    
//
    private func updateCircleColor() {
        if voiceDB <= 0.1 {
            circleColor = LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#195CA2"), Color(hex: "#83CBA6")]),
                startPoint: .center,
                endPoint: .top
            )
        } else if voiceDB >= 3 {
            circleColor = LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#DD2121"), Color(hex: "#B69A39")]),
                startPoint: .center,
                endPoint: .top
            )
        }else{
            circleColor = LinearGradient(
                gradient: Gradient(colors: [Color(hex: mapVoiceDBToColorString(voiceDB: voiceDB,c1: "#195CA2",c2: "#DD2121")), Color(hex: mapVoiceDBToColorString(voiceDB: voiceDB,c1: "#83CBA6",c2: "#B69A39"))]),
                startPoint: .center,
                endPoint: .top
            )
        }
        frameSize = min(700, Int(480+voiceDB*60))
    }


    var body: some View {
        NavigationView{
            VStack {
                NavigationLink(destination: resultPageView(timeline: timeline, isRootActive: $isRootActive).navigationBarHidden(true), isActive: $openResultView) {
                    EmptyView()
                }
                GeometryReader{
                    geometry in
                    Spacer()
                    if isRecordingFlag{
                        HStack {
                            if(recentRes.count > 0){
                                Text(recentRes[0])
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .frame(width:  geometry.size.width*0.9)
                                    .opacity(0.2)
                                    .padding()
                            }else{
                                Text("").foregroundColor(.white)
                            }
                        }.position(x: geometry.size.width/2, y: geometry.size.height*0.12)
                        
                        HStack {
                            if(recentRes.count > 1){
                                Text(recentRes[1])
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .frame(width:  geometry.size.width*0.9)
                                    .opacity(0.4)
                                    .padding()
                            }else{
                                Text("").foregroundColor(.white)
                            }
                        }.position(x: geometry.size.width/2, y: geometry.size.height*0.2)
                        
                        HStack {
                            if(recentRes.count > 2){
                                Text(recentRes[2])
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .frame(width:  geometry.size.width*0.9)
                                    .opacity(0.6)
                                    .padding()
                            }else{
                                Text("").foregroundColor(.white)
                            }
                        }.position(x: geometry.size.width/2, y: geometry.size.height*0.28)
                        
                        HStack {
                            if(recentRes.count > 3){
                                Text(recentRes[3])
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .frame(width:  geometry.size.width*0.9)
                                    .opacity(0.8)
                                    .padding()
                            }else{
                                Text("").foregroundColor(.white)
                            }
                        }.position(x: geometry.size.width/2, y: geometry.size.height*0.36)
                        
                        Text(currentTime)
                            .font(.caption)
                            .foregroundColor(.primary)
                            .opacity(1.0)
                            .position(x: geometry.size.width*0.13, y: geometry.size.height*0.44)
                            .onAppear(){
                                updateCurrentTime()
                            }
                        
                        Button(action: {
                            if isAddtime{
                                var currentTimeData = Date().timeIntervalSince(startTime)
                                timeline.updateMarkedNodes(timeData: currentTimeData)
                            } else{
                                timeline.removeMarkedNodesLast()
                            }
                            isAddtime.toggle()
                        }){
                            Image(systemName: isAddtime ? "hand.thumbsup.circle" : "hand.thumbsdown.circle")
                                .font(.headline)
                                .frame(width: 80, height: 80)
                                .foregroundColor(isAddtime ?.blue:.pink)
                                .cornerRadius(10)
                        }.position(x: geometry.size.width*0.9, y: geometry.size.height*0.44)
                        
                        Text(printtext)
                            .overlay(
                                // 添加文末小圆点
                                Circle()
                                    .fill(circleColor)
                                    .frame(width: 15, height: 15)
                                    .offset(x: 18, y: 0)
                                    .opacity(printtext.isEmpty ? 0 : 1) // 只有当printtext非空时才显示小圆点
                                , alignment: .trailing // 将小圆点叠加在Text的尾部
                            )
                            .onAppear {
                                updatePrintText()
                            }
                            .position(x: geometry.size.width/2, y: geometry.size.height*0.44)
                            .frame(width:  geometry.size.width*0.5)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .opacity(1.0)
                    }
                    
                    Circle()
                        .fill(circleColor)
                        .frame(width: CGFloat(frameSize+Int(animationAmount*2)), height: CGFloat(frameSize*100))
                        .shadow(color: Color.gray, radius: 10, x: 0, y: -5)
                        .position(x: geometry.size.width / 2, y: geometry.size.height)
                        .onReceive(timer) { _ in
                            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                animationAmount = -5
                            }
                        }
                    
                    Button(action: onRecordButtonClicked, label: {Text(recordButtonImage)
                            .padding()
                            .background(.clear)
                            .font(.system(size: 65))
                            .foregroundColor(recordButtonColor)
                        .cornerRadius(40)})
                    .position(x: geometry.size.width/2, y: geometry.size.height*0.9)
                    .onReceive(volumntimer) { _ in
                        if recordManager.recorder != nil{
                            updateCircleColor()
                            voiceDB = recordManager.getVoiceDB()
                        }
                    }
                }
            }
        }
    }
    
    @State private var timeCount: Double = 0.0
    @State private var peroidVoiceDB: [Double] = [Double]()
    
    private func UpdateVoiceDB(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            if(timeCount>1){
                var totalVoice: Double = peroidVoiceDB.reduce(0, +)
                var VoiceCount: Double = Double(peroidVoiceDB.count)
                var avgVoice: Double = totalVoice/VoiceCount
                timeline.updateVoiceDB(val: avgVoice)
                peroidVoiceDB = []
                timeCount = 0
            } else{
                peroidVoiceDB.append(voiceDB)
                timeCount += 0.1
            }
            if openResultView == false{
                UpdateVoiceDB()
            }
        }
    }
    
    //speech2textui functions
    func performSpeechRecognition() {
        // 创建语音识别器
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
        // 检查设备是否支持语音识别
        guard let recognizer = recognizer, recognizer.isAvailable else {
            print("设备不支持语音识别")
            return
        }
        // 创建一个音频引擎
        let audioEngine = AVAudioEngine()
        // 创建语音识别请求
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        // 检查语音识别授权状态
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // 在授权状态回调中处理授权状态
            if authStatus == .authorized {
                // 配置音频会话
                try? AVAudioSession.sharedInstance().setCategory(.record, mode: .default, options: [])
                try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                // 获取音频输入节点
                let inputNode = audioEngine.inputNode
                // 安装语音识别请求到音频引擎
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.outputFormat(forBus: 0)) { buffer, _ in
                    // 将音频数据添加到语音识别请求中
                    recognitionRequest.append(buffer)
                }
                
                // 开始音频引擎
                audioEngine.prepare()
                do {
                    try audioEngine.start()
                } catch {
                    print("音频引擎启动失败：\(error)")
                }
                // 开始语音识别任务
                var recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
                    if let result = result {
                        // 获取语音识别结果字符串
                        let transcription = result.bestTranscription.formattedString
                        print("语音识别结果：\(transcription)")
                        printtext = transcription
                    } else if let error = error {
                        print("语音识别错误：\(error)")
                    }
                }
                // 等待 10 秒后停止语音识别任务
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    audioEngine.stop()
                    recognitionRequest.endAudio()
                    recognitionTask.cancel()
                }
            } else {
                print("用户未授权语音识别")
            }
        }
    }
    
    private func updateCurrentTime(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            let relTime = Date().timeIntervalSince(startTime)
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            if let formattedString = formatter.string(from: relTime) {
                currentTime = formattedString
            }
            updateCurrentTime()
        }
    }
    
    func rollclear(input_array: [String], input_text: String)->[String] {
        var array = input_array
        array[0] = array[1]
        array[1] = array[2]
        array[2] = array[3]
        array[3] = input_text
        return array
    }
    
    private func updatePrintText(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            if isbegin == false {
                if isRecordingFlag == true{
                    performSpeechRecognition()
                    isbegin = true
                }
            }
            if(time_line>5){
                textCounter += 1
                isAddtime = true
                time_line = 0.0
                recentRes = rollclear(input_array: recentRes, input_text: printtext)
                
                // 震动调用
                fbM.prepareHaptics()
                fbM.complexSuccess()
            }
            if turn_off>5{
                if isRecordingFlag == true{
                    performSpeechRecognition()
                    turn_off = 0
                }
            }
            time_line = time_line + 0.1
            turn_off = turn_off + 0.1
            if isRecordingFlag == true{
                updatePrintText()
            }
        }
    }
}
//
//struct atmosBubble_Previews: PreviewProvider {
//    static var previews: some View {
//        atmosBubble(isRootActive: Binding<true>)
//    }
//}
