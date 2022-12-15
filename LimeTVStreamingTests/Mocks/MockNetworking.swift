//
//  MockNetworking.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 13.12.2022.
//

import Foundation


class MockNetworking: NetworkingProtocol, Mockable {
    
    func downloadDataResult(from urlString: String) async -> Result<Data, Error> {
        loadJSON(filename: "MockChannelsResponse")
    }
    
}
