//
//  ActivityList.swift
//  TranscriSense
//
//  Created by HyoraMeteor on 2023/5/29.
//

import Foundation
import SwiftUI

class activityListData{
    var initval: Int
    init(initval: Int) {
        self.initval = initval
    }
}


struct itemView: View{
    @State var text: String = ""
    @Binding var voiceDBList: [Double]
    @Binding var markList: [Double]
    @Binding var startTime: Date
    @Binding var audioLen: Double
    @State var isReleased: Bool = false
    @State var buttonText: Image = Image(systemName: "chevron.down.circle")
    
    func updateReleaseView(){
        if isReleased == false {
            buttonText = Image(systemName: "chevron.up.circle")
            isReleased = true
        }
        else{
            buttonText = Image(systemName: "chevron.down.circle")
            isReleased = false
        }
    }
    
    func date2string(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss" // 设置日期格式
        return formatter.string(from: date)
    }

    func double2string(doubleValue: Double) -> String {
        return String(format: "%.1fs", doubleValue) // 保留一位小数
    }
    
    var body: some View{
        VStack{
            Path { path in
                path.move(to: CGPoint(x: UIScreen.main.bounds.size.width * 0.02, y: 0))
                path.addLine(to: CGPoint(x: UIScreen.main.bounds.size.width * 0.99, y: 0))
            }
            .stroke(Color.secondary, lineWidth: 0.3)
            HStack{
                TextField("Enter game name",text: $text)
                    .font(.system(.body, design: .serif))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .frame(maxWidth:UIScreen.main.bounds.width * 0.8)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                Button(action: updateReleaseView,label: {Text(buttonText)
                        .font(.system(size: 25))
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(40)
                })
            }
            HStack{
                Text(date2string(date: startTime))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .position(CGPoint(x: UIScreen.main.bounds.size.width * 0.115, y: 0))
                Text(double2string(doubleValue:audioLen))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .position(CGPoint(x: UIScreen.main.bounds.size.width * 0.4, y: 0))
            }
            
            if isReleased{
                columnpainter(voiceDBList: voiceDBList, markedTime: markList, width:340,height: 80).frame(width: UIScreen.main.bounds.size.width * 0.7)
            }
            Path { path in
                path.move(to: CGPoint(x: UIScreen.main.bounds.size.width * 0.02, y: 0))
                path.addLine(to: CGPoint(x: UIScreen.main.bounds.size.width * 0.98, y: 0))
            }
            .stroke(Color.secondary, lineWidth: 0.3)
        }
    }
}

struct activityListView: View {
    @State var openActivityView = false
    @EnvironmentObject var intropart:introPart
    @EnvironmentObject var myActivityDataList:activityDataList
    @State var activityCount: Int = 0
    
    let refreshActivityTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func startActivity(){
        openActivityView = true
    }
    
    var body: some View {
        NavigationView{
            VStack {
                GeometryReader{
                    geometry in
                    
                    NavigationLink(destination: atmosBubble(isRootActive: $openActivityView).navigationBarHidden(true), isActive: $openActivityView) { EmptyView() }
                    GeometryReader{
                        geometry in
                        
                        Text("所有比赛")
                            .font(.title)
                            .bold()
                            .position(x: geometry.size.width*0.2, y:geometry.size.height*0.05)
                            .onReceive(refreshActivityTimer) { _ in
                                activityCount = myActivityDataList.activityCount
                            }
                        
                        ScrollView{
                            VStack{
                                if activityCount > 0 {
                                    itemView(text: "audio1", voiceDBList: $myActivityDataList.voiceData[0], markList: $myActivityDataList.markData[0], startTime: $myActivityDataList.startTime[0], audioLen: $myActivityDataList.audioLen[0])
                                }
                                if activityCount > 1 {
                                    itemView(text: "audio2", voiceDBList: $myActivityDataList.voiceData[1], markList: $myActivityDataList.markData[1], startTime: $myActivityDataList.startTime[1], audioLen: $myActivityDataList.audioLen[1])
                                }
                                if activityCount > 2 {
                                    itemView(text: "audio3", voiceDBList: $myActivityDataList.voiceData[2], markList: $myActivityDataList.markData[2], startTime: $myActivityDataList.startTime[2], audioLen: $myActivityDataList.audioLen[2])
                                }
                                if activityCount > 3 {
                                    itemView(text: "audio4", voiceDBList: $myActivityDataList.voiceData[3], markList: $myActivityDataList.markData[3], startTime: $myActivityDataList.startTime[3], audioLen: $myActivityDataList.audioLen[3])
                                }
                                if activityCount > 4 {
                                    itemView(text: "audio5", voiceDBList: $myActivityDataList.voiceData[4], markList: $myActivityDataList.markData[4], startTime: $myActivityDataList.startTime[4], audioLen: $myActivityDataList.audioLen[4])
                                }
                                if activityCount > 5 {
                                    itemView(text: "audio6", voiceDBList: $myActivityDataList.voiceData[5], markList: $myActivityDataList.markData[5], startTime: $myActivityDataList.startTime[5], audioLen: $myActivityDataList.audioLen[5])
                                }
                                if activityCount > 6 {
                                    itemView(text: "audio7", voiceDBList: $myActivityDataList.voiceData[6], markList: $myActivityDataList.markData[6], startTime: $myActivityDataList.startTime[6], audioLen: $myActivityDataList.audioLen[6])
                                }
                                if activityCount > 7 {
                                    itemView(text: "audio8", voiceDBList: $myActivityDataList.voiceData[7], markList: $myActivityDataList.markData[7], startTime: $myActivityDataList.startTime[7], audioLen: $myActivityDataList.audioLen[7])
                                }
                                if activityCount > 8 {
                                    itemView(text: "audio9", voiceDBList: $myActivityDataList.voiceData[8], markList: $myActivityDataList.markData[8], startTime: $myActivityDataList.startTime[8], audioLen: $myActivityDataList.audioLen[8])
                                }
                                if activityCount > 9 {
                                    itemView(text: "audio10", voiceDBList: $myActivityDataList.voiceData[9], markList: $myActivityDataList.markData[9], startTime: $myActivityDataList.startTime[9], audioLen: $myActivityDataList.audioLen[9])
                                }
                            }
                        }.position(x: geometry.size.width/2, y: geometry.size.height/2)
                            .frame(maxHeight:geometry.size.height * 0.8)
                            
                        ZStack{
                            Rectangle()
                                .frame(width: geometry.size.width, height: geometry.size.height*0.35)
                                .position(x: geometry.size.width/2, y: geometry.size.height)
                                .foregroundColor(Color(hex: "#f1eff5"))
                            Image(systemName: "circle")
                                .resizable()
                                .renderingMode(.original)
                                .foregroundColor(.secondary)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 65,height: 65)
                                .position(x: geometry.size.width/2, y: geometry.size.height*0.9)
                            
                            Button(action: startActivity,label: {Image(systemName: "circle.fill")
                                .resizable()
                                .renderingMode(.original)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(.red)
                                .frame(width: 50,height: 50)                    })
                                .position(x: geometry.size.width/2, y: geometry.size.height*0.9)
                        }
                    }.sheet(isPresented: $intropart.isfirst) {
                        intropage()
                    }
                }
            }
        }
    }
}
//
struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        activityListView()
    }
}
