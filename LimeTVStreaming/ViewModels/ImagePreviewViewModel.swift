//
//  ImagePreviewViewModel.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 03.12.2022.
//

import Foundation
import UIKit

final class ImagePreviewViewModel: ObservableObject {
    
    private let networking: NetworkingProtocol
    private let storageManager: ImageStorageProtocol
    
    // MARK: View initialiser's properties
    let imageURL: String
    let imageKey: String
    
    // MARK: Image State
    @Published private(set) var image: UIImage?
    @Published private(set) var isLoading: Bool = true
    
    // MARK: Error States
    @Published private(set) var showError: Bool = false
    @Published private(set) var errorMessage: String = ""
    
    
    // MARK: Init
    init(imageURL: String, imageKey: Int, networking: NetworkingProtocol = Networking.shared, storageManager: ImageStorageProtocol = ImageCacheManager.shared) {
        self.networking = networking
        self.imageURL = imageURL
        self.imageKey = String(imageKey)
        self.storageManager = storageManager
        getImage()
    }
    
    
    /// Check is Image store in Cache if it is not then the image should be downloaded from Internet
    private func getImage() {
        if let image = storageManager.get(key: imageKey) {
            self.image = image
            print("Getting saved image")
        } else {
            downloadImage()
            print("Downloading image")
        }
    }
    
    /// Download an image by it's URL from the internet and handles a Result
    private func downloadImage() {
        Task {
            let result = await networking.downloadDataResult(from: imageURL)
            
            await MainActor.run{
                switch result {
                    case .success(let imageData):
                        self.image = UIImage(data: imageData)
                        if let image = image {
                            self.storageManager.add(key: self.imageKey, value: image)
                        }
                        isLoading = false
                    case .failure(let error):
                        print(error, error.localizedDescription)
                        showError = true
                        errorMessage = error.localizedDescription
                }
            }
        }
    }
}
