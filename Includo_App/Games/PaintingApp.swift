import SwiftUI

class GeneratedCircle : ObservableObject, Identifiable{
    let id = UUID()
    @Published var pos : CGPoint
    @Published var bg : Color
    @Published var sign : String
    init(pos: CGPoint, bg: Color, sign: String){
        self.pos = pos
        self.bg = bg
        self.sign = sign
    }
    func generateNewPosition(){
        self.pos = CGPoint(
            x: Int.random(in: 50...Int(UIScreen.main.bounds.width - 50)),
            y: Int.random(in: 50...Int(UIScreen.main.bounds.height - 50))
        )
    }
}

struct CircleView : View{
    @ObservedObject var circle : GeneratedCircle
    var body : some View{
        Text(circle.sign)
            .frame(width: 100, height: 100)
            .font(.system(size: 40))
            .background(circle.bg)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .position(circle.pos)
    }
}

struct PaintingApp: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var circles : [GeneratedCircle] = []
    @State var colors : [Color] = [.red, .green, .blue, .yellow, .orange, .purple, .white, .black]
    @State var circleCount : Int = 0
    @State var location: CGPoint = .zero
    @State var selectedColor : Color = .black
    @State var hoverLocation : CGPoint = .zero
    var body: some View {
        ZStack{
            ForEach(circles){circle in
                CircleView(circle: circle)
            }
            Button(){
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
            Button(){
                circles = []
            } label: {
                Text("Clear")
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
            }
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .position(CGPoint(x: 80.0, y: 120.0))
                    
            HStack(alignment: .center){
                ForEach(colors, id: \.self){ color in
                    Button(){
                        selectedColor = color
                    } label: {
                        Rectangle()
                            .fill(color)
                            .frame(width: 120, height: 60)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 3)
                            )
                    }
                }
            }
            .frame(width: CGFloat(UIScreen.main.bounds.width), height: 50)
            .position(CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height - 90))
                
        }
        .background(.white)
        .contentShape(Rectangle())
        .onContinuousHover{phase in
            switch phase{
            case .active(let location):
                hoverLocation = location
                circles.append(GeneratedCircle(
                    pos: CGPoint(x: hoverLocation.x, y: hoverLocation.y),
                    bg: selectedColor,
                    sign: ""
                ))
                print("Hovered")
            case .ended:
                print("Cursor missing")
            }
        }
        .coordinateSpace(name: "screen")
        .navigationBarHidden(true)
    }
    private func onChanged(value: DragGesture.Value){
        location = value.location
        circles.append(GeneratedCircle(
            pos: location,
            bg: selectedColor,
            sign: ""
        ))
    }
}

