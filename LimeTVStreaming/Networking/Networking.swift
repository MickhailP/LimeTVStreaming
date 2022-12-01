//
//  Networking.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import Foundation

final class Networking: NetworkingProtocol {
    
    let urlString: String = "https://limehd.online/playlist/channels.json"
    
    func downloadData(from urlString: String) async throws -> Data {
        
        // Convert urlString to URL.
        guard let url = URL(string: urlString) else {
            print("Failed to convert URLString")
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            try handleResponse(response)

            print(data)
            return data
        } catch {
            print(error)
            print("There was an error during data fetching! ", error.localizedDescription)
            throw error
        }
    }
    
    /// Check if URLResponse have good status code, if it's not, it will throw an error
    /// - Parameter response: URLResponse from dataTask
    private func handleResponse(_ response: URLResponse) throws {
        
        guard
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode <= 300
        else {
            throw URLError(.badServerResponse)
        }
    }
    
    
}
