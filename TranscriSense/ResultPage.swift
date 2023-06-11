//
//  ResultPage.swift
//  TranscriSense
//
//  Created by HyoraMeteor on 2023/6/2.
//

import Foundation
import SwiftUI

struct resultPageView: View {
    @ObservedObject var timeline = TimelineNodes()
    @EnvironmentObject var myActivityDataList: activityDataList
    @Binding var isRootActive: Bool
    
    func onReturnButtonClicked(){
        var markRecord = timeline.getMarkedNodes()
        var voiceDBRecord = timeline.getVoiceDBList()
        var startTimeRecord = timeline.startTime
        var audioLenRecord = timeline.audioLen
        myActivityDataList.appendActivityData(markInput: markRecord, voiceInput: voiceDBRecord, startTimeInput: startTimeRecord, audioLenInput: audioLenRecord)
        self.isRootActive = false
    }
    
    var body: some View {
        NavigationView{
            VStack {
                GeometryReader{
                    geometry in
                    Spacer()
            
                    Text("观赛数据")
                        .bold()
                        .font(.title)
                        .position(x:geometry.size.width*0.2, y:geometry.size.height*0.05)
                    
                    Text("精彩瞬间")
                        .bold()
                        .font(.body)
                        .position(x:geometry.size.width*0.15, y:geometry.size.height*0.15)
                    columnpainter(voiceDBList: timeline.voiceDBList, markedTime: timeline.markedNodes)
                        .position(x: geometry.size.width/2, y: geometry.size.height*0.25)
                    
                    Text("观赛数据")
                        .bold()
                        .font(.body)
                        .position(x:geometry.size.width*0.15, y:geometry.size.height*0.37)
                    PieChart(voiceDBList: timeline.voiceDBList).frame(width: geometry.size.width * 0.8, height: geometry.size.width/2)
                        .position(x: geometry.size.width/2, y: geometry.size.height*0.65)
                  
                    Button(action: onReturnButtonClicked, label: {Image(systemName: "house.circle")
                            .font(.title)
                            .foregroundColor(.blue)})
                    .position(x:geometry.size.width*0.9, y:geometry.size.height*0.05)
                    
                }
            }
        }
    }
}
//
//struct ResultPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        resultPageView()
//    }
//}

