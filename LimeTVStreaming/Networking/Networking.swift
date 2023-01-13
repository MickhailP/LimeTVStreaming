//
//  Networking.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import Foundation

//enum CustomError: Error {
//    case badURL
//
//    var alertDescription: String {
//        switch self {
//        case .badURL:
//            "descri"
//        }
//    }
//
//}

//https://github.com/Swinject/Swinject
//https://github.com/Tinkoff/EasyDi

//https://betterprogramming.pub/async-await-generic-network-layer-with-swift-5-5-2bdd51224ea9

//protocol Endpoint {
//    var httpMethod: Method { get }
//}
//enum Endpoints: Endpoint {
//    case events
//    case eventDetails(id: String)
//    
//    var httpMethod: Method {
//        switch self {
//        case .events:
//            .get
//        case .eventDetails:
//            .post
//        }
//    }
//    
//}

actor Networking: NetworkingProtocol {
    
    static let shared = Networking()
    
    //handlingError
    //handlingResponse
    //Data -> T.self
    
    private init() { }
    
    func downloadDataResult(from urlString: String) async -> Result<Data,Error> {
        
        // Convert urlString to URL.
        guard let url = URL(string: urlString) else {
            print("Failed to convert URLString")
            return .failure( URLError(.badURL))
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            try handleResponse(response)

            print(data)
            return .success(data)
        } catch {
            print(error)
            print("There was an error during data fetching! ", error.localizedDescription)
            return .failure(error)
        }
    }
    
    /// Check if URLResponse have good status code, if it's not, it will throw an error
    /// - Parameter response: URLResponse from dataTask
    private func handleResponse(_ response: URLResponse) throws {
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkingError.badURLResponse
        }
        if  response.statusCode >= 200 && response.statusCode <= 300 {
            return
        } else {
            throw NetworkingError.error(response.statusCode)
        }
    }
}
