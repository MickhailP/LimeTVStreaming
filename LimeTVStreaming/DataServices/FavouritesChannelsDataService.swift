//
//  FavouritesChannelsDataService.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import Foundation

final class FavouritesChannelsDataService: ObservableObject {
    
    @Published var favouritesChannels: Set<Int> = []
    
    @Published var showErrorAlert: Bool = false
    @Published private(set) var errorMessage: String = ""
    
    private let saveKey = UserDefaults.SaveKeys.favouritesChannels
    
    init(userDefaultsContainer: UserDefaults = UserDefaults.standard) {
        self.favouritesChannels = getAlObjects(from: userDefaultsContainer)
    }
    
    func getAlObjects(from userDefaults: UserDefaults) -> Set<Int> {
        if let data = userDefaults.data(forKey: saveKey.rawValue) {
            if let decodedData = try? JSONDecoder().decode(Set<Int>.self, from: data) {
                return decodedData
            }
        }
        // If decoding fails or favourites is empty
        return []
    }
    
    func contains(_ channelID: Int) -> Bool {
        favouritesChannels.contains(channelID)
    }
    
    func addToFavourites(_ channelID: Int) {
        favouritesChannels.insert(channelID)
        save()
    }
    
    func deleteFromFavourites(_ channelID: Int) {
        favouritesChannels.remove(channelID)
        save()
    }
    
    private func save()  {
        do {
            let encoded = try JSONEncoder().encode(favouritesChannels)
            UserDefaults.standard.set(encoded, forKey: saveKey.rawValue)
            
        } catch  {
            print("Can't encode and save data in database")
            print(error)
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
}
