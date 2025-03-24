import SwiftUI
import AVFoundation

class CircleClass : ObservableObject {
    @Published var xPos : CGFloat
    @Published var yPos : CGFloat
    @Published var isHovered : Bool = false
    @Published var points : Int = 0
    init(_ xPos : CGFloat, _ yPos : CGFloat){
        self.xPos = xPos
        self.yPos = yPos
    }
    func changePosition(){
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        if xPos < screenWidth/2{
            xPos = CGFloat(Int.random(in: Int(screenWidth / 2)...Int(screenWidth - 150)))
        }else{
            xPos = CGFloat(Int.random(in: 150...Int(screenWidth/2)))
        }
        yPos = CGFloat(Int.random(in: 150...Int(screenHeight-150)))
    }
}

struct CoinChase: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var circle: CircleClass = CircleClass(300, 300)
    @State var timer: Timer?
    @State var timeLeft: Double = 0
    @State var timeAtStart: Double = UserDefaults.standard.double(forKey: "coinChaseTimeLeft")
    @State var timeDecrease: Double = UserDefaults.standard.double(forKey: "coinChaseTimeDecrease")
    @State var audioPlayer: AVAudioPlayer?

    var body: some View {
        let percentage: Double = timeLeft / timeAtStart
        ZStack {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Back")
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
            }
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .position(CGPoint(x: 80.0, y: 50.0))
            
            Rectangle()
                .fill(.white)
                .frame(
                    width: UIScreen.main.bounds.width * CGFloat(percentage),
                    height: 20
                )
                .animation(.linear(duration: 0.1), value: percentage)
                .position(
                    x: UIScreen.main.bounds.width / 2,
                    y: -10
                )
            
            Image("Coin")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 170)
                .onHover { hovered in
                    if hovered {
                        circle.changePosition()
                        circle.points += 1
                        timeAtStart -= timeDecrease
                        timeLeft = timeAtStart
                        PlayAudio("coin_slide").play()
                    }
                }
                .position(CGPoint(x: circle.xPos, y: circle.yPos))
                .animation(.easeInOut(duration: 0.1))
            
            Text("\(circle.points)")
                .font(.system(size: 50))
                .foregroundStyle(.white)
        }
        .onAppear {
            resetValues()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .background(
            Image("Chest")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .scaledToFill()
        )
        .navigationBarHidden(true)
    }
    private func resetValues() {
        timeAtStart = UserDefaults.standard.double(forKey: "coinChaseTimeLeft")
        timeLeft = timeAtStart
    }
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                timeAtStart = UserDefaults.standard.double(forKey: "coinChaseTimeLeft")
                timeLeft = timeAtStart
                circle.points = 0
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    CoinChase()
}
