//
//  intropage.swift
//  TranscriSense
//
//  Created by carton22 on 2023/6/8.
//

import Foundation
import SwiftUI
struct intropage: View{
    @EnvironmentObject var isfirstpage:introPart
    var body: some View{
        
        VStack{
            
            GeometryReader{
                geometry in
                Image(systemName: "ear.and.waveform")
                    .resizable()
                    .renderingMode(.original)
                    .foregroundColor(.blue)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100, alignment: .center)
                    .position(x: geometry.size.width/2, y: geometry.size.height*0.2)
                
                Text("TranscriSense")
                    .bold()
                    .font(.largeTitle)
                    .position(x: geometry.size.width/2, y: geometry.size.height*0.33)
                
                HStack{
                    Image(systemName: "captions.bubble")
                        .resizable()
                        .renderingMode(.original)
                        .foregroundColor(.blue)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30, alignment: .center)
                        .position(x: geometry.size.width * 0.2, y: geometry.size.height*0.43)
                    
                    
                    VStack{
                        Text("实时转录现场解说")
                        Text("阶梯式字幕设计\n轻松聚焦注意力")
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.secondary)
                    }
                    .position(x: geometry.size.width * 0.03, y: geometry.size.height*0.43)
                }
                
                HStack{
                    Image(systemName: "dot.circle.and.hand.point.up.left.fill")
                        .resizable()
                        .renderingMode(.original)
                        .foregroundColor(.blue)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30, alignment: .center)
                        .position(x: geometry.size.width * 0.2, y: geometry.size.height*0.56)
                    VStack{
                        Text("随时记录精彩瞬间")
                        Text("    敲下标记按钮\n瞬间记录关键时刻")
                            .foregroundColor(.secondary)
                    }.position(x: geometry.size.width * 0.03, y: geometry.size.height*0.56)
                }
                
                HStack{
                    Image(systemName: "flag.checkered.circle")
                        .resizable()
                        .renderingMode(.original)
                        .foregroundColor(.blue)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30, alignment: .center)
                        .position(x: geometry.size.width * 0.2, y: geometry.size.height*0.68)
                    
                    VStack{
                        Text("精准还原现场气氛")
                        Text("     气泡灵动变换\n随现场气氛动态变化")
                            .foregroundColor(.secondary)
                    }
                    .position(x: geometry.size.width * 0.03, y: geometry.size.height*0.68)
                }
                
                Button(action: {
                    isfirstpage.isfirst = false
                }) {
                    Text("继续")
                        .font(.body)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .frame(width: UIScreen.main.bounds.width - 60, height: 50, alignment: .center)
                        .background(Color.blue)
                        .font(.system(size: 16))
                        .cornerRadius(15)
                }.position(x: geometry.size.width/2, y: geometry.size.height*0.9)
            }
        }
    }
}

struct intropage_Previews: PreviewProvider {
    static var previews: some View {
        intropage().environmentObject(introPart())
    }
}
