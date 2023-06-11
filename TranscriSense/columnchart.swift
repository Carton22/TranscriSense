//
//  columnchart.swift
//  TranscriSense
//
//  Created by carton22 on 2023/6/10.
//

import SwiftUI
import Charts
//import DGCharts
struct db_time: Identifiable {
    let id = UUID()
    
    public let db: Double
    public let time: Double
    init(db: Double, time: Double) {
        self.db = db
        self.time = time
    }
}

struct columnpainter: View {
    var voiceDBList: [Double] = [
        0.7, 2.3, 3.9, 3.0, 2.6, 1.2, 0.8, 1.8, 3.4, 3.9, 0.4, 1.7, 2.0, 2.1, 2.5, 3.1, 2.3, 1.8, 0.9, 1.1, 2.8, 0.2, 1.5, 1.6, 1.4, 3.2, 0.3, 0.9, 3.6, 1.9, 2.9, 0.7, 3.7, 1.0, 0.5, 1.3, 2.2, 3.8, 0.1, 3.3, 0.8
    ]
    var markedTime: [Double] = [
        0.1,
        5.4,
        10.7,
        15.6
    ]
    @State var width: CGFloat = 360
    @State var height: CGFloat = 100
    @State var allDBvalue: [db_time] = []
    @State var markDBvalue: [db_time] = []

    func get2Lists(){
        var currentTime: Double = 0.0
        var markTimeIndex: Int = 0
        for i in 0..<voiceDBList.count{
                allDBvalue.append(db_time(db: voiceDBList[i], time: currentTime))
                currentTime = currentTime + 5.0
        }
//        0.5表示高亮的宽度
        for i in 0..<markedTime.count{
            markDBvalue.append(db_time(db: voiceDBList[Int(markedTime[i])] + 0.5, time: markedTime[i]))
        }
        
    }
    
    var body: some View {
        Chart{
            ForEach(markDBvalue) { db_time in
                BarMark(
                    x:.value("time", db_time.time),
                    y:.value("db", db_time.db)
                ).foregroundStyle(.yellow)
            }
            ForEach(allDBvalue) { db_time in
                BarMark(
                    x:.value("time", db_time.time),
                    y:.value("db", db_time.db)
                ).foregroundStyle(.orange)
            }
        }.frame(width: width, height:  height)
            .onAppear(perform: {get2Lists()})
        
    }
    
}
