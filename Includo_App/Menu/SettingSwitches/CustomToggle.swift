import SwiftUI
import Foundation

struct CustomToggleCircle: View {
    @Binding var isOn : Bool
    let text : String
    let scale : Double
    var body : some View{
        HStack{
            Text(text)
                .font(.custom("Montserrat", size: 25 * scale))
                .foregroundStyle(.black)
            Spacer()
                .frame(width: 30 * scale)
            RoundedRectangle(cornerRadius: 50)
                .fill(isOn ? .green : .red)
                .frame(width: 90 * scale, height: 45 * scale)
                .animation(.easeInOut(duration: 0.15), value: isOn)
                .overlay{
                    Circle()
                        .frame(width: 42 * scale, height: 42 * scale)
                        .offset(x: isOn ? 22 * scale : -22 * scale)
                        .animation(.spring(duration: 0.3), value: isOn)
                }
        }
        .onTapGesture {
            isOn.toggle()
        }
    }
}
struct ToggleSwitch : View{
    @Binding var isOn : Bool
    let text : String
    let scale : Double
    var body : some View{
        CustomToggleCircle(isOn: $isOn, text: "Wymuszona kolejność", scale: scale)
    }
}
