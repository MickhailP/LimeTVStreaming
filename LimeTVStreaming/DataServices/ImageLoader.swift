//
//  ImageLoader.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import Foundation
import UIKit

actor ImageLoaderActor: ImageLoaderProtocol  {
    
    static let shared = ImageLoaderActor()
    
    private init() { }
    
    private let networkingService = Networking()
    
    
    func downloadImage(from imageURLString: String) async -> Result<UIImage?, Error> {
        
        do {
            let imageData = try await networkingService.downloadData(from: imageURLString)
            
            return .success(UIImage(data: imageData))
            
        } catch {
            print("Error occurs during downloading Image")
            return .failure(error)
        }
    }
}


