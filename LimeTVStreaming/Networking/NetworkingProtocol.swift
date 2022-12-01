//
//  NetworkingProtocol.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import Foundation

protocol NetworkingProtocol {
    
    func downloadData(from urlString: String) async throws -> Data
    
}
