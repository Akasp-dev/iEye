import SwiftUI
import Foundation

var value = false

struct Switch: View {
    @State var switchValue : Bool
    let text : String
    var body: some View {
        HStack{
            Text("Dark Mode")
            Toggle("", isOn: $switchValue).padding().labelsHidden()
                .tint(.blue)
        }
    }
}

#Preview{
    Switch(switchValue: value, text: "Test")
}
