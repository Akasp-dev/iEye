import SwiftUI

class FallingShapeGenerator: ObservableObject, Identifiable {
    let id = UUID()
    @Published var shapeId: Int
    @Published var xPos: Int
    @Published var yPos: Int
    @Published var selectedShape: Int
    @Published var color: Color
    @Published var size: Int

    init(xPos: Int, yPos: Int, selectedShape: Int, color: Color, size: Int, shapeId: Int) {
        self.xPos = xPos
        self.yPos = yPos
        self.selectedShape = selectedShape
        self.color = color
        self.size = size
        self.shapeId = shapeId
    }

    func fall() {
        let velocity = Int(UserDefaults.standard.double(forKey: "shapesVelocity"))
       yPos += max(1, velocity)
    }
}

struct ShapeDisplay: View {
    @ObservedObject var generatedShape: FallingShapeGenerator

    var body: some View {
        switch generatedShape.selectedShape {
        case 0:
            Image("star_1")
                .resizable()
                .frame(width: CGFloat(generatedShape.size), height: CGFloat(generatedShape.size))
                .position(x: CGFloat(generatedShape.xPos), y: CGFloat(generatedShape.yPos))
        case 1:
            Image("star_2")
                .resizable()
                .frame(width: CGFloat(generatedShape.size), height: CGFloat(generatedShape.size))
                .position(x: CGFloat(generatedShape.xPos), y: CGFloat(generatedShape.yPos))
        case 2:
            Image("star_3")
                .resizable()
                .frame(width: CGFloat(generatedShape.size), height: CGFloat(generatedShape.size))
                .position(x: CGFloat(generatedShape.xPos), y: CGFloat(generatedShape.yPos))
        case 3:
            Image("star_4")
                .resizable()
                .frame(width: CGFloat(generatedShape.size), height: CGFloat(generatedShape.size))
                .position(x: CGFloat(generatedShape.xPos), y: CGFloat(generatedShape.yPos))
        default:
            Text("Error//")
                .font(.system(size: 180))
        }
    }
}

struct TargetShapeIndicator: View {
    let size = CGFloat(140)
    @Binding var targetShapeInt: Int
    let posX: CGFloat
    let posY: CGFloat

    var body: some View {
        ZStack {
            Rectangle()
                .stroke(.white, lineWidth: 2)
                .frame(width: size, height: size)
                .position(x: posX, y: posY)

            ShapeDisplay(
                generatedShape: FallingShapeGenerator(
                    xPos: Int(posX),
                    yPos: Int(posY),
                    selectedShape: targetShapeInt,
                    color: .green,
                    size: 120,
                    shapeId: 0)
            )
        }
    }
}

struct FallingShapes: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var shapeArray: [FallingShapeGenerator] = []
    @State private var targetShapeInt = 0
    @State private var fallingTimer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    @State private var spawnTimer : Timer?
    @State private var timer: Timer?
    @State private var shapeIDs = 0

    var body: some View {
        ZStack {
            Image("shapes_bg")
                .resizable()
                .ignoresSafeArea()
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
            .position(CGPoint(x: 100.0, y: 220.0))
            TargetShapeIndicator(targetShapeInt: $targetShapeInt, posX: 100, posY: 100)
            ForEach(shapeArray){shape in
                ShapeDisplay(generatedShape: shape)
                    .onTapGesture {
                        let targetToRemove = shapeArray.firstIndex(where: {$0.shapeId == shape.shapeId})
                        if shape.selectedShape == targetShapeInt{
                            shapeArray.remove(at: targetToRemove!)
                        }
                    }
                    .onReceive(fallingTimer){_ in
                        if shape.yPos > Int(UIScreen.main.bounds.height) + shape.size{
                            let targetToRemove = shapeArray.firstIndex(where: {$0.shapeId == shape.shapeId})
                            shapeArray.remove(at: targetToRemove!)
                        }else{
                            withAnimation(.linear(duration: 0.3)){
                                shape.fall()
                            }
                        }
                    }
            }
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { _ in
                regenerateTargetShape()
            }
            spawnTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { _ in
                appendNewShape()
            }
            
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
            
            spawnTimer?.invalidate()
            spawnTimer = nil
        }
        .navigationBarHidden(true)
    }
    func regenerateTargetShape() {
        let newTarget = Int.random(in: 0...2)
        if newTarget != targetShapeInt {
            targetShapeInt = newTarget
        }else{
            regenerateTargetShape()
        }
    }

    func appendNewShape() {
        let size = UserDefaults.standard.double(forKey: "shapesSize")
        let xPos = Int.random(in: Int(0 + size / 2)...Int(UIScreen.main.bounds.width - (size / 2)))
        shapeArray.append(
            FallingShapeGenerator(
                xPos: xPos,
                yPos: Int(-size),
                selectedShape: targetShapeInt,
                color: .white,
                size: Int(size),
                shapeId: shapeIDs
            )
        )
        shapeIDs += 1
    }
}
#Preview {
    FallingShapes()
}
