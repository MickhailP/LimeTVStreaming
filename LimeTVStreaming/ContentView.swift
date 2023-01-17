//
//  ContentView.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var favourites: FavouritesChannelsDataService

    var body: some View {
        ChannelsView(favourites: favourites)
            .alert(isPresented: $favourites.showErrorAlert) {
                Alert(title: Text("Database error"), message: Text(favourites.errorMessage))
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static let favouritesChannels = FavouritesChannelsDataService()
    
    static var previews: some View {
        ContentView()
            .environmentObject(favouritesChannels)
    }
}
