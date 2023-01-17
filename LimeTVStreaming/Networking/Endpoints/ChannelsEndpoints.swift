//
//  ChannelsEndpoints.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 17.01.2023.
//

import Foundation

extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "limehd.online"
    }
}

enum ChannelsEndpoints {
    case allChannels
}

extension ChannelsEndpoints: Endpoint {
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = path
        
        return components.url
    }
    
    var path: String {
        switch self {
            case .allChannels:
                return "/playlist/channels.json"
        }
    }
}
