import SwiftUI
import Foundation

let width = UIScreen.main.bounds.width
let height = UIScreen.main.bounds.height

struct LetterMatchView : View {
    let alphabet = "aąbcćdeęfghijklłmnńoóprsśtuwxyzżź".map({String($0)})
    @State var words : [String] = ["Lion", "Car", "Appointment", "Karetka"]
    var body: some View {
        ZStack{
            LetterMatchField(words: $words)
        }
        .frame(width: width, height: height)
        .background(.black)
    }
}

struct LetterMatchField : View {
    @Binding var words : [String]
    var body: some View {
        ZStack{
            GeometryReader{ g in
                VStack{
                    ForEach(words, id: \.self){word in
                        let letters = word.map({String($0)})
                        var oneTaken = false
                        HStack{
                            ForEach(letters, id: \.self){letter in
                                Text(letter)
                                    .font(.custom("Montserrat", size: 48))
                                    .frame(width: g.size.width * 0.10, height: g.size.height * 0.15)
                                    .background(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .scaleEffect(1 - calculateScale(CGFloat(letters.count)))
                    }
                }
                .position(x: g.size.width/2, y: g.size.height/2)
            }
        }
        .background(.blue)
    }
    func calculateScale(_ arraySize : CGFloat) -> CGFloat {
        return 0.03 * arraySize
    }
}

struct LetterMatchMenu : View {
   @Binding var words : [String]
    var body: some View {
        ZStack{
            GeometryReader{ g in
                RoundedRectangle(cornerRadius: 10)
                    .fill(HexConvert.convertToColor("#ecf0f1"))
                Text("Jakie wyrazy uzupełniamy?")
                    .font(.custom("Montserrat", size: 23))
                    .position(x: g.size.width/2, y: g.size.height*0.1)
                
                VStack(alignment: .leading) {
                    ForEach(words, id: \.self) { word in
                        Text(word)
                            .frame(width: g.size.width/1.8, height: 50)
                            .background(HexConvert.convertToColor("#bdc3c7"))
                            .font(.custom("Montserrat" , size: 25))
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                    }
                }
                .frame(width: g.size.width*0.8, height: 300)
                .position(x: g.size.width/2, y: g.size.height/2)
                Button("Zaczynamy"){
                    
                }
                .frame(width: g.size.width*0.50, height: 50)
                .font(.custom("Montserrat", size: 20))
                .background(.blue)
                .cornerRadius(10)
                .position(x: g.size.width/2, y: g.size.height - g.size.height*0.12)
            }
        }
        .frame(width: width*0.35, height: height*0.65)
    }
}

#Preview{
    LetterMatchView()
}
