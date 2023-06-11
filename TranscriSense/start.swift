import SwiftUI
//主视图
struct start: View {
    @State var pageNumber = 1//当前页的ID
    @State var periousOffset = CGSize(width: UIScreen.main.bounds.width, height: 0)
    @State var offset = CGSize(width: UIScreen.main.bounds.width, height: 0)
    @EnvironmentObject var building:introPart
    
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
                PageView(imageName:"ear.and.waveform",title: "TranscriSense",subTitle: "一款听力障碍者沉浸式观赛App",slogen: "",imagecolor: .green)
                PageView(imageName: "captions.bubble.fill", title: "实时获取现场解说",subTitle: "阶梯式设计字幕\n轻松获取时间\n随时随地记录精彩瞬间",slogen: "",imagecolor: .green)
                PageView(imageName: "flag.checkered.circle.fill", title: "精准还原现场气氛",subTitle: "可呼吸气泡🫧模块\n冷暖颜色灵活调整\n气泡大小绝不设限",slogen: "",imagecolor: .green)
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
        Button(action: {
            if pageNumber == 3 {
                print("展示完成") //这里可以写进入主界面
            }else{
                periousOffset.width -= UIScreen.main.bounds.width
                pageNumber += 1
                offset.width = periousOffset.width
            }
            building.isfirst = false
        }) {
            Text(pageNumber == 3 ? "开始" : "跳过")
                .foregroundColor(pageNumber == 3 ? .white : .blue)
                .multilineTextAlignment(.trailing)
                .frame(width: UIScreen.main.bounds.width - 60, height: 50, alignment: .center)
                .background(pageNumber == 3 ? Color.blue : Color.white)
                .font(.system(size: 16))
                .cornerRadius(25)
                .animation(.easeIn)
        }
        
    }
}

struct PageView: View {
    var imageName:String
    var title:String
    var subTitle = "副标题内容"
    var slogen = "正文内容"
    var imagecolor:Color = Color.blue
    var body:some View {
        VStack {
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.original)
                .foregroundColor(imagecolor)
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
                .foregroundColor(.blue)
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
            .foregroundColor(pageNumber == num ? .blue : .gray)
    }
}


struct test_Previews: PreviewProvider {
    static var previews: some View {
        start().environmentObject(introPart())
    }
}
