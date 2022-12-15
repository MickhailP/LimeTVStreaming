//
//  ImageStorageProtocol.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 09.12.2022.
//

import Foundation
import UIKit

protocol ImageStorageProtocol {
    func add(key: String, value: UIImage)
    func get(key: String) -> UIImage?
}
