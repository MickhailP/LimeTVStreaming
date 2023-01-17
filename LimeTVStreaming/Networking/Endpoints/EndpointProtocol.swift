//
//  EndpointProtocol.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 14.01.2023.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    
    var url: URL? { get }
}


