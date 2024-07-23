//
//  TextToSpeechViewModel.swift
//  Patient-HMS
//
//  Created by IOS on 19/07/24.
//


import Foundation
import AVFoundation

class TextToSpeechViewModel: ObservableObject {
    private var synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
