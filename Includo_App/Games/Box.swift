import SwiftUI
import Combine
import Foundation

class BallInstance : ObservableObject {
    let id = UUID()
    @Published var size : CGFloat
    @Published var posX : CGFloat
    @Published var posY : CGFloat
    @Published var color : Color
    @Published var isGrabbed : Bool = false
    
    init(posX: CGFloat, posY: CGFloat, size: CGFloat, color: Color, isGrabbed : Bool) {
        self.size = size
        self.posX = posX
        self.posY = posY
        self.color = color
        self.isGrabbed = isGrabbed
    }
}

struct BoxView : View {
    @State var balls : [BallInstance] = []
    @State var cursorLocation : CGPoint = .zero
    @State var colorToClick : Color = .white
    @State var isOver : Bool = false
    let basket_size : CGFloat = 500
    var body : some View {
        ZStack{
            GeometryReader{ geometry in
                Image("basket_bg")
                    .resizable()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                ForEach(balls.indices, id: \.self){ index in
                    let ball = balls[index]
                    BallView(ballInstance: ball, cursorLocation: $cursorLocation)
                        .onTapGesture{
                            let originalX = ball.posX
                            let originalY = ball.posY
                            if ball.isGrabbed {
                                ball.posX = cursorLocation.x
                                ball.posY = cursorLocation.y
                                ball.isGrabbed.toggle()
                                
                                let basketX = geometry.size.width / 2
                                let basketY = geometry.size.height - basket_size / 4
                                
                                if isBallInBasket(ball, basketX: basketX, basketY: basketY, basketSize: basket_size) {
                                    if ball.color == colorToClick {
                                        balls.remove(at: index)
                                        if balls.isEmpty {
                                            
                                        }
                                        colorToClick = !balls.isEmpty ? balls[Int.random(in: 0...balls.count-1)].color : .black
                                    }
                                    else{
                                        ball.posX = originalX
                                        ball.posY = originalY
                                    }
                                }
                            } else {
                                balls.forEach { $0.isGrabbed = false }
                                ball.isGrabbed = true
                            }
                        }
                }
                Image("ball_basket")
                    .resizable()
                    .frame(width: basket_size, height: basket_size)
                    .position(x: geometry.size.width/2, y: geometry.size.height - basket_size/4)
                    .allowsHitTesting(false)
                Text("Tada!")
                    .font(.custom("Montserrat", size: 50))
                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
                    .foregroundStyle(.white)
                    .opacity(isOver ? 1 : 0)
                ColorIndicatorView(color: colorToClick)
                    .position(x: 110,y: geometry.size.height - 110)
                    .allowsHitTesting(false)
            }
        }
        .navigationBarHidden(true)
        .onContinuousHover{phase in
            switch phase {
            case .active(let location):
                cursorLocation = location
                print("x: \(cursorLocation.x) y: \(cursorLocation.y)")
            case .ended:
                break
            }
        }
        .coordinateSpace(name: "screen")
        .frame(width: Sizes.width, height: Sizes.height)
        .background(.black)
        .onAppear{
            let colors = ["#3498db", "#2ecc71", "#9b59b6", "#f1c40f", "#e67e22", "#e74c3c", "#9c88ff", "#48dbfb"]
            var shuffledColors = colors.shuffled()
            var colorIndex = 0

            for _ in 0...6 {
                if colorIndex >= shuffledColors.count {
                    shuffledColors = colors.shuffled()
                    colorIndex = 0
                }
                
                balls.append(
                    BallInstance(
                        posX: CGFloat.random(in: 50...Sizes.width - 100),
                        posY: CGFloat.random(in: 50...Sizes.height - 250),
                        size: CGFloat.random(in: 50...100),
                        color: HexConvert.convertToColor(shuffledColors[colorIndex]),
                        isGrabbed: false
                    )
                )
                
                colorIndex += 1
            }

            let randomBallIndex = Int.random(in: 0..<balls.count)
            colorToClick = balls[randomBallIndex].color
        }
    }
        
    func isBallInBasket(_ ball: BallInstance, basketX: CGFloat, basketY: CGFloat, basketSize: CGFloat) -> Bool {
        let basketLeft = basketX - basketSize / 2
        let basketRight = basketX + basketSize / 2
        let basketTop = basketY - basketSize / 2
        let basketBottom = basketY + basketSize / 2

        let ballRadius = ball.size / 2

        let isInsideX = ball.posX + ballRadius > basketLeft && ball.posX - ballRadius < basketRight
        let isInsideY = ball.posY + ballRadius > basketTop && ball.posY - ballRadius < basketBottom

        return isInsideX && isInsideY
    }
}

struct BallView : View {
    @ObservedObject var ballInstance : BallInstance
    @Binding var cursorLocation : CGPoint
    var body : some View {
        Circle()
            .fill(ballInstance.color)
            .shadow(radius: 5)
            .frame(width: ballInstance.size)
            .position(x: ballInstance.isGrabbed ? cursorLocation.x : ballInstance.posX,
                      y: ballInstance.isGrabbed ? cursorLocation.y : ballInstance.posY)
    }
}
struct ColorIndicatorView : View {
    var color : Color
    var body : some View {
        Rectangle()
            .fill(color)
            .frame(width: 150, height: 150)
            .cornerRadius(15)
    }
}

#Preview {
    BoxView()
}
