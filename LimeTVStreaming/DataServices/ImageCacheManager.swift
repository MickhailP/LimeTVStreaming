//
//  ImageCacheManager.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 10.12.2022.
//

import Foundation
import UIKit

// меняется диспетчеризация
// скинуть доклад из ВК https://www.youtube.com/watch?v=kolL8r7Tz2w

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init () { }
    
    private var photoCache: NSCache<NSString, UIImage> = {
        var cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 100 //100 MB
        return cache
    }()
    
}

extension ImageCacheManager: ImageStorageProtocol {
    
    func add(key: String, value: UIImage) {
        photoCache.setObject(value, forKey: key as NSString)
    }
    
    func get(key: String) -> UIImage? {
        photoCache.object(forKey: key as NSString)
    }

}
