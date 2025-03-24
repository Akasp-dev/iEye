import AVFoundation
class PlayAudio{
    var audioFile : String
    var audioPlayer : AVAudioPlayer?
    init(_ audioFile : String){
        self.audioFile = audioFile
    }
    func play(){
        if let url = Bundle.main.url(forResource: audioFile, withExtension: "aiff") {
            do {
                print("Audio file URL: \(url)")
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Audio player error: \(error)")
            }
        }
    }
}

