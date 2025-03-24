import SwiftUI
import AVFoundation
import AVKit
import Foundation
import Combine

struct ContentView: View {
    @State private var isVideoFinished = false
    
    var body: some View {
        ZStack {
            if isVideoFinished{
                Menu()
            }
            if !isVideoFinished {
                VideoPlayerView(isVideoFinished: $isVideoFinished)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isVideoFinished)
    }
}
struct Menu : View{
    @State var selectedIndex = 0
    @State var isDescVisible = false
    @State var rotation : Double = -1.57
    
    let utils = Utils()
    let texts = TextProvider()
    let textFormatter = TextFormatter()
    let fontSize = [25,25,23,25,18,24,20,20,20,20,20]
    func getPoints(_ shape : RenderShape3D) -> [(CGFloat, CGFloat)]{
        return shape.getProjectedPoints()
    }
    var body : some View{
        NavigationStack{
            ZStack{
                Image("Menu_bg")	
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                ZStack{
                    Image("Arrow_left")
                        .frame(width: 120, height: 120)
                        .position(CGPoint(x: 115.0, y: UIScreen.main.bounds.height/1.2))
                        .onTapGesture {
                            selectedIndex = utils.recurringDecrease(selectedIndex, texts.returnAllTitles())
                            selectedIndex = min(max(selectedIndex, 0), texts.returnAllTitles().count - 1)
                            withAnimation {
                                let anglePerTile = 360.0 / Double(titles.count)
                                let roundedAnglePerTile = (anglePerTile * 1000).rounded() / 1000
                                rotation += utils.degreeToRad(roundedAnglePerTile)
                            }
                        }
                    Image("Arrow_right")
                        .frame(width: 100, height: 100)
                        .position(CGPoint(x: UIScreen.main.bounds.width - 115, y: UIScreen.main.bounds.height/1.2))
                        .onTapGesture {
                            selectedIndex = utils.recurringIncrease(selectedIndex, texts.returnAllTitles())
                            selectedIndex = min(max(selectedIndex, 0), texts.returnAllTitles().count - 1)
                            withAnimation {
                                let anglePerTile = 360.0 / Double(titles.count)
                                let roundedAnglePerTile = (anglePerTile * 1000).rounded() / 1000
                                rotation -= utils.degreeToRad(roundedAnglePerTile)
                            }
                        }
                    RotatingTiles(selectedIndex: selectedIndex, array: texts.returnAllTitles(), rotation: rotation)
                        .position(x: Sizes.width/2, y: Sizes.height/2)
                    Text(texts.returnTitles(selectedIndex))
                        .font(.custom("Rubik", size: 60))
                        .foregroundStyle(.white)
                        .position(
                            x: UIScreen.main.bounds.width/2,
                            y: 180
                        )
                        .multilineTextAlignment(.center)
                    Button {
                        withAnimation{
                            isDescVisible.toggle()
                        }
                    } label: {
                        Text("Wybierz")
                            .padding(.horizontal, 80)
                            .padding(.vertical, 20)
                            .font(.custom("Montserrat", size: 20))
                            .foregroundStyle(.blue)
                    }
                    .background(.white)
                    .cornerRadius(15)
                    .position(CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height - 230))
                    Text(texts.returnShortDesc(selectedIndex))
                        .font(.custom("Montserrat", size: CGFloat(fontSize[selectedIndex])))
                        .foregroundStyle(.white)
                        .frame(width: 750, height: 200)
                        .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height - 130)
                        .multilineTextAlignment(.center)
                }
                .disabled(isDescVisible)
                .blur(radius: isDescVisible ? 10 : 0)
                SettingsBar(isDescVisible: $isDescVisible, array: texts.returnAllTitles(), selectedIndex: selectedIndex, textFormatter: textFormatter, textProvider: texts)
            }
        }
    }
}
struct VideoPlayerView: View {
    @Binding var isVideoFinished: Bool
    private let player: AVPlayer
    @State private var playerObserver: AnyCancellable?
    
    init(isVideoFinished: Binding<Bool>) {
        self._isVideoFinished = isVideoFinished
        let videoURL = Bundle.main.url(forResource: "Intro 1.1", withExtension: "mp4")!
        self.player = AVPlayer(url: videoURL)
    }
    
    var body: some View {
        VStack {
            VideoPlayer(player: player)
                .onAppear {
                    player.play()
                    
                    // Observe the end of the video using AVPlayerItem notification
                    playerObserver = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                        .sink { _ in
                            // Ensure state change happens on the main thread
                            DispatchQueue.main.async {
                                isVideoFinished = true // Update the parent view's @State
                            }
                        }
                }
                .onDisappear {
                    playerObserver?.cancel() // Clean up the observer when the view disappears
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure full screen
                .disabled(true)  // Disable interaction with the video
        }
    }
}

#Preview{
    Menu()
}
