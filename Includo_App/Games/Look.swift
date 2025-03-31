import SwiftUI
import Foundation

let images = ["paint", "wrench", "chainsaw", "battery", "fuel", "radio", "axe", "drill"]

struct JumpingImage : View {
    @Binding var selectedImage : CGFloat
    let imageName : String
    let imageScale : CGFloat
    let positionX : CGFloat
    let positionY : CGFloat
    let rotation : Double
    @State var isJumping : Bool = false
    var body : some View{
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(imageScale)
            .rotationEffect(Angle(degrees: rotation))
            .position(x: positionX, y: positionY)
            .offset(y: isJumping ? -25 : 0)
            .animation(.spring(), value: isJumping)
            .onTapGesture {
                isJumping.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isJumping.toggle()
                }
                if imageName == images[Int(selectedImage)]{
                    var newIndex: Int
                    repeat {
                        newIndex = Int.random(in: 0..<images.count)
                    } while newIndex == Int(selectedImage)

                    selectedImage = CGFloat(newIndex)
                }
            }
    }
}

struct LookView : View {
    @State var circleX : CGFloat = Sizes.width/2
    @State var circleY : CGFloat = Sizes.height/2
    @State var selectedItem : CGFloat = 4
    
    var body : some View {
        ZStack{
            GeometryReader { geometry in
                Image("look_bg")
                    .resizable()
                    .ignoresSafeArea()
                    .overlay(
                        ZStack{
                            JumpingImage(selectedImage: $selectedItem, imageName: "paint", imageScale: 0.2, positionX: geometry.size.width/6, positionY: geometry.size.height/5, rotation: 0)
                            JumpingImage(selectedImage: $selectedItem, imageName: "wrench", imageScale: 0.2, positionX: geometry.size.width/1.28, positionY: geometry.size.height/2.6, rotation: 0)
                            JumpingImage(selectedImage: $selectedItem, imageName: "chainsaw", imageScale: 0.3, positionX: geometry.size.width/4.1, positionY: geometry.size.height/1.68, rotation: 0)
                            JumpingImage(selectedImage: $selectedItem, imageName: "battery", imageScale: 0.25, positionX: geometry.size.width/1.8, positionY: geometry.size.height/2.08, rotation: 0)
                            JumpingImage(selectedImage: $selectedItem, imageName: "fuel", imageScale: 0.3, positionX: geometry.size.width/1.3, positionY: geometry.size.height/1.4, rotation: 0)
                            JumpingImage(selectedImage: $selectedItem, imageName: "radio", imageScale: 0.2, positionX: geometry.size.width/5, positionY: geometry.size.height/2.4, rotation: 0)
                            JumpingImage(selectedImage: $selectedItem, imageName: "axe", imageScale: 0.6, positionX: geometry.size.width/1.7, positionY: geometry.size.height/5, rotation: -90)
                            JumpingImage(selectedImage: $selectedItem, imageName: "drill", imageScale: 0.2, positionX: geometry.size.width/1.45, positionY: geometry.size.height/2.13, rotation: 0)
                        }
                    )
                Rectangle()
                    .fill(.black)
                    .ignoresSafeArea()
                    .opacity(0.88)
                    .overlay(
                        Circle()
                            .frame(width: 380)
                            .position(x: circleX, y: circleY)
                            .blur(radius: 10)
                            .blendMode(.destinationOut)
                            .allowsHitTesting(false)
                    )
                    .compositingGroup()
                    .allowsHitTesting(false)
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.black)
                        .opacity(0.8)
                        .frame(width: geometry.size.width/6, height: geometry.size.width/6)
                        .position(x: 130, y: geometry.size.height/1.15)
                    Image(images[Int(selectedItem)])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                        .position(x: 130, y: geometry.size.height/1.15)
                }
                
            }
            .onContinuousHover{hover in
                switch hover {
                case .active(let point):
                    circleX = point.x
                    circleY = point.y
                case .ended:
                    print("Out")
                }
            }
        }.navigationBarHidden(true)
    }
}

#Preview {
    LookView()
}
