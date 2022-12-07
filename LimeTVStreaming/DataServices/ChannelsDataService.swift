//
//  ChannelsDataService.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 02.12.2022.
//

import Foundation


class ChannelsDataService: ObservableObject {
    
    // MARK: Data storage
    @Published private(set) var channels: [Channel] = []

    
    // MARK: Networking layer
    let networkingService: NetworkingProtocol
    let urlString: String = "https://limehd.online/playlist/channels.json"
    
    // MARK: Init
    init(networkingService: NetworkingProtocol) {
        self.networkingService = networkingService
    }
    
    
    // MARK: Fetching data methods
    func requestChannels() {
        Task {
             await fetchData(from: urlString)
        }
    }
    
    // Create an asynchronous request for data through Networking service and decode received  data.
    ///
    /// If  fetching or decoding data has been failed, it will throw an error and show alert to user.
    /// - Parameter url: URL request to API
    private func fetchData(from url: String) async {

        do {
            let fetchedData = try await networkingService.downloadData(from: url)

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let decodedResponse = try decoder.decode(ChannelsModel.self, from: fetchedData)

            await MainActor.run(body: {
                channels = decodedResponse.channels
            })

        } catch  {
            await MainActor.run(body: {
                print(error)
                print("Error occurred during fetching data", error.localizedDescription)
            })
        }
    }
}
