import SwiftUI
import Foundation

struct IncDec : View{
    let key : String
    let displayText : String
    let changeBy : Double
    let max : Double
    let min : Double
    let scale : Double
    let buttonWidth : Double = 50
    let buttonHeight : Double = 50
    
    @State var number : Double
    init(key : String, displayText : String, changeBy : Double, max : Double, min : Double , scale : Double){
        _number = State(initialValue: UserDefaults.standard.double(forKey: key))
        self.key = key
        self.displayText = displayText
        self.changeBy = changeBy
        self.max = max
        self.min = min
        self.scale = scale
    }
    
    var body : some View{
        VStack{
            Text("\(displayText)")
                .foregroundStyle(.black)
                .font(.custom("Montserrat", size: 18 * scale))
            HStack{
                Button("-"){
                    if number > min{
                        number -= changeBy
                        UserDefaults.standard.set(number, forKey: key)
                    }
                }
                .font(.custom("Rubik", size: 60 * scale))
                .frame(width: buttonWidth * scale, height: buttonHeight * scale)
                .background(.blue)
                .cornerRadius(5)
                Text("\(String(format: "%.1f", number))")
                    .frame(width: 150 * scale, height: buttonHeight * scale)
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 28 * scale))
                    .background(.white)
                    .cornerRadius(5)
                Button("+"){
                    if number < max{
                        number += changeBy
                        UserDefaults.standard.set(number, forKey: key)
                    }
                }
                .font(.custom("Rubik", size: 50 * scale))
                .frame(width: buttonWidth * scale, height: buttonHeight * scale)
                .background(.blue)
                .cornerRadius(5)
            }
            .onAppear{
                
            }
        }
    }
}
