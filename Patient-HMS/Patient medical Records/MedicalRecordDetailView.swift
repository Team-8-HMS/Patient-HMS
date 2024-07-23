//
//  MedicalRecordDetailView.swift
//  Patient-HMS
//
//  Created by Dhairya bhardwaj on 15/07/24.
//

import SwiftUI
import AVFoundation
import Vision

struct MedicalRecordDetailView: View {
    var record: MedicalRecord
    @StateObject private var ttsViewModel = TextToSpeechViewModel()
    @StateObject private var textRecognitionViewModel = TextRecognitionViewModel()
    @State private var recognizedText = ""
    @State private var loadedImage: UIImage? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("Family Member:")
                        .font(.headline)
                    Text(record.familyMember)
                        .font(.title2)
                        .padding(.bottom, 8)
                }
                
                Group {
                    HStack {
                        Text("File Name:")
                            .font(.subheadline)
                        Text(record.fileName)
                            .font(.body)
                    }
                    
                    HStack {
                        Text("Date:")
                            .font(.subheadline)
                        Text(record.date.formatted(.dateTime.month().day().year()))
                            .font(.body)
                    }
                    
                    HStack {
                        Text("Type:")
                            .font(.subheadline)
                        Text(record.type)
                            .font(.body)
                    }
                }
                
                if !record.images.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(record.images, id: \.self) { imageURL in
                                NavigationLink(destination: FullImageView(imageURL: imageURL)) {
                                    AsyncImage(url: URL(string: imageURL)) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(10)
                                        } else if phase.error != nil {
                                            Color.red
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(10)
                                        } else {
                                            Color.gray
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                } else {
                    Text("No images available.")
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 12) {
                    Button(action: {
                        if let imageUrl = record.images.first {
                            loadImageAsync(from: imageUrl) { image in
                                if let image = image {
                                    textRecognitionViewModel.recognizeText(from: image) { recognizedText in
                                        self.recognizedText = recognizedText
                                        ttsViewModel.speak(recognizedText)
                                    }
                                }
                            }
                        }
                    }) {
                        Text("Read Text from Image")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue) // Native iOS primary button color

                    Button(action: {
                        ttsViewModel.stopSpeaking()
                    }) {
                        Text("Stop Speaking")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red) // Native iOS destructive button color
                }

                if !recognizedText.isEmpty {
                    Text(recognizedText)
                        .frame(width: 360)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        
                }
            }
            .padding()
        }
        .navigationTitle("Record Details")
    }
    
    private func loadImageAsync(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

struct FullImageView: View {
    var imageURL: String

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else if phase.error != nil {
                    Color.red // Indicates an error.
                } else {
                    Color.gray // Acts as a placeholder.
                }
            }
            .navigationTitle("Full Image")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
