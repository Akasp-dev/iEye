import SwiftUI

struct RotatingTiles: View {
    let selectedIndex : Int
    let array : Array<String>
    let rotation : Double
    let tiles = [
        "EyePaint_icon",
        "CoinChase_icon",
        "FallingShapes_icon",
        "Tiles_icon",
        "KeyGame_icon",
        "Swipe_icon",
        "Smaller_icon",
        "",
        "",
        "",
        ""
    ]
    
    
    func getPoints(_ shape : RenderShape3D) -> [(CGFloat, CGFloat)]{
        return shape.getProjectedPoints()
    }
    func returnImageTile(_ index : Int, _ point : (CGFloat, CGFloat), _ size : (CGFloat, CGFloat), _ opacity : Double, _ zIndex : Double, _ circle : RenderShape3D) -> some View{
        return Image(tiles[index])
            .resizable()
            .scaledToFill()
            .frame(
                width: size.0,
                height: size.1
            )
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .position(x: point.0 + UIScreen.main.bounds.width/2, y: point.1 + UIScreen.main.bounds.height/2-40)
            .shadow(color: .black.opacity(0.4), radius: 5)
            .opacity(opacity)
            .zIndex(zIndex)
    }
    func returnRectTile(_ index : Int, _ point : (CGFloat, CGFloat), _ size : (CGFloat, CGFloat), _ opacity : Double, _ zIndex : Double, _ circle : RenderShape3D) -> some View{
        return RoundedRectangle(cornerRadius: 15)
            .fill(.white)
            .frame(
                width: size.0,
                height: size.1
            )
            .position(x: point.0 + UIScreen.main.bounds.width/2, y: point.1 + UIScreen.main.bounds.height/2-40)
            .shadow(color: .black.opacity(0.4), radius: 5)
            .opacity(opacity)
            .zIndex(zIndex)
    }
    var body: some View {
        let circle = RenderShape3D(radius: 360, verticies: array.count, selectedShape: .cylinder, angleX: -1.57, angleY: rotation, angleZ: 0, pointsVisible: true)
        let points = getPoints(circle)
        ForEach(Array(array.enumerated()), id: \.element ){index, app in
            let size = Utils().calculateSize(index, selectedIndex, array, 350, 250)
            let opacity = Utils().calculateOpacity(index, selectedIndex, array, 1)
            let zIndex = Utils().calculateZIndex(index, selectedIndex, array)
            if index < tiles.count, tiles[index].isEmpty{
                returnRectTile(index, points[index], size, opacity, zIndex, circle)
            }else{
                returnImageTile(index, points[index], size, opacity, zIndex, circle)
            }
        }
        .animation(.spring(duration: 0.2))
    }
}
#Preview{
    Menu()
}
