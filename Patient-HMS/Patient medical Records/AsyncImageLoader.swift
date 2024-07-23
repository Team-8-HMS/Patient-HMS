//
//  AsyncImageLoader.swift
//  Patient-HMS
//
//  Created by Dhairya bhardwaj on 15/07/24.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    private var cancellable: AnyCancellable?

    func loadImage(from url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: imageURL)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    deinit {
        cancellable?.cancel()
    }
}

struct AsyncImageLoader: View {
    @StateObject private var loader = ImageLoader()
    let url: String

    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            Color.gray
        }
    }

    init(url: String) {
        self.url = url
        _loader = StateObject(wrappedValue: ImageLoader())
        loader.loadImage(from: url)
    }
}
