//
//  ActivityList.swift
//  TranscriSense
//
//  Created by 小林明 on 2023/5/29.
//

import Foundation
import SwiftUI

struct itemView: View{
    var text: String
    @State var isReleased: Bool = false
    @State var releaseText: String = ""
    
    func releaseView(){
        if isReleased == false {
            releaseText = "jqsbfiqfbiodqjsbojlbdqejfqojsba,mbfkqljscbalejfbqlsmbca,msfbdlqejsbqldjsbjbfoqjbesoebj"
            isReleased = true
        }
        else{
            releaseText = ""
            isReleased = false
        }
    }
    
    var body: some View{
        VStack{
            HStack{
                Text(text)
                    .font(.system(size: 30))
                    .padding(10)
                Button(action: releaseView,label: {Text("展开")
                        .font(.system(size: 15))
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                })
            }
            Text(releaseText)
                .font(.system(size: 20))
                .padding(10)
        }
    }
}

struct activityListView: View {
    @State private var openActivityView = false
    
    func startActivity(){
        openActivityView = true
    }
    
    var body: some View {
        NavigationView{
            VStack {
                NavigationLink(destination: recorderView(), isActive: $openActivityView) { EmptyView() }
                GeometryReader{
                    geometry in
                    Spacer()
                    
                    Text("My Activity List")
                        .font(.system(size: 40))
                        .padding()
                        .position(x:geometry.size.width/2, y:geometry.size.height*0.1)
                    
                    ScrollView{
                        VStack{
                            itemView(text: "This is activity 1")
                            itemView(text: "This is activity 2")
                            itemView(text: "This is activity 3")
                            itemView(text: "This is activity 4")
                            itemView(text: "This is activity 5")
                            itemView(text: "This is activity 6")
                            itemView(text: "This is activity 7")
                            itemView(text: "This is activity 8")
                            itemView(text: "This is activity 9")
                            itemView(text: "This is activity 10")
//                            itemView(text: "This is activity 11")
//                            itemView(text: "This is activity 12")
//                            itemView(text: "This is activity 13")
//                            itemView(text: "This is activity 14")
                        }
                    }.position(x: geometry.size.width/2, y: geometry.size.height/2)
                        .frame(maxHeight: 400)
                    
                    Button(action: startActivity, label: {Text("Start a new Activity!")
                            .font(.system(size: 25))
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                        .cornerRadius(40)})
                    .position(x: geometry.size.width/2, y: geometry.size.height*0.9)
                }
            }
        }
    }
}

struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        activityListView()
    }
}
