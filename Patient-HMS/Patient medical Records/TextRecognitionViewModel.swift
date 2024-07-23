//
//  TextRecognitionViewModel.swift
//  Patient-HMS
//
//  Created by IOS on 19/07/24.
//
import Foundation
import AVFoundation
import Vision
import SwiftUI

class TextRecognitionViewModel: ObservableObject {
    private var synthesizer = AVSpeechSynthesizer()

    func recognizeText(from image: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else {
            completion("Failed to convert UIImage to CGImage")
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            guard error == nil else {
                completion("Error: \(error!.localizedDescription)")
                return
            }
            
            let recognizedStrings = request.results?.compactMap { result in
                (result as? VNRecognizedTextObservation)?.topCandidates(1).first?.string
            } ?? []
            
            let recognizedText = recognizedStrings.joined(separator: "\n")
            completion(recognizedText)
        }
        
        request.recognitionLevel = .accurate
        
        do {
            try requestHandler.perform([request])
        } catch {
            completion("Failed to perform text recognition: \(error.localizedDescription)")
        }
    }

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
