//
//  ContentView.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import SwiftUI

struct ContentView: View {
    
    let networking: NetworkingProtocol
    @EnvironmentObject var favourites: Favourites
    
    var body: some View {
        ChannelsView(networking: networking, favourites: favourites)
            .alert(isPresented: $favourites.showErrorAlert) {
                Alert(title: Text("Database error"), message: Text(favourites.errorMessage))
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static let favouritesChannels = Favourites()
    
    static var previews: some View {
        ContentView(networking: Networking())
            .environmentObject(favouritesChannels)
    }
}
