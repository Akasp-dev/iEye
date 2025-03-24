import SwiftUI

class CoinGen : ObservableObject{
    @Published var posX : Int
    @Published var posY : Int
    init(_ posX : Int, _ posY : Int){
        self.posX = posX
        self.posY = posY
    }
    public func generateRandomPosition(){
        self.posX = Int.random(in: 100...Int(UIScreen.main.bounds.width - 100))
        self.posY = Int.random(in: 100...Int(UIScreen.main.bounds.height - 100))
        print("Test")
    }
}

struct Coin : View{
    
    @ObservedObject var coin : CoinGen
    
    var body: some View{
        Text("$")
            .font(.system(size: 30))
            .frame(width: 100, height: 100)
            .background(.green)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .position(CGPoint(x: coin.posX, y: coin.posY))
    }
}

struct CoinChase : View {
    @State var coin : CoinGen = CoinGen(
        Int(UIScreen.main.bounds.width/2),
        Int(UIScreen.main.bounds.height/2)
    )
    @State var timeOnStart : Float = 10
    @State var timeLeft : Float = 10
    @State var points : Int = 0
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        @State var initialWidth = UIScreen.main.bounds.width
        ZStack{
            Text("\(points)")
                .foregroundStyle(.white)
                .font(.system(size: 80))
            Rectangle()
                .frame(width: initialWidth * CGFloat((timeLeft/timeOnStart)), height: 30)
                .animation(.linear(duration: 0.1))
                .position(x: UIScreen.main.bounds.width/2, y: -20)
                .foregroundColor(.red)
            Coin(coin: coin)
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.1)){
                        coin.generateRandomPosition()
                    }
                    timeOnStart -= 0.5
                    timeLeft = timeOnStart
                    points += 1
                }
            Text("\(timeLeft/timeOnStart)")
                .position(CGPoint(x: 50.0, y: 10.0))
        }
        .onReceive(timer, perform: { _ in
            if timeLeft <= 0{
                timeOnStart = 10
                timeLeft = timeOnStart + 1
                points = 0
            }
            timeLeft -= 1
        })
    }
}
#Preview{
    CoinChase()
}
