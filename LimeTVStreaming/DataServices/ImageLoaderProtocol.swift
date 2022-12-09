//
//  ImageLoaderProtocol.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 09.12.2022.
//

import Foundation
import UIKit

protocol ImageLoaderProtocol {
    func downloadImage(from imageURLString: String) async -> Result<UIImage?, Error>
}
