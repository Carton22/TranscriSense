import SwiftUI
import Charts


//添加一个圆弧形状
struct PieSliceShape:InsettableShape {
    var percent:Double
    var startAngle:Angle
    var insetAmount:CGFloat = 0
    func inset(by amount: CGFloat) -> some InsettableShape {
        var slice = self
        slice.insetAmount += amount
        return slice
    }
    func path(in rect: CGRect) -> Path {
        Path(){path in
            path.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2), radius: rect.size.width/2 - insetAmount, startAngle: startAngle, endAngle: startAngle + Angle(degrees: percent * 360), clockwise: false)
        }
    }
}

//生成圆弧视图
struct PieSlice:View {
    var percent:Double
    var degree:Double
    var color:Color
    var body: some View{
        GeometryReader{geometry in
            PieSliceShape(percent: percent, startAngle: Angle(degrees: degree))
                .strokeBorder(color,lineWidth: geometry.size.width/2)
                .rotationEffect(.degrees(-90))
                .aspectRatio(contentMode: .fit)
        }
    }
}
struct DataPoints: Identifiable{
    let id = UUID()
    let name: String
    let status: String
    let percent: Double
    let color: Color
    var startAngle: Double = 0
    var formattedPercentage: String{
            String(format: "%.2f %%", percent * 100)
    }
    init(name: String,status: String, percent: Double,color: Color) {
        self.name = name
        self.percent = percent
        self.status = status
        self.color = color
    }
}

// 饼状图的输入为一个list，这个list中的每一个元素都是一个datapoints
// 初始化只需要name、percent、color即可


struct datas{
    var datalist: [DataPoints]=[]
    mutating func update_angle(){
        if datalist.count<1{
            return
        }
        for i in 1..<datalist.count {
            let previous = datalist[i-1]
            let angle = previous.startAngle + previous.percent * 360
            var current = datalist[i]
            current.startAngle = angle
            datalist[i] = current
            print(angle)
        }
    }
    init(datalist: [DataPoints]) {
        self.datalist = datalist
        update_angle()
    }
}

var DBsample: [Double] = [
    0.1,
    0.4,
    0.7,
    1.6
]

struct PieChart:View {
    
    @State var voiceDBList: [Double] = []
    @State var datak: [DataPoints] = []
    
    @State var data_pie: datas = datas(datalist: [])
    
    func getPercent(){
        var percentOne: Double = 0.0
        var percentTwo: Double = 0.0
        var percentThree: Double = 0.0
        for i in 0..<voiceDBList.count{
            if voiceDBList[i]<0.5{
                percentOne = percentOne + 1
            }else if voiceDBList[i]<1.0{
                percentTwo = percentTwo + 1
            }else{
                percentThree = percentThree + 1
            }
        }
        percentOne = percentOne/Double(voiceDBList.count)
        percentTwo = percentTwo/Double(voiceDBList.count)
        percentThree = percentThree/Double(voiceDBList.count)
        
        datak.append(DataPoints(name: "0-0.5 DB", status: "平静", percent: percentOne, color: Color(hex: "#f4d35e")))
        datak.append(DataPoints(name: "0.5-1.0 DB", status: "紧张", percent: percentTwo, color: Color(hex: "#ee964b")))
        datak.append(DataPoints(name: ">1.0 DB", status: "热烈", percent: percentThree, color: Color(hex: "#d5573b")))
        data_pie = datas(datalist: datak)
        
    }
    var body: some View{
        VStack{
            ZStack{
                ForEach(data_pie.datalist) { points in
                    PieSlice(percent: points.percent, degree: points.startAngle, color: points.color)
                        .shadow(radius: points.percent * 10)
                }
            }.aspectRatio(contentMode: .fill)
                .padding()
            
            HStack{
                ForEach(data_pie.datalist) { points in
                    HStack( spacing: 16, content: {
                        Circle()
                            .foregroundColor(points.color)
                            .frame(width: 16, height: 16)
                            .shadow(radius: 7)
                        VStack{
                            Text("\(points.status)")
                                .foregroundColor(.primary)
                                .frame(alignment: .trailing)
                            Text("\(points.formattedPercentage)")
                                .foregroundColor(.secondary)
                        }
                    })
                }
            }
        }.onAppear(perform: {getPercent()})
    }
}

struct painter: View {
    var body: some View {
        VStack{
            GeometryReader{
                geometry in
                Text("观赛数据")
                    .bold()
                    .font(.title)
                    .position(x:geometry.size.width*0.2, y:geometry.size.height*0.05)
                
                Text("精彩瞬间")
                    .bold()
                    .font(.body)
                    .position(x:geometry.size.width*0.15, y:geometry.size.height*0.15)
         
                
                Text("观赛数据")
                    .bold()
                    .font(.body)
                    .position(x:geometry.size.width*0.15, y:geometry.size.height*0.37)
                PieChart(voiceDBList: DBsample).frame(width: geometry.size.width * 0.8, height: geometry.size.width/2)
                    .position(x: geometry.size.width/2, y: geometry.size.height*0.65)
            }
        }
    }
}



