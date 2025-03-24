import SwiftUI
import Foundation

struct KeyGameView : View{
    @State private var isMenuShown : Bool = false
    @State private var text : String = ""
    @State private var input : String = ""
    @State private var isSentenceFinished : Bool = true
    @State private var isWinShown : Bool = false
    @State private var index : Int = 0
    @State private var enterToBePressed : Bool = false
    var body: some View{
        ZStack{
            KeyGame(text: $text, isMenuShown: $isMenuShown, input: $input, isSentenceFinished: $isSentenceFinished, isWinShown: $isWinShown, index: $index, enterPressed: $enterToBePressed)
            KeyGameSettings(text: $text, isMenuShown: $isMenuShown, isSentenceFinished: $isSentenceFinished)
            KeyGameWinView(isWinShown: $isWinShown, index: $index, isSentenceFinished: $isSentenceFinished, input: $input, isMenuShown: $isMenuShown, enterToBePressed: $enterToBePressed)
        }
        .onAppear(perform: {
            isMenuShown = true
            isWinShown = false
        })
    }
}

struct KeyGameWinView : View {
    @Binding var isWinShown : Bool
    @Binding var index : Int
    @Binding var isSentenceFinished : Bool
    @Binding var input : String
    @Binding var isMenuShown : Bool
    @Binding var enterToBePressed : Bool
    let screenWidth : CGFloat = UIScreen.main.bounds.width
    let screenHeight : CGFloat = UIScreen.main.bounds.height
    var body: some View {
        ZStack{
            GeometryReader{ geometry in
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
                Text("Sukces!")
                    .font(.custom("Montserrat", size: min(screenWidth, screenHeight)*0.05))
                    .position(x: geometry.size.width/2, y: geometry.size.height/5)
                    .foregroundStyle(.black)
                Text("Co robimy dalej?")
                    .font(.custom("Montserrat", size: min(screenWidth, screenHeight)*0.03))
                    .position(x: geometry.size.width/2, y: geometry.size.height/3)
                    .foregroundStyle(.black)
                VStack{
                    Button("Powtórzmy tę samą frazę"){
                        index = 0
                        input = ""
                        enterToBePressed = false
                        isSentenceFinished = false
                        isWinShown = false
                    }
                    .padding(15)
                    .foregroundStyle(.white)
                    .frame(width: geometry.size.width/1.5, height: geometry.size.height/6)
                    .font(.custom("Montserrat", size: min(screenWidth, screenHeight)*0.03))
                    .background(.blue)
                    .cornerRadius(10)
                    Button("Wymyślmy coś innego"){
                        index = 0
                        input = ""
                        isSentenceFinished = false
                        enterToBePressed = false
                        isWinShown = false
                        isMenuShown = true
                    }
                    .padding(15)
                    .foregroundStyle(.white)
                    .frame(width: geometry.size.width/1.5, height: geometry.size.height/6)
                    .font(.custom("Montserrat", size: min(screenWidth, screenHeight)*0.03))
                    .background(.blue)
                    .cornerRadius(10)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .position(x: geometry.size.width/2, y: geometry.size.height/1.5)
                
            }
        }
        .frame(width: screenWidth/2, height: screenHeight/3)
        .opacity(isWinShown ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: isWinShown)
    }
}

struct KeyGameSettings : View {
    let screenWidth : CGFloat = UIScreen.main.bounds.width
    let screenHeight : CGFloat = UIScreen.main.bounds.height
    @Binding var text : String
    @Binding var isMenuShown : Bool
    @Binding var isSentenceFinished : Bool
    @FocusState var isFocused : Bool
    var body: some View {
        ZStack{
            GeometryReader{ geometry in
                VStack(spacing: 40){
                    Text("Co chcesz napisać?")
                        .font(.custom("Montserrat", size: 40))
                        .foregroundStyle(.black)
                    TextField("", text: $text)
                        .padding(10)
                        .frame(width: geometry.size.width/1.2, height: geometry.size.height/7)
                        .font(.custom("Montserrat", size: 26))
                        .focused($isFocused)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .cornerRadius(15)
                        .foregroundStyle(.black)
                        
                    Button("Zaczynamy!"){
                        withAnimation(.snappy(duration: 0.2)){
                            if !text.isEmpty{
                                isMenuShown.toggle()
                                isSentenceFinished = false
                                isFocused = false
                            }
                        }
                    }
                    .padding(15)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .font(.custom("Montserrat", size: 30))
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    
                }
                .position(x: geometry.size.width/2, y: geometry.size.height/2)
            }
        }
        .frame(width: screenWidth/2, height: screenHeight/2.5)
        .background(.white)
        .cornerRadius(15)
        .opacity(isMenuShown ? 1 : 0)
    }
}
struct KeyGame : View {
    @Binding var text : String
    @Binding var isMenuShown : Bool
    @Binding var input : String
    @Binding var isSentenceFinished : Bool
    @Binding var isWinShown : Bool
    @Binding var index : Int
    @Binding var enterPressed : Bool
    @State var arePolishLettersActive : Bool = false
    let screenWidth : CGFloat = UIScreen.main.bounds.width
    let screenHeight : CGFloat = UIScreen.main.bounds.height
    let rows = ["qwertyuiop", "asdfghjkl", "zxcvbnm"]
    let swappedRows = ["qwęrtyuióp", "ąśdfghjkł", "żźćvbńm"]
    let spacing : CGFloat = 10
    var body: some View {
        let textToSpell = text.isEmpty ? [] : text.map({String($0)})
        let cubeSize : CGFloat = screenWidth / 12
        ZStack{
            Rectangle()
                .fill(.black)
                .scaledToFill()
                .ignoresSafeArea(.all)
            Text(input)
                .foregroundStyle(.white)
                .font(.custom("Montserrat", size: 50))
                .offset(y: screenHeight / -6)
                .blur(radius: isMenuShown || isWinShown ? 20 : 0)
            VStack(spacing: spacing){
                ForEach(arePolishLettersActive ? swappedRows : rows,id: \.self){row in
                    let splitted = row.map({String($0)})
                    HStack(spacing: spacing){
                        ForEach(splitted, id: \.self){ separatedLetter in
                            Text(separatedLetter)
                                .frame(width: cubeSize, height: cubeSize)
                                .background(index < textToSpell.count && !enterPressed && separatedLetter == textToSpell[index].lowercased() && !isSentenceFinished ? .green : Color(red: 0.95, green: 0.95, blue: 0.96))
                                .font(.custom("Montserrat", size: 50))
                                .foregroundStyle(.black)
                                .cornerRadius(10)
                                .onTapGesture {
                                    if !isSentenceFinished && !enterPressed{
                                        inputText(separatedLetter)
                                    }
                                }
                        }
                    }
                }
                HStack{
                    Text("ąęś")
                        .frame(width: cubeSize, height: cubeSize)
                        .background(index < textToSpell.count && shouldSpecialKeyHighlight(textToSpell[index].lowercased()) ? .green : Color(red: 0.95, green: 0.95, blue: 0.96))
                        .foregroundStyle(.black)
                        .cornerRadius(10)
                        .font(.custom("Montserrat", size: 40))
                        .onTapGesture {
                            arePolishLettersActive.toggle()
                        }
                    RoundedRectangle(cornerRadius: 10)
                        .fill(index < textToSpell.count && textToSpell[index] == " " ? .green : Color(red: 0.95, green: 0.95, blue: 0.96))
                        .frame(width: cubeSize * CGFloat(rows[2].count) + 6 * spacing, height: cubeSize)
                        .onTapGesture {
                            inputText(" ")
                    }
                    Text("Enter")
                        .frame(width: cubeSize*2, height: cubeSize)
                        .background(enterPressed ? .green : Color(red: 0.95, green: 0.95, blue: 0.96))
                        .cornerRadius(10)
                        .font(.custom("Montserrat", size: 40))
                        .foregroundStyle(.black)
                        .onTapGesture {
                            if enterPressed{
                                isWinShown = true
                                isSentenceFinished = true
                            }
                        }
                }
            }
            .offset(y: screenHeight / 5.5)
            .blur(radius: isMenuShown || isWinShown ? 20 : 0)
            .disabled(isMenuShown)
        }
    }
    func shouldSpecialKeyHighlight(_ letter : String) -> Bool{
        if letter == " "{
            return false
        }
        if (!"ęóąśłżźćń".contains(letter) && arePolishLettersActive) || ("ęóąśłżźćń".contains(letter) && !arePolishLettersActive){
            return true
        }else {
            return false
        }
    }
    func inputText(_ letter : String){
        let array = text.map({String($0)})
        if letter == array[index].lowercased() && !isSentenceFinished{
            withAnimation(.bouncy(duration: 0.2)){
                input += letter
                if index < array.count - 1{
                    index += 1
                }
                else if index == array.count - 1{
                    enterPressed = true
                }
                else{
                    withAnimation(.bouncy(duration: 0.2)){
                        isSentenceFinished = true
                        isWinShown = true
                    }
                }
            }
        }
    }
}
#Preview{
    KeyGameView()
}
