//
//  TranscriSenseApp.swift
//  TranscriSense
//
//  Created by carton22 on 2023/5/22.
//

import SwiftUI


final class introPart:ObservableObject{
    @Published var isfirst: Bool = true
}
final class activityDataList: ObservableObject{
    @Published var activityCount = 0
    @Published var markData: [[Double]] = [[Double]]()
    @Published var voiceData: [[Double]] = [[Double]]()
    @Published var startTime: [Date] = [Date]()
    @Published var audioLen: [Double] = [Double]()
    func appendActivityData(markInput: [Double], voiceInput: [Double], startTimeInput: Date, audioLenInput: Double){
        markData.append(markInput)
        voiceData.append(voiceInput)
        startTime.append(startTimeInput)
        audioLen.append(audioLenInput)
        activityCount += 1
    }
    func printActivityDBList(){
        print(markData)
        print(voiceData)
    }
}
@main
struct TranscriSenseApp: App {
    @StateObject private var intro=introPart()
    @StateObject private var actList = activityDataList()
    var body: some Scene {
        WindowGroup {
            activityListView().environmentObject(intro).environmentObject(actList)
        }
    }
}




