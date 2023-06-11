//
//  feedback.swift
//  TranscriSense
//
//  Created by hualingz on 2023/6/10.
//

import SwiftUI
import CoreHaptics
struct feedbackManager{
    @State private var engine: CHHapticEngine?
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("创建引擎时出现错误： \(error.localizedDescription)")
        }
    }
    func complexSuccess() {
        // 确保设备支持震动反馈
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // 创建一个强烈的，锐利的震动
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        // 将震动事件转换成模式，立即播放
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}
// 调用时先创建 feedbackManager
// 再调用prepare函数，再进行震动函数complexSuccess
// Example如下
//struct feedback: View {
//    let fbM: feedbackManager = feedbackManager()
//    var body: some View {
//        Text("Hello, World!")
//            .onAppear(perform: fbM.prepareHaptics)
//            .onTapGesture(perform: fbM.complexSuccess)
//    }
//}
//
//struct feedback_Previews: PreviewProvider {
//    static var previews: some View {
//        feedback()
//    }
//}

