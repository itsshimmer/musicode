import SwiftUI
import AVFoundation

public struct Main: View {
    
    // Function to code the keyboard arrangement
    func keyboardArrangement() {
        // You may choose what note to play, at what volume(0%-100%) and what should be delay until the next note, in seconds.
        playKeyboardNote(sample: Sample.KeyboardNote4, volume: 100, delay: 0.3)
        playKeyboardNote(sample: Sample.KeyboardNote1, volume: 100, delay: 0.3)
        playKeyboardNote(sample: Sample.KeyboardNote1, volume: 100, delay: 0.3)
        playKeyboardNote(sample: Sample.KeyboardNote7, volume: 100, delay: 0.3)
        playKeyboardNote(sample: Sample.KeyboardNote6, volume: 100, delay: 0.3)
        playKeyboardNote(sample: Sample.KeyboardNote6, volume: 100, delay: 0.3)
        playKeyboardNote(sample: Sample.KeyboardNote6, volume: 100, delay: 0.15)
        playKeyboardNote(sample: Sample.KeyboardNote6, volume: 100, delay: 0.15)
        playKeyboardNote(sample: Sample.KeyboardNote7, volume: 100, delay: 0.15)
        playKeyboardNote(sample: Sample.KeyboardNote4, volume: 100, delay: 0.3)
        playKeyboardNote(sample: Sample.KeyboardNote1, volume: 100, delay: 0.3)
        playKeyboardNote(sample: Sample.KeyboardNote1, volume: 100, delay: 0.3)
        playKeyboardNote(sample: Sample.KeyboardNote7, volume: 100, delay: 0.3)
        playKeyboardNote(sample: Sample.KeyboardNote6, volume: 100, delay: 0.15)
        playKeyboardNote(sample: Sample.KeyboardNote6, volume: 100, delay: 0.15)
        playKeyboardNote(sample: Sample.KeyboardNote6, volume: 100, delay: 0.15)
        playKeyboardNote(sample: Sample.KeyboardNote6, volume: 100, delay: 0.15)
        playKeyboardNote(sample: Sample.KeyboardNote7, volume: 100, delay: 0.15)
        playKeyboardNote(sample: Sample.KeyboardNote4, volume: 100, delay: 0.3)
    }
    
    // Function to code the drummer arrangement0
    func drumsArrangement() {
        // As you can see, you may use loops in your arrangement!
        for _ in 0...5 {
            playDrumNote(sample: Sample.BongoNote1, volume: 25, delay: 0.15)
            playDrumNote(sample: Sample.BongoNote2, volume: 15, delay: 0.15)
            playDrumNote(sample: Sample.BongoNote2, volume: 15, delay: 0.15)
            playDrumNote(sample: Sample.BongoNote1, volume: 25, delay: 0.15)
        }
    }
    
    // Function to code the tambourine arrangement
    func tambourineArrangement() {
        // The tambourine only has a single sample but... How about playing with the volume? Add some grooves to your track!
        for _ in 0...5 {
            hitTambourine(volume: 20, delay: 0.15)
            hitTambourine(volume: 10, delay: 0.15)
            hitTambourine(volume: 10, delay: 0.15)
            hitTambourine(volume: 20, delay: 0.15)
        }
    }
    // End of the arrangement functions, go back!
    
    // State variables to control the character's sprite
    @State var pianistSprite: String = pianistRestSprite
    @State var drummerSprite: String = drummerRestSprite
    @State var tambourinePlayerSprite: String = tambourinePlayerRestSprite
    
    public init() {
        
    }
    
    // Function to dispatch all band players at the same time
    func playBand() {
        DispatchQueue.background(background: {
            keyboardArrangement()
        })
        DispatchQueue.background(background: {
            drumsArrangement()
        })
        DispatchQueue.background(background: {
            tambourineArrangement()
        })
    }
    
    // Function to play the keyboard sample and animate the character
    func playKeyboardNote(sample: Sample, volume: Int, delay: Double) {
        pianistSprite = pianistActionSprite
        playSampleThread(sample: sample, volume: volume)
        wait(seconds: 0.1)
        pianistSprite = pianistRestSprite
        wait(seconds: delay)
    }
    
    // Function to play the drum sample and animate the character
    func playDrumNote(sample: Sample, volume: Int, delay: Double) {
        drummerSprite = drummerActionSprite
        playSampleThread(sample: sample, volume: volume)
        wait(seconds: 0.1)
        drummerSprite = drummerRestSprite
        wait(seconds: delay)
    }
    
    // Function to play the tambourine sample and animate the character
    func hitTambourine(volume: Int, delay: Double) {
        tambourinePlayerSprite = tambourinePlayerActionSprite
        playSampleThread(sample: Sample.Tambourine, volume: volume)
        wait(seconds: 0.1)
        tambourinePlayerSprite = tambourinePlayerRestSprite
        wait(seconds: delay)
    }
    
    // Creates the view using SwiftUI
    public var body: some View {
        // ZStack to overlay the background and other elements
        ZStack {
            // Background
            Image(uiImage: UIImage(named: "background.png")!)
            // Content
            VStack {
                // Sprites
                Spacer()
                HStack {
                    Image(uiImage: UIImage(named: drummerSprite)!)
                        .padding()
                }
                HStack {
                    Spacer()
                    Image(uiImage: UIImage(named: pianistSprite)!)
                        .padding()
                    Spacer()
                    Image(uiImage: UIImage(named: tambourinePlayerSprite)!)
                        .padding()
                    Spacer()
                }
                Spacer()
                // Play Button
                Button(action: {
                    // Plays a mute sample and waits .3 second to evade sound bugs
                    playSampleThread(sample: Sample.KeyboardNote1, volume: 0)
                    wait(seconds: 0.3)
                    
                    playBand()
                }) {
                    Image(uiImage: UIImage(named: "button.png")!)
                        .padding(.bottom, 2)
                }
            }
        }
    }
}

// Final sprite file names
let pianistRestSprite = "piano_lion.png"
let pianistActionSprite = "piano_lion_squish.png"

let drummerRestSprite = "drum_octopus.png"
let drummerActionSprite = "drum_octopus_squish.png"

let tambourinePlayerRestSprite = "tambourine_panda.png"
let tambourinePlayerActionSprite = "tambourine_panda_squish.png"

// DispatchQueue is used to execute multiple funtions at the same time with the same function
extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .userInitiated).async { // userInteractive priority is essential to run appropriately
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}

// Samples enum definition, Sample.rawValue = filename
enum Sample: String {
    case KeyboardNote1 = "keyboard0"
    case KeyboardNote2 = "keyboard1"
    case KeyboardNote3 = "keyboard2"
    case KeyboardNote4 = "keyboard3"
    case KeyboardNote5 = "keyboard4"
    case KeyboardNote6 = "keyboard5"
    case KeyboardNote7 = "keyboard6"
    case KeyboardNote8 = "keyboard7"
    case KeyboardNote9 = "keyboard8"
    case KeyboardNote10 = "keyboard9"
    case Tambourine = "tambourine"
    case BongoNote1 = "bongo0"
    case BongoNote2 = "bongo1"
    case Cymbal = "cymbal"
}

// Function to play a sample using AVAudioPlayer
func playSample(sample: Sample, volume: Float) {
    var audioPlayer = AVAudioPlayer()
    let resource = Bundle.main.path(forResource: sample.rawValue, ofType: "mp3")
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: resource!))
        audioPlayer.volume = volume
        audioPlayer.play()
        sleep(2) // Considering no samples are longer than 2 seconds, sleeps for 2 seconds so the AVAudioPlayer can finish playing the sample
        // if the funtion returns immediately, AVAudioPlayer gets destroyed and the audio stopped
    }
    catch {
        print(error)
    }
}

// Function to play a sample asynchronously and use volume from 0 to 100 percent instead of 0 to 1
func playSampleThread(sample: Sample, volume: Int) {
    // Converts volume from percentage to 0-1
    let convertedVolume: Float = Float(Double(volume)*0.01)
    // Plays the sample in a thread with the specified volume
    DispatchQueue.background(background: {
        playSample(sample: sample, volume: convertedVolume)
    })
}

// Function to sleep in seconds, supporting decimal numbers (native sleep doesn't)
func wait(seconds: Double) {
    let amount: Double = seconds*1000000
    usleep(UInt32(amount))
}
