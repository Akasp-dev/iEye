import SwiftUI
import Foundation

struct SmallerView : View {
    @State var size : CGFloat = 400
    @State var posX : CGFloat = UIScreen.main.bounds.width / 2
    @State var posY : CGFloat = UIScreen.main.bounds.height / 2
    @State var taps = 0
    @State var allTaps = 0
    var body : some View {
        ZStack{
            GeometryReader{ geometry in
               Image("smaller_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        withAnimation{
                            if size < 400{
                                size = size * 1.2
                                taps = 0
                            }
                        }
                    }
                SmallerBallView(size: size, posX: $posX, posY: $posY)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.2)){
                            changePosition()
                            if taps < 5{
                                taps += 1
                            }
                            else{
                                size = size*0.8
                                taps = 0
                            }
                        }
                        allTaps += 1
                    }
            }
        }
        .frame(width: Sizes.width, height: Sizes.height)
        .background(.black)
    }
    func changePosition(){
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let safeOffset: CGFloat = size / 2 + 10
        
        var newX: CGFloat
        var newY: CGFloat
        
        repeat {
            newX = CGFloat.random(in: safeOffset...(screenWidth - safeOffset))
            newY = CGFloat.random(in: safeOffset...(screenHeight - safeOffset))
        } while abs(newX - posX) < 50 && abs(newY - posY) < 150
        
        posX = newX
        posY = newY
    }
    func checkIfFitsQuarter(_ xPos : CGFloat, _ yPos : CGFloat, _ quarter : (ClosedRange<CGFloat>, ClosedRange<CGFloat>)) -> Bool{
        return quarter.0.contains(xPos) && quarter.1.contains(yPos)
    }
}

struct SmallerBallView : View {
    let size : CGFloat
    @Binding var posX : CGFloat
    @Binding var posY : CGFloat
    var body: some View{
        Image("black_hole")
            .resizable()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .contentShape(Circle())
            .position(x: posX, y: posY)
    }
}

#Preview {
    SmallerView()
}
