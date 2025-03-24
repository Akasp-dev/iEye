import SwiftUI

struct SettingsBar: View {
    
    @Binding var isDescVisible : Bool
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let array : Array<String>
    let selectedIndex : Int
    let textFormatter : TextFormatter
    let textProvider : TextProvider
    let settings = UserDefaults.standard
    @State var isOn = true
    var body: some View {
        ZStack{
            ForEach(Array(array.enumerated()), id: \.element){index, app in
                ZStack{
                    Rectangle()
                        .fill(.white)
                        .frame(
                            width: UIScreen.main.bounds.width/2,
                            height: UIScreen.main.bounds.height
                        )
                    ZStack{
                        Button {
                            withAnimation{
                                isDescVisible.toggle()
                            }
                        } label: {
                            Text("Wróć")
                                .padding(.horizontal, 262)
                                .padding(.vertical, 20)
                                .font(.custom("Montserrat", size: 25))
                                .foregroundStyle(Color(red: 0.204, green: 0.596, blue: 0.859))
                        }
                        .position(
                            x: UIScreen.main.bounds.width/2,
                            y: 70
                        )
                        //.background(.gray)
                        Text(array[selectedIndex])
                            .foregroundStyle(.black)
                            .font(.custom("Rubik", size: 35))
                            .position(
                                x: UIScreen.main.bounds.width/2,
                                y: 150
                            )
                        
                        NavigationLink(destination: gameSelection(selectedIndex), label: {
                            Text("Graj")
                                .padding(.horizontal, 30)
                                .padding(.vertical, 30)
                                .background(.blue)
                                .font(.custom("Montserrat", size: 25))
                                .clipShape(Circle())
                        })
                        .position(
                            x: UIScreen.main.bounds.width/2 + 200,
                            y: UIScreen.main.bounds.height/2 + 320
                        )
                        switch selectedIndex {
                        case 0:
                            Text(textProvider.returnLongDesc(selectedIndex))
                                .foregroundStyle(.black)
                                .font(.custom("Montserrat", size: 23))
                                .frame(
                                    width: UIScreen.main.bounds.width/2 - 100
                                    //height: UIScreen.main.bounds.height/2
                                )
                                .position(
                                    x: UIScreen.main.bounds.width/2,
                                    y: UIScreen.main.bounds.height/2
                                )
                        case 1:
                            Text(textProvider.returnLongDesc(selectedIndex))
                                .foregroundStyle(.black)
                                .font(.custom("Montserrat", size: 23))
                                .frame(
                                    width: UIScreen.main.bounds.width/2 - 100
                                )
                                .position(
                                    x: UIScreen.main.bounds.width/2,
                                    y: UIScreen.main.bounds.height/2
                                )
                        case 2:
                            Text(textProvider.returnLongDesc(selectedIndex))
                                .foregroundStyle(.black)
                                .font(.custom("Montserrat", size: 17))
                                .frame(
                                    width: UIScreen.main.bounds.width/2 - 100
                                )
                                .position(
                                    x: UIScreen.main.bounds.width/2,
                                    y: UIScreen.main.bounds.height/2 - 70
                                )
                            IncDec(key: "shapesAvailableShapes", displayText: "Ilość dostępnych kształtów: ", changeBy: 1, max: 4, min: 2, scale: 0.8)
                                .position(
                                    x: UIScreen.main.bounds.width/2 ,
                                    y: UIScreen.main.bounds.height/2 + 150
                                )
                            IncDec(key: "shapesVelocity", displayText: "Prędkość spadania: ", changeBy: 1, max: 20, min: 5, scale: 0.8)
                                .position(
                                    x: UIScreen.main.bounds.width/2 ,
                                    y: UIScreen.main.bounds.height/2 + 240
                                )
                            IncDec(key: "shapesSize", displayText: "Rozmiar kształtów: ", changeBy: 50, max: 250, min: 100, scale: 0.8)
                                .position(
                                    x: UIScreen.main.bounds.width/2 ,
                                    y: UIScreen.main.bounds.height/2 + 330
                                )
                        case 3:
                            Text(textProvider.returnLongDesc(selectedIndex))
                                .foregroundStyle(.black)
                                .font(.custom("Montserrat", size: 18))
                                .frame(
                                    width: UIScreen.main.bounds.width/2 - 100
                                    //height: UIScreen.main.bounds.height/2
                                )
                                .position(
                                    x: UIScreen.main.bounds.width/2,
                                    y: UIScreen.main.bounds.height/2 - 50
                                )
                            /*ToggleSwitch(isOn: $isOn, text: "Wymuszona kolejność", scale: 0.7)
                                .position(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 + 150)*/
                            
                        default:
                            Text("Error")
                        }
                    }
                }
                .offset(x: isDescVisible ? 0 : -UIScreen.main.bounds.width/2)
            }
        }
        .position(
            x: UIScreen.main.bounds.width/4,
            y: UIScreen.main.bounds.height/2 - 5
        )
    }
}

#Preview{
    Menu()
}
