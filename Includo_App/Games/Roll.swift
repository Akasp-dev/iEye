import Foundation
import SwiftUI

struct RollView : View {
    @State var indPosition : CGFloat = 143
    var body : some View {
        ZStack{
            RollStripeView(indPosition: $indPosition)
            IndicatorView(indPosition: $indPosition)
        }
        .frame(width: Size.width, height: Size.height)
        .background(.black)
    }
}

struct RollStripeView : View {
    @Binding var indPosition : CGFloat
    var body : some View {
        ZStack{
            GeometryReader{ geometry in
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                HexConvert.convertToColor("#3498db"),
                                HexConvert.convertToColor("#3867d6"),
                                HexConvert.convertToColor("#3498db")
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: Size.width*2, height: geometry.size.height/4)
                    .position(x: Size.width/2, y: Size.height/2)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { gesture in
                                withAnimation(.linear(duration: 0.5)){
                                    indPosition = gesture.location.x
                                }
                            }
                    )
                }
        }
    }
}
struct IndicatorView : View {
    @Binding var indPosition : CGFloat
    var body : some View {
        Rectangle()
            .fill(.red)
            .frame(width: 10, height: Size.height/4)
            .position(x: indPosition, y: Size.height/2)
    }
}

#Preview {
    RollView()
}
