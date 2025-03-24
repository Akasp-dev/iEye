import SwiftUI
import Foundation

struct CoinChaseConfig: View {
    @State private var selection = "test"
    let inputOptions = ["Kliknięcie", "Najechanie"]
    var body: some View {
        VStack(alignment: .center){
            Text("Żeton reaguje na: ")
                .font(.system(size: 30))
            Picker("Czy żeton reaguje na:", selection: $selection){
                ForEach(inputOptions, id: \.self){
                    Text($0)
                }
            }.pickerStyle(.menu)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(.blue)
                    .padding(.horizontal, -30)
                    .padding(.vertical, -15)
            )
            .accentColor(.white)
        }
        .padding()
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}

#Preview {
    CoinChaseConfig()
}
