//
//  ChannelsViewViewModel.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import Foundation

final class ChannelsViewViewModel: ObservableObject {
    
    // MARK: Favourites database
    private let favourites: Favourites
    
    // MARK: Categories
    let tabItemsCategory: [Categories] = Categories.allCases //[.all, .favourites]
    @Published var selectedCategory: Categories = .all
    
    // MARK: Data
    // Use this property to get access to filtered channels based on search result and Category of channels
    var filteredChannels: [Channel] {
        if searchableChannel.isEmpty {
            return selectedChannels
        } else {
            return selectedChannels.filter { $0.nameRu.localizedCaseInsensitiveContains(searchableChannel) }
        }
    }
    
    // Channels based on selected Category
    private var selectedChannels: [Channel] {
        switch selectedCategory {
            case .all:
                return channels
            case .favourites:
                return channels.filter { favourites.contains($0.id) }
        }
    }
    // All channels fetched from server
    @Published private(set) var channels: [Channel] = []
    
    
    // MARK: Alert tracker
    @Published var showErrorMessage: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: Searching text
    @Published var searchableChannel: String = ""
    
    // MARK: Networking layer
    private let networkingService: NetworkingProtocol
    private let urlString: String = "https://limehd.online/playlist/channels.json"
    
    
    // MARK: Init
    init(networkingService: NetworkingProtocol = Networking.shared, favourites: Favourites) {
        self.networkingService = networkingService
        self.favourites = favourites
        requestChannels()
    }
    
    // MARK: Methods
    /// Use this method to request channels from server in synchronous environment
    private func requestChannels() {
        Task {
            await fetchData(from: urlString)
        }
    }
    
    // Create an asynchronous request for data through Networking service and decode received data.
    //
    /// If  fetching or decoding data has been failed, it will throw an error and show alert to user.
    /// - Parameter url: URL request to API
    private func fetchData(from url: String) async {
    
        let result = await networkingService.downloadDataResult(from: url)
        
        switch result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let decodedResponse = try decoder.decode(ChannelsModel.self, from: data)
                    await MainActor.run(body: {
                        channels = decodedResponse.channels
                    })
                    
                } catch  {
                    await MainActor.run(body: {
                        print(error)
                        print("Error occurred during decoding data", error.localizedDescription)
                        errorMessage = "Error occurred during decoding data" + error.localizedDescription
                        showErrorMessage = true
                    })
                }
                
            case .failure(let error):
                await MainActor.run(body: {
                    print(error)
                    print("Error occurred during fetching data", error.localizedDescription)
                    errorMessage = "Error occurred during fetching data" + error.localizedDescription
                    showErrorMessage = true
                })
        }
    }
}
