import SwiftUI
import Foundation

struct Size {
    static let width: CGFloat = UIScreen.main.bounds.width
    static let height: CGFloat = UIScreen.main.bounds.height
}
struct PathFollowingEffect: GeometryEffect {
    var progress: CGFloat
    let path: Path
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let trimmedPath = path.trimmedPath(from: 0, to: progress)
        let point = trimmedPath.currentPoint ?? .zero
        xPos = Int(point.x)
        yPos = Int(point.y)
        return ProjectionTransform(CGAffineTransform(translationX: point.x, y: point.y))
    }
}

var xPos : Int = 0
var yPos : Int = 0

struct RunView : View {
    @State var progress: CGFloat = 0.01
    var body: some View {
        ZStack{
            GeometryReader{ geometry in
                let path = createPath(geometry.size)
                path.stroke(.red)
                Image("fence")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .position(x: geometry.size.width - 680, y: geometry.size.height - 200)
                Image("fence")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .position(x: geometry.size.width - 1580, y: geometry.size.height - 200)
                Image("fence")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .position(x: geometry.size.width - 2380, y: geometry.size.height - 200)
                Image("fence")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .position(x: geometry.size.width - 3080, y: geometry.size.height - 200)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(yPos < 700 ? Color.red : Color.white)
                    .frame(width: 50, height: 50)
                    .offset(x: -25, y: -25)
                    .modifier(PathFollowingEffect(progress: progress, path: path))
                    .onTapGesture {
                        if progress < 1{
                            withAnimation(.linear(duration: 0.5)){
                                progress += 0.005
                            }
                        }
                        
                    }
            }
            .offset(x: (-Size.width + progress * 3000 - 100))
        }
        .background(.black)
        .frame(width: Size.width*3, height: Size.height)
    }
    
    private func createPath(_ size: CGSize) -> Path {
        return Path{path in
            path.move(to: CGPoint(x: size.width, y: 700))
            path.addLine(to: CGPoint(x: size.width - 500, y: 700))
            path.addArc(center: CGPoint(x: size.width - 680, y: 700),
                            radius: 180,
                            startAngle: .degrees(0),
                            endAngle: .degrees(180),
                        clockwise: true)
            path.addLine(to: CGPoint(x: size.width - 1360, y: 700))
            path.addArc(center: CGPoint(x: size.width - 1580, y: 700),
                            radius: 180,
                            startAngle: .degrees(0),
                            endAngle: .degrees(180),
                        clockwise: true)
            path.addLine(to: CGPoint(x: size.width - 2060, y: 700))
            path.addArc(center: CGPoint(x: size.width - 2380, y: 700),
                            radius: 180,
                            startAngle: .degrees(0),
                            endAngle: .degrees(180),
                        clockwise: true)
            path.addLine(to: CGPoint(x: size.width - 2560, y: 700))
            path.addArc(center: CGPoint(x: size.width - 3080, y: 700),
                            radius: 180,
                            startAngle: .degrees(0),
                            endAngle: .degrees(180),
                        clockwise: true)
            path.addLine(to: CGPoint(x: size.width - 3660, y: 700))
        }
    }
}


#Preview {
    RunView()
}
