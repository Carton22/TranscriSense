//
//  atmosBubble.swift
//  TranscriSense
//
//  Created by carton22 on 2023/5/22.
//
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct atmosBubble: View {
    @State private var soundDB: Double = 30
    @State private var animationAmount: CGFloat = 5
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            GeometryReader{
                geometry in
                Spacer()
                Circle()
                    .fill(circleColor)
//                change the number 8 to change bewtween fierce and calm atmosphere
//                500 is the basic size number, don't change!
//                animationAmount means the bubble can resize dynamically in a small range like a spring
                    .frame(width: CGFloat(500 + soundDB * 8 + animationAmount * 2), height: CGFloat(soundDB * 2000))
                    .position(x: geometry.size.width / 2, y: geometry.size.height)
                    .onReceive(timer) { _ in
                                            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                                animationAmount = -5
                                            }
                                        }
            }
        }
    }
    
//    color module: to decide the color of the bubble
    var circleColor: LinearGradient {
            if soundDB < 3 {
                return LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#195CA2"), Color(hex: "#83CBA6")]),
                    startPoint: .center,
                    endPoint: .top
                )
            } else {
                return LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#de3a75"), Color(hex: "#f7cf58")]),
                    startPoint: .center,
                    endPoint: .top
                )
            }
        }
}



struct atmosBubble_Previews: PreviewProvider {
    static var previews: some View {
        atmosBubble()
    }
}
