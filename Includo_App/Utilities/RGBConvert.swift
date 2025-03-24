import SwiftUICore
class RGBConvert {
    static func convertToColor(_ r : Int,_ g : Int,_ b : Int) -> Color {
        let red = Double(r) / 255
        let green = Double(g) / 255
        let blue = Double(b) / 255
        return Color(red: red, green: green, blue: blue)
    }
    static func randomColor() -> Color {
        return Color(
            red: Double.random(in: 0...255) / 255,
            green: Double.random(in: 0...255) / 255,
            blue: Double.random(in: 0...255) / 255
        )
    }
}
class HexConvert {
    static func convertToColor(_ hex : String) -> Color {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        guard hexString.count == 6 else {
            return .gray
        }
        var rgb: UInt64 = 0
        let scanner = Scanner(string: hexString)
        scanner.scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        return Color(red: red, green: green, blue: blue)
    }
}
