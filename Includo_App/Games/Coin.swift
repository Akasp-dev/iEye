import Foundation
import SwiftUI

struct Screen {
    static let windowWidth : CGFloat = UIScreen.main.bounds.width
    static let windowHeight : CGFloat = UIScreen.main.bounds.height
}

class Coin : ObservableObject{
    @Published var xPos : CGFloat
    @Published var yPos : CGFloat
    init(_ xPos : CGFloat, _ yPos : CGFloat) {
        self.xPos = xPos
        self.yPos = yPos
    }
    func changePosition(){
        let offset : CGFloat = 100
        let quarters = [
            (offset...Screen.windowWidth/2-50, offset...Screen.windowHeight/2-50),
            (Screen.windowWidth/2+50...Screen.windowWidth-offset, offset...Screen.windowHeight/2-50),
            (Screen.windowWidth/2+50...Screen.windowWidth-offset, Screen.windowHeight/2+50...Screen.windowHeight-offset),
            (offset...Screen.windowWidth/2-50, Screen.windowHeight/2+50...Screen.windowHeight-offset)
        ]
        for (index, x) in quarters.enumerated(){
            if checkIfFitsQuarter(xPos, yPos, x){
                var newPos: Int
                repeat {
                    newPos = Int.random(in: 0..<quarters.count)
                } while index == newPos
                
                xPos = CGFloat.random(in: quarters[newPos].0)
                yPos = CGFloat.random(in: quarters[newPos].1)
                break
            }
        }
    }
    func checkIfFitsQuarter(_ xPos : CGFloat, _ yPos : CGFloat, _ quarter : (ClosedRange<CGFloat>, ClosedRange<CGFloat>)) -> Bool{
        return quarter.0.contains(xPos) && quarter.1.contains(yPos)
    }
}

struct CoinChaseView : View {
    @State var isMenuVisible : Bool = true
    @State var percent : CGFloat = 1
    @State var timeSet : CGFloat = 10
    @State var timeLeft : CGFloat = 0
    @State var coinSize : CGFloat = 1
    @State var timer : Timer?
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.black)
                .frame(width: Screen.windowWidth, height: Screen.windowHeight)
            CoinChaseField(isMenuVisible: $isMenuVisible)
            TimerBar(percent: $timeLeft, maxTime: $timeSet, isMenuVisible: $isMenuVisible)
            CoinView(isMenuVisible: $isMenuVisible, timeLeft: $timeLeft, timeSet: $timeSet, coinSize: $coinSize)
            MenuView(isMenuVisible: $isMenuVisible, timer: $timer, timeLeft: $timeLeft, timeSet: $timeSet, coinSize: $coinSize)
        }
    }
}

struct CoinChaseField : View {
    @Binding var isMenuVisible : Bool
    var body: some View {
        ZStack{
            Image("Chest")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: isMenuVisible ? 10 : 0)
                .animation(.bouncy(duration: 0.2), value: isMenuVisible)
            }
    }
}

struct CoinView : View {
    @ObservedObject var coinInstance : Coin = Coin(Screen.windowWidth/3, Screen.windowHeight/3)
    @Binding var isMenuVisible : Bool
    @Binding var timeLeft : CGFloat
    @Binding var timeSet : CGFloat
    @Binding var coinSize : CGFloat
    var body: some View {
        Image("Coin")
            .resizable()
            .frame(width: (Screen.windowWidth/5.5) * coinSize, height: (Screen.windowWidth/5.5) * coinSize)
            .onHover{ hover in
                if hover{
                    withAnimation(.spring(duration: 0.2)){
                        coinInstance.changePosition()
                    }
                }
            }
        //Debugging stuff
            .onTapGesture {
                withAnimation(.spring(duration: 0.2)){
                    coinInstance.changePosition()
                    timeSet -= 0.2
                }
                withAnimation(.linear(duration: 0.1)){
                    timeLeft = timeSet
                }
            }
        //---------------
            .position(x: coinInstance.xPos, y: coinInstance.yPos)
            .blur(radius: isMenuVisible ? 10 : 0)
            .disabled(isMenuVisible)
    }
}
struct MenuView : View {
    @Binding var isMenuVisible : Bool
    @Binding var timer : Timer?
    @Binding var timeLeft : CGFloat
    @Binding var timeSet : CGFloat
    @Binding var coinSize : CGFloat
    var body: some View{
        let initialTime = timeSet
        ZStack{
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 10)
                    .fill(RGBConvert.convertToColor(236, 240, 241))
                Text("Coin Chase")
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 50))
                    .position(x: geometry.size.width/2, y: geometry.size.height/6)
                VStack(spacing: 10){
                    Text("Czas na najechanie")
                        .foregroundStyle(.black)
                        .font(.custom("Montserrat", size: 25))
                    IncreaseDecrease(size: 1, value: $timeSet, changeBy: 1, maxValue: 30, minValue: 1)
                    Text("Rozmiar monety")
                        .foregroundStyle(.black)
                        .font(.custom("Montserrat", size: 25))
                    IncreaseDecrease(size: 1, value: $coinSize, changeBy: 0.1, maxValue: 1, minValue: 0.6)
                }
                .position(x: geometry.size.width/2, y: geometry.size.height/2)
                Button("Zaczynamy"){
                    isMenuVisible = false
                    timeLeft = timeSet
                    timer?.invalidate()
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        if timeLeft > 0{
                            withAnimation(.linear(duration: 1)){
                                timeLeft -= 1
                            }
                        }else{
                            timer?.invalidate()
                            isMenuVisible = true
                            timeSet = initialTime
                        }
                    }
                }
                
                .padding(15)
                .foregroundStyle(.white)
                .font(.custom("Montserrat", size: 30))
                .background(.blue)
                .cornerRadius(10)
                .position(x: geometry.size.width/2, y: geometry.size.height - geometry.size.height/6)
                
            }
        }
        .frame(width: Screen.windowWidth/2.5, height: Screen.windowWidth/2.5)
        .opacity(isMenuVisible ? 1 : 0)
    }
}
struct TimerBar : View {
    @Binding var percent : CGFloat
    @Binding var maxTime : CGFloat
    @Binding var isMenuVisible : Bool
    var body: some View{
        RoundedRectangle(cornerRadius: 5)
            .fill(RGBConvert.convertToColor(46, 204, 113))
            .frame(width: Screen.windowWidth * (percent/maxTime), height: 30)
            .position(x: Screen.windowWidth/2, y: 15)
            .blur(radius: isMenuVisible ? 10 : 0)
            .animation(.easeInOut(duration: 0.1), value: isMenuVisible)
    }
}
struct IncreaseDecrease : View {
    @State var size : CGFloat
    @Binding var value : CGFloat
    @State var changeBy : Double
    let maxValue : Double
    let minValue : Double
    var body: some View {
        HStack{
            Text("+")
                .frame(width: 50, height: 50)
                .background(.white)
                .cornerRadius(10)
                .foregroundStyle(.black)
                .font(.system(size: 30))
                .onTapGesture {
                    if value < maxValue {
                        value += changeBy
                    }
                }
            Text("\(String(format: "%.1f", value))")
                .frame(width: 100, height: 50)
                .foregroundStyle(.black)
                .font(.system(size: 30))
            Text("-")
                .frame(width: 50, height: 50)
                .background(.white)
                .cornerRadius(10)
                .foregroundStyle(.black)
                .font(.system(size: 30))
                .onTapGesture {
                    if value > minValue {
                        value -= changeBy
                    }
                }
        }
        .scaleEffect(size)
    }
}
#Preview{
    CoinChaseView()
}

