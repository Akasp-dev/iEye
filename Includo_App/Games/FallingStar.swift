import SwiftUI

struct FallingStarsView: View {
    @State var indicatorSize: CGFloat = 170
    @State var starArray: [FallingStarsInstance] = []
    @State var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State var isMenuVisible : Bool = true
    @State var starSize : CGFloat = 150
    @State var starVel : CGFloat = 5
    @State var index : Int = 1

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                FallingStarsField(starArray: $starArray, starSize: $starSize, starVel: $starVel, indicIndex: $index)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .blur(radius: isMenuVisible ? 10 : 0)
                    .disabled(isMenuVisible)
                FallingStarsIndicator(size: $indicatorSize, index: $index)
                    .position(x: geometry.size.width / 10, y: geometry.size.width / 12)
                    .blur(radius: isMenuVisible ? 10 : 0)
                    .onReceive(timer) { _ in
                        starArray.append(FallingStarsInstance(starId: Int.random(in: 1...4)))
                    }
                FallingStarMenu(starSize: $starSize, starVel: $starVel, isMenuVisible: $isMenuVisible)
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                Button("Menu"){
                    withAnimation(.linear(duration: 0.1)){
                        isMenuVisible.toggle()
                    }
                }
                .font(.custom("Montserrat", size: 25))
                .padding(8)
                .frame(width: 100, height: 50)
                .background(.blue)
                .cornerRadius(10)
                .position(x: geometry.size.width / 10, y: geometry.size.width / 5)
                .blur(radius: isMenuVisible ? 10 : 0)
            }
        }
        .background(.black)
    }
}

struct FallingStarsField: View {
    @Binding var starArray: [FallingStarsInstance]
    @Binding var starSize : CGFloat
    @Binding var starVel : CGFloat
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @Binding var indicIndex : Int

    var body: some View {
        ZStack {
            Image("shapes_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ForEach(starArray.indices, id: \.self) { i in
                Image("star_\(starArray[i].starId)")
                    .resizable()
                    .frame(width: starSize, height: starSize)
                    .position(x: starArray[i].x, y: starArray[i].y)
                    .onTapGesture {
                        if starArray[i].starId == indicIndex {
                            starArray.remove(at: i)
                        }
                    }
            }
        }
        .onReceive(timer) { _ in
            moveStars()
        }
    }

    func moveStars() {
        for i in starArray.indices {
            withAnimation{
                starArray[i].y += starVel
            }
        }
        starArray.removeAll { $0.y > UIScreen.main.bounds.height + 200}
    }
}

struct FallingStarsIndicator: View {
    @Binding var size: CGFloat
    @State var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @Binding var index: Int

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .border(.white, width: 3)
                    .onReceive(timer) { _ in
                        chooseNewStar()
                    }

                Image("star_\(index)")
                    .resizable()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .frame(width: size, height: size)
    }

    func chooseNewStar(){
        let newTarget = Int.random(in: 1...4)
        if newTarget != index {
            index = newTarget
        }else{
            chooseNewStar()
        }
    }
}

struct FallingStarMenu : View {
    @Binding var starSize : CGFloat
    @Binding var starVel : CGFloat
    @Binding var isMenuVisible : Bool
    var body: some View {
        ZStack{
            GeometryReader{ geometry in
                RoundedRectangle(cornerRadius: 15)
                    .fill(RGBConvert.convertToColor(236, 240, 241))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                Text("Falling Stars")
                    .font(.custom("Montserrat", size: 40))
                    .position(x: geometry.size.width/2, y: geometry.size.height/6)
                VStack(spacing: 15){
                    Text("Rozmiar gwiazd")
                        .font(.custom("Montserrat", size: 25))
                    IncreaseDecrease(size: 1, value: $starSize, changeBy: 10, maxValue: 200, minValue: 50)
                    Text("Prędkość spadania")
                        .font(.custom("Montserrat", size: 25))
                    IncreaseDecrease(size: 1, value: $starVel, changeBy: 1, maxValue: 10, minValue: 2)
                }
                .position(x: geometry.size.width/2, y: geometry.size.height/2)
                Button("Zaczynamy"){
                    withAnimation(.linear(duration: 0.1)){
                        isMenuVisible = false
                    }
                }
                .font(.custom("Montserrat", size: 30))
                .padding(10)
                .background(.blue)
                .foregroundStyle(.white)
                .cornerRadius(10)
                .position(x: geometry.size.width/2, y: geometry.size.height - geometry.size.height/6)
                
            }
        }
        .frame(width: UIScreen.main.bounds.width/2.5, height: UIScreen.main.bounds.width/2.5)
        .opacity(isMenuVisible ? 1 : 0)
    }
}

struct FallingStarsInstance: Identifiable {
    let id = UUID()
    let starId: Int
    var y: CGFloat = -50
    let x: CGFloat = CGFloat.random(in: 0...UIScreen.main.bounds.width)
}

#Preview {
    FallingStarsView()
}
