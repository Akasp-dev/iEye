import Foundation
import SwiftUI

struct Sizes {
    static let width: CGFloat = UIScreen.main.bounds.width
    static let height: CGFloat = UIScreen.main.bounds.height
}
struct SwipeView : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var pos : CGPoint = CGPoint(x: 100,y: 100)
    @State var isOpen : Bool = false
    @State var selectedMode : Int = 0
    var body: some View {
        ZStack{
            Image("wooden_table")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: isOpen ? 10 : 2)
            SwipeField(setDirection: $selectedMode)
                .disabled(isOpen)
                .blur(radius: isOpen ? 10 : 0)
            SwipeController(pos: $pos, isOpen: $isOpen, selectedMode: $selectedMode)
            Button("Powrót"){
                self.presentationMode.wrappedValue.dismiss()
            }
            .font(.custom("Montserrat", size: 25))
            .frame(width: 100, height: 30)
            .padding(20)
            .background(HexConvert.convertToColor("#3498db"))
            .cornerRadius(15)
            .position(
                x: 100,
                y: Sizes.height - 100
            )
            
        }
        .navigationBarHidden(true)
        .background(.black)
    }
}

struct SwipeField : View {
    
    @Binding var setDirection : Int
    
    struct Card : Identifiable {
        let id = UUID()
        var x : CGFloat
        var y : CGFloat
        let color : Color
        let direction : Int
        var opacity : Double
    }

    @State var cards : [Card] = [
        Card(x: Sizes.width/2, y: Sizes.height/2, color: .blue, direction: 0, opacity: 1)
    ]
    
    var body : some View {
        ZStack{
            GeometryReader{ screen in
                ForEach(cards.indices, id: \.self){index in
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(cards[index].color)
                            .frame(width: screen.size.width/4, height: screen.size.height/2)
                            .position(x: cards[index].x, y: cards[index].y)
                            .overlay(content: {
                                    RoundedRectangle(cornerRadius: 15)
                                    .stroke(.white, lineWidth: 8)
                                    .frame(width: screen.size.width/4, height: screen.size.height/2)
                                    .opacity(cards[index].opacity)
                                }
                            )
                        Image("swipe_arrow_white")
                            .resizable()
                            .frame(width: screen.size.width/6, height: screen.size.width/6)
                            .rotationEffect(.degrees(Double(90 * cards[index].direction)))
                            .position(x: cards[index].x, y: cards[index].y)
                    }
                    .opacity(cards[index].opacity)
                    .onTapGesture {
                            if setDirection == cards[index].direction {
                                var newDistanceX : CGFloat = 0
                                var newDistanceY : CGFloat = 0
                                switch setDirection {
                                case 0:
                                    newDistanceX = 1000
                                case 1:
                                    newDistanceY = 1000
                                case 2:
                                    newDistanceX = -1000
                                case 3:
                                    newDistanceY = -1000
                                default:
                                    break
                                }
                                withAnimation(.linear(duration: 0.3)){
                                    addCard()
                                    cards[index].x += newDistanceX
                                    cards[index].y += newDistanceY
                                    //cards[index].opacity = 0
                                    
                                }
                                
                            }
                    }
                }
            }
        }
    }
    func addCard(){
        let randomDir = Int.random(in: 0...3)
        let r = Int.random(in: 1...255)
        let g = Int.random(in: 1...255)
        let b = Int.random(in: 1...255)
        cards.append(
            Card(x: Sizes.width/2, y: Sizes.height/2, color: RGBConvert.convertToColor(r, g, b), direction: randomDir, opacity: 1)
        )
    }
}

struct SwipeController : View {
    @Binding var pos : CGPoint
    @Binding var isOpen : Bool
    @Binding var selectedMode : Int
    let openPos : CGPoint = CGPoint(x: Sizes.width/2, y: Sizes.height/2)
    @State var angle = -90
    var body : some View {
        ZStack{
            GeometryReader{ screen in
                ZStack{
                    Circle()
                        .fill(.white)
                        .frame(width: isOpen ? 220 : 80)
                    Image("four_arrows")
                        .resizable()
                        .frame(width: isOpen ? 130 : 50, height: isOpen ? 130 : 50)
                }
                .position(isOpen ? openPos : pos)
                .onTapGesture {
                    withAnimation{
                        isOpen.toggle()
                        if isOpen{
                            angle = 0
                        }else{
                            angle = -90
                        }
                    }
                }
                ForEach(0..<4, id: \.self){index in
                    let currentAngle = angle + index * (360 / 4)
                    let radians = CGFloat(currentAngle) * .pi / 180
                    
                    let x = 300 * cos(radians)
                    let y = 300 * sin(radians)
                    
                    ZStack{
                        Circle()
                            .fill(index == selectedMode ? .green : .white)
                            .frame(width: isOpen ? 150 : 80)
                            .position(
                                x: isOpen ? Sizes.width/2 + x : Sizes.width/2 + x * 0.5,
                                y: isOpen ? Sizes.height/2 + y : Sizes.height/2 + y * 0.5
                            )
                            .opacity(isOpen ? 1 : 0)
                            
                        Image(index == selectedMode ? "swipe_arrow_white" : "swipe_arrow_black")
                            .resizable()
                            .frame(
                                width: isOpen ? 80 : 40,
                                height: isOpen ? 90 : 45
                            )
                            .rotationEffect(.degrees(Double(90*index)))
                            .position(
                                x: isOpen ? Sizes.width/2 + x : Sizes.width/2 + x * 0.5,
                                y: isOpen ? Sizes.height/2 + y : Sizes.height/2 + y * 0.5
                            )
                            .opacity(isOpen ? 1 : 0)
                        }
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.1)){
                            selectedMode = index
                        }
                    }
                }
                .rotationEffect(.degrees(Double(angle)))
                .position(isOpen ? openPos : pos)
                
            }
        }
        .frame(width: Sizes.width, height: Sizes.height)
    }
}
#Preview{
    SwipeView()
}
