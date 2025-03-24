import Foundation
import SwiftUI

struct Point3D: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    var z: Double
}
enum Shapes{
    case cube, pyramid, cylinder
}

func pointToMatrix(point: Point3D) -> [[Double]] {
    return [[point.x], [point.y], [point.z]]
}

func matrixMult(_ mA: [[Double]], _ mB: [[Double]]) -> [[Double]] {
    var result: [[Double]] = Array(repeating: Array(repeating: 0, count: mB[0].count), count: mA.count)
    for i in 0..<mA.count {
        for j in 0..<mB[0].count {
            var sum: Double = 0
            for k in 0..<mA[0].count {
                sum += mA[i][k] * mB[k][j]
            }
            result[i][j] = sum
        }
    }
    return result
}

func rotationMatrixX(angle: Double) -> [[Double]] {
    return [
        [1, 0, 0],
        [0, cos(angle), -sin(angle)],
        [0, sin(angle), cos(angle)]
    ]
}

func rotationMatrixY(angle: Double) -> [[Double]] {
    return [
        [cos(angle), 0, sin(angle)],
        [0, 1, 0],
        [-sin(angle), 0, cos(angle)]
    ]
}
func rotationMatrixZ(angle: Double) -> [[Double]] {
    return [
        [cos(angle), -sin(angle), 0],
        [sin(angle), cos(angle), 0],
        [0, 0, 1]
    ]
}
func drawEdges(_ projectedPoints : [(CGFloat, CGFloat)], _ edges : [(Int,  Int)]) -> Path{
    let path = Path { path in
        for edge in edges{
            let start = projectedPoints[edge.0]
            let end = projectedPoints[edge.1]
            path.move(to: CGPoint(x: start.0 + 200, y: start.1 + 200))
            path.addLine(to: CGPoint(x: end.0 + 200, y: end.1 + 200))
        }
    }
    return path
}
struct drawPoints : View{
    let projectedPoints : [(CGFloat, CGFloat)]
    var body : some View{
        ForEach(0..<projectedPoints.count, id: \.self) { index in
            let (x, y) = projectedPoints[index]
            Circle()
                .frame(width: 10, height: 10)
                .offset(x: x, y: y)
                .foregroundColor(.white)
        }
    }
}
let size: Double = 150

let cubeEdges = [
    (0, 1), (1, 2), (2, 3), (3, 0),
    (4, 5), (5, 6), (6, 7), (7, 4),
    (0, 4), (1, 5), (2, 6), (3, 7)
]
let pyramidEdges = [
    (0, 1), (1, 2), (2, 0),
    (3, 0), (3, 1), (3, 2)
]
func cubePoints(_ size : Double) -> [Point3D]{
    return [
        Point3D(x: -size, y: -size, z: size),
        Point3D(x: size, y: -size, z: size),
        Point3D(x: size, y: size, z: size),
        Point3D(x: -size, y: size, z: size),
        Point3D(x: -size, y: -size, z: -size),
        Point3D(x: size, y: -size, z: -size),
        Point3D(x: size, y: size, z: -size),
        Point3D(x: -size, y: size, z: -size)
    ]
}

let pyramidPoints : [Point3D] = [
    Point3D(x: size, y: 0, z: size),
    Point3D(x: size*cos(120 * .pi/180), y: size*sin(120 * .pi/180), z: size),
    Point3D(x: size*cos(240 * .pi/180), y: size*sin(240 * .pi/180), z: size),
    Point3D(x: 0, y: 0, z: -size),
]
func generateEdges(_ points: [Point3D],_ vertices: Int) -> [(Int, Int)] {
    var edges: [(Int, Int)] = []
    for i in 0..<vertices {
        let next = (i + 1) % vertices
        edges.append((i, next))
    }
    return edges
}

func cylinderPoints(radius : Double, length : Double, verticies : Double) -> [Point3D]{
    var points : [Point3D] = []
    for i in 0..<Int(verticies){
        let angle = Double(360) / verticies * Double(i)
        let x = radius * cos(angle * .pi/180)
        let y = radius * sin(angle * .pi/180)
        points.append(Point3D(x: x,y: y,z: length))
    }
    return points
}
struct RenderShape3D: View {
    @State var radius : Double
    @State var getPoints: [(CGFloat, CGFloat)] = []
    let verticies : Int
    let selectedShape : Shapes
    let size : Double = 0
    let angleX : Double
    let angleY : Double
    let angleZ : Double
    let pointsVisible : Bool
    let projection: [[Double]] = [[1, 0, 0], [0, 1, 0], [0 ,0, 1]]
    
    func projectPoints(_ inpoints : [Point3D]) -> [(CGFloat, CGFloat)] {
        return inpoints.map { point in
            let rotatedX = matrixMult(rotationMatrixX(angle: angleX), pointToMatrix(point: point))
            let rotatedY = matrixMult(rotationMatrixY(angle: angleY), rotatedX)
            let rotatedZ = matrixMult(rotationMatrixZ(angle: angleZ), rotatedY)
            let projected2D = matrixMult(projection, rotatedZ)
            return (CGFloat(projected2D[0][0]), CGFloat(projected2D[1][0]))
        }
    }
    func getProjectedPoints() -> [(CGFloat, CGFloat)] {
            switch selectedShape {
            case .cube:
                return projectPoints(cubePoints(size))
            case .pyramid:
                return projectPoints(pyramidPoints)
            case .cylinder:
                let points = cylinderPoints(radius: radius, length: 0, verticies: Double(verticies))
                return projectPoints(points)
            }
        }
    var body: some View {
        ZStack{
            ZStack {
                let projectedPoints = getProjectedPoints()
                switch selectedShape {
                case .cube:
                    drawEdges(projectedPoints, cubeEdges).stroke(.white, lineWidth: 4)
                    //drawPoints(projectedPoints: projectedPoints)
                case .pyramid:
                    drawEdges(projectedPoints, pyramidEdges).stroke(.white, lineWidth: 4)
                    //drawPoints(projectedPoints: projectedPoints)
                case .cylinder:
                    if(pointsVisible){
                        drawPoints(projectedPoints: projectedPoints)
                    }
                    //drawEdges(projectedPoints, generateEdges(points, verticies)).stroke(.white, lineWidth: 4)
                }
            }
            .frame(width: 400, height: 400)
        }
    }
}
