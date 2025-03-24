import SwiftUI
import Foundation

struct LookView : View {
    @State var circleX : CGFloat = 200
    @State var circleY : CGFloat = 200
    var body : some View {
        ZStack{
            Image("basket_bg")
                .resizable()
                .ignoresSafeArea()
            Rectangle()
                .fill(.black)
                .ignoresSafeArea()
                .opacity(0.95)
                .overlay(
                    Circle()
                        .frame(width: 380)
                        .position(x: circleX, y: circleY)
                        .blur(radius: 10)
                        .blendMode(.destinationOut)
                )
                .compositingGroup()
            
        }.onContinuousHover{hover in
            switch hover {
            case .active(let point):
                circleX = point.x
                circleY = point.y
            case .ended:
                print("Ou")
            }
        }
    }
}

#Preview {
    LookView()
}
