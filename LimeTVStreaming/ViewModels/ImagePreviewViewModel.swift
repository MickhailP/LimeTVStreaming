//
//  ImagePreviewViewModel.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 03.12.2022.
//

import Foundation
import UIKit

final class ImagePreviewViewModel: ObservableObject {
    
    private let loader = ImageLoaderActor.shared
    
    // MARK: View initialiser's properties
    private let imageURL: String

    
    // MARK: Image State
    @Published private(set) var image: UIImage?
    
    // MARK: Error States
    @Published private(set) var showError: Bool = false
    @Published private(set) var errorMessage: String = ""
    
    // MARK: Init
    init(imageURL: String) {
        self.imageURL = imageURL
        getImage()
    }
    
    private func getImage() {
        Task {
            let result = await loader.downloadImage(from: imageURL)
            
            await MainActor.run{
                switch result {
                    case .success(let image):
                        self.image = image
                    case .failure(let error):
                        print(error, error.localizedDescription)
                        showError = true
                        errorMessage = error.localizedDescription
                }
            }
        }
    }
}
