//
//  NetworkingProtocol.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import Foundation

protocol NetworkingProtocol {
    func downloadDataResult(from url: URL?) async -> Result<Data,Error>
}
