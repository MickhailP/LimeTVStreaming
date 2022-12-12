//
//  ImageCacheManager.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 10.12.2022.
//

import Foundation
import UIKit

final class ImageCacheManager: ImageStorageManagerProtocol {
    static let shared = ImageCacheManager()
    private init () { }
    
    var photoCache: NSCache<NSString, UIImage> = {
        var cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 100 //100 MB
        return cache
    }()
    
    func add(key: String, value: UIImage) {
        photoCache.setObject(value, forKey: key as NSString)
    }
    
    func get(key: String) -> UIImage? {
        return photoCache.object(forKey: key as NSString)
    }
}
