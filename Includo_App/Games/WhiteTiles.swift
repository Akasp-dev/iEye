import Foundation
import SwiftUI

enum Direction{
    case up, down, left, right, none
}

class SwitchableSquare : ObservableObject, Identifiable{
    let id = UUID()
    @Published var xPos : Int
    @Published var yPos : Int
    @Published var isSelected : Bool
    @Published var isHighlighted : Bool
    
    init(_ xPos : Int, _ yPos : Int, _ isSelected : Bool, _ isHighlighted : Bool){
        self.xPos = xPos
        self.yPos = yPos
        self.isSelected = isSelected
        self.isHighlighted = isHighlighted
    }
}
struct DirectionArrow : View{
    @Binding var direction : Direction
    var body : some View{
        switch direction{
        case .up:
            Image("dir_up")
                .resizable()
        case .down:
            Image("dir_down")
                .resizable()
        case .left:
            Image("dir_left")
                .resizable()
        case .right:
            Image("dir_right")
                .resizable()
        case .none:
            Rectangle()
                .fill(.black)
                .frame(width: 20, height: 20)
        }
    }
}
struct Square : View {
    @ObservedObject var square : SwitchableSquare
    let posX = 180
    let posY = 150
    var body: some View{
        RoundedRectangle(cornerRadius: 15)
            .fill(square.isSelected ? Color(red: 0.753, green: 0.224, blue: 0.169) : Color(red: 0.741, green: 0.765, blue: 0.78))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .position(CGPoint(x: 545 - square.xPos*posX, y: 435 - square.yPos*posY))
            .frame(width: 150, height: 120)
        RoundedRectangle(cornerRadius: 15)
            .fill(square.isSelected ? Color(red: 0.906, green: 0.298, blue: 0.235) : Color(red: 0.925, green: 0.941, blue: 0.945))
            .position(CGPoint(x: 540 - square.xPos*posX, y: 430 - square.yPos*posY))
            .frame(width: 150, height: 120)
        
    }
}
struct WhiteTiles : View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var squares : [SwitchableSquare] = []
    @State var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State var points = 0
    @State var flowDirection = Direction.right
    @State var expectedSquare : [SwitchableSquare] = []
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    init(){
        var tempSquares = [SwitchableSquare]()
        for row in (1...4){
            for col in (1...4){
                tempSquares.append(SwitchableSquare(col, row, false, false))
            }
        }
        _squares = State(initialValue: tempSquares)
    }
    var body: some View {
        let relativeSize = min(screenWidth, screenHeight)
        ZStack{
            Rectangle()
                .fill(.black)
                .ignoresSafeArea()
            DirectionArrow(direction: $flowDirection)
                .frame(width: relativeSize * 0.15, height: relativeSize * 0.15)
                .position(
                    x: 140,
                    y: screenHeight/2
                )
            Button(){
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Back")
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .font(.custom("Montserrat", size: min(screenWidth, screenHeight) * 0.031))
            }.background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .position(CGPoint(x: 140, y: 250.0))
            Text("Points: \(points)")
                .position(CGPoint(x: 140.0, y: 160.0))
                .font(.system(size: min(screenWidth, screenHeight) * 0.04))
                .foregroundStyle(.white)
            ForEach(squares, id: \.id){square in
                Square(square: square)
                    .onTapGesture{
                        withAnimation(.linear(duration: 0.05)){
                            if square.xPos == expectedSquare[0].xPos && square.yPos == expectedSquare[0].yPos{
                                expectedSquare.remove(at: 0)
                                square.isSelected = false
                                let selectedCount = squares.filter{item in item.isSelected == true}
                                if selectedCount.count < 1{
                                    selectRandomMode()
                                    points += 1
                                }
                            }
                            else{
                                print("Wrong tile")
                            }
                        }
                        
                    }
            }
        }.navigationBarHidden(true)
            .onAppear{
                selectRandomMode()
            }
    }
    func selectRandomMode(){
        let choice = Int.random(in: 1...3)
        switch choice{
        case 1:
            selectRandomTile()
        case 2:
            selectRandomColumn()
        case 3:
            selectRandomRow()
        default:
            print("Error")
        }
    }
    
    func selectRandomTile(){
        resetSquares()
        expectedSquare.removeAll()
        flowDirection = Direction.none
        let randomX = Int.random(in: 1...4)
        let randomY = Int.random(in: 1...4)
        for square in squares{
            if square.xPos == randomX && square.yPos == randomY {
                square.isSelected = true
                expectedSquare.append(square)
            }
        }
    }
    func selectRandomColumn(){
        resetSquares()
        expectedSquare.removeAll()
        flowDirection = Int.random(in: 1...2) == 1 ? Direction.up : Direction.down
        let randomColumn = Int.random(in: 1...4)
        for square in squares{
            if square.xPos == randomColumn {
                square.isSelected = true
                expectedSquare.append(square)
            }
        }
        expectedSquare.sort {flowDirection == Direction.up ? $0.yPos < $1.yPos : $0.yPos > $1.yPos}
    }
    func selectRandomRow(){
        resetSquares()
        expectedSquare.removeAll()
        flowDirection = Int.random(in: 1...2) == 1 ? Direction.left : Direction.right
        let randomRow = Int.random(in: 1...4)
        for square in squares{
            if square.yPos == randomRow {
                square.isSelected = true
                expectedSquare.append(square)
            }
        }
        expectedSquare.sort {flowDirection == Direction.left ? $0.xPos < $1.xPos : $0.xPos > $1.xPos}
    }
    func resetSquares(){
        for square in squares{
            square.isSelected = false
        }
    }
}

#Preview {
    WhiteTiles()
}
