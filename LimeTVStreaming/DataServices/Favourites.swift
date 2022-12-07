//
//  Favourites.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import Foundation

final class Favourites: ObservableObject {
    
    @Published private var favouritesChannels: Set<Int> = []
   
    @Published var showErrorAlert: Bool = false
    @Published private(set) var errorMessage: String = ""
    
    private let saveKey = "Favourites"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decodedData = try? JSONDecoder().decode(Set<Int>.self, from: data) {
                favouritesChannels = decodedData
                return
            }
        }
        // If decoding fails or favourites is empty
        favouritesChannels = []
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
            UserDefaults.standard.set(encoded, forKey: saveKey)
        } catch  {
            print("Can't encode and save data in database")
            print(error)
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
}
