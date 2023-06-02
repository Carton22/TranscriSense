//
//  start.swift
//  TranscriSense
//
//  Created by carton22 on 2023/5/29.
//

import SwiftUI
//主视图
struct startView: View {
    @State var pageNumber = 1//当前页的ID
    @State var periousOffset = CGSize(width: UIScreen.main.bounds.width, height: 0)
    @State var offset = CGSize(width: UIScreen.main.bounds.width, height: 0)
    @State private var isActive: Bool = false
    
    var body:some View {
        //手势滑动,也算是页面里的算法逻辑了。
        let dragGesture = DragGesture()
            .onChanged { value in
                offset.width = periousOffset.width + value.translation.width
            }
            .onEnded { value in
                if abs(value.translation.width) < 50 {
                    offset.width = periousOffset.width//手势滑动超过50才偏移
                }else{
                    if value.translation.width > 0 && pageNumber > 1 {
                        periousOffset.width += UIScreen.main.bounds.width
                        pageNumber -= 1
                        offset.width = periousOffset.width
                    }else if value.translation.width < 0 && pageNumber < 3 {
                        periousOffset.width -= UIScreen.main.bounds.width
                        pageNumber += 1
                        offset.width = periousOffset.width
                    }else{ offset.width = periousOffset.width }
                }
            }
        VStack(alignment: .center){
            //使用横向偏移切换页面
            HStack {
                PageView(imageName:"leaf.fill",title: "第一页标题")
                PageView(imageName: "gift.fill", title: "第二页标题")
                PageView(imageName: "car.circle.fill", title: "第三页标题")
            }
            .offset(x: offset.width, y: 0)
            .gesture(dragGesture)
            .animation(.interpolatingSpring(stiffness: 100, damping: 10))
            VStack {
                PageIndicator(pageNumber: $pageNumber)//下面的3个小圆点
                button //底部按钮
            }
        }
    }
    var button:some View {
        NavigationStack{
            NavigationLink(destination: atmosBubble(), isActive: $isActive) {
                Button(action: {
                    if pageNumber == 3 {
                        isActive = true
                        print("展示完成") //这里可以写进入主界面
                    }else{
                        periousOffset.width -= UIScreen.main.bounds.width
                        pageNumber += 1
                        offset.width = periousOffset.width
                    }
                }) {
                    Text(pageNumber == 3 ? "开始" : "跳过")
                        .foregroundColor(pageNumber == 3 ? .white : .orange)
                        .multilineTextAlignment(.trailing)
                        .frame(width: UIScreen.main.bounds.width - 60, height: 50, alignment: .center)
                        .background(pageNumber == 3 ? Color.orange : Color.white)
                        .font(.system(size: 16))
                        .cornerRadius(25)
                        .animation(.easeIn)
                }
            }
        }
    }
}

struct PageView: View {
    var imageName:String
    var title:String
    var subTitle = "副标题内容 xxxxxx xxxxxx xxxxxxx xxxxxx"
    var slogen = "太好了 !"
    var body:some View {
        VStack {
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150, alignment: .center)
            
            Text(title)
                .font(.system(size: 36))
                .bold()
                .padding(.top, 70)
            Text(subTitle)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.top, 20)
                .padding(.bottom, 20)
            Text(slogen)
                .font(.system(size: 22))
                .foregroundColor(.orange)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}
//显示下面3个小圆点
struct PageIndicator: View {
    @Binding var pageNumber:Int
    var body:some View {
        HStack {
            ForEach(1..<4){ num in
                circle(num)//显示圆点数量
            }
        }
        .padding(.bottom, 60)
    }
    //定义下面的小圆点
    private func circle(_ num:Int) -> some View {
        Circle()
            .frame(width: 10, height: 10)
            .foregroundColor(pageNumber == num ? .orange : .gray)
    }
}


struct test_Previews: PreviewProvider {
    static var previews: some View {
        startView()
    }
}

