import AVFoundation

class SpeechSynthesizer {
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-IN")
        utterance.rate = 0.45 // Slower for better clarity
        utterance.pitchMultiplier = 1.1
        utterance.postUtteranceDelay = 0.5
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }
}
