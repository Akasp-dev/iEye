import Foundation
import SwiftUI
struct Field : View {
    
    struct GridTile : Identifiable {
        let id = UUID()
        var x : CGFloat
        var y : CGFloat
    }
    
    @Binding var direction : Int
    @State var x = Sizes.width/2
    @State var y = Sizes.height/2
    @State var grid : [GridTile] = [
        GridTile(x: 0, y: 0),
        GridTile(x: 1, y: 0),
        GridTile(x: 2, y: 0),
        //------------------
        GridTile(x: 0, y: 1),
        GridTile(x: 1, y: 1),
        GridTile(x: 2, y: 1),
        GridTile(x: 3, y: 1),
        //------------------
        GridTile(x: 0, y: 2),
        GridTile(x: 1, y: 2),
        GridTile(x: 2, y: 2),
        GridTile(x: 3, y: 2),
        //------------------
        GridTile(x: 0, y: 3),
        GridTile(x: 1, y: 3),
        GridTile(x: 2, y: 3),
        GridTile(x: 3, y: 3)
    ]
    @State var emptyTile = GridTile(x: 3, y: 0)
    let tileSize : CGFloat = 120
    let padding : CGFloat = 80
    var body: some View{
        ZStack{
            GeometryReader{ stack in
                ForEach(grid.indices, id: \.self){index in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(HexConvert.convertToColor("#a4b0be"))
                        .padding(5)
                        .frame(width: tileSize, height: tileSize)
                        .position(x: tileSize * grid[index].x + tileSize/2, y: tileSize * grid[index].y + tileSize/2)
                        .onTapGesture {
                            withAnimation{
                                moveTile(grid[index])
                            }
                        }
                }
                .frame(width: stack.size.width, height: stack.size.height)
            }
        }
        .padding(padding/2)
        .frame(width: 4 * tileSize + padding, height: 4 * tileSize + padding)
        .background(HexConvert.convertToColor("#57606f"))
        .cornerRadius(15)
    }
        
        
        func isMovable(_ tile : GridTile) -> Bool{
            let dx = abs(tile.x - emptyTile.x)
            let dy = abs(tile.y - emptyTile.y)
            
            return (dx == 1 && dy == 0) || (dx == 0 && dy == 1)
        }
        func moveTile(_ tile : GridTile){
            if isMovable(tile){
            if let index = grid.firstIndex(where: { $0.id == tile.id }) {
                    grid[index].x = emptyTile.x
                    grid[index].y = emptyTile.y
                    emptyTile.x = tile.x
                    emptyTile.y = tile.y
            }
        }
    }
}
