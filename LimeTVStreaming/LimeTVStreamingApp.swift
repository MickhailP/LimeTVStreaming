//
//  LimeTVStreamingApp.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import SwiftUI

//Main
    //Model
    //Views
    //ViewModels

//Favorites
    //

//Code-style
    //https://github.com/airbnb/swift#airbnb-swift-style-guide


@main
struct LimeTVStreamingApp: App {
    
    @StateObject var favouritesChannels = Favourites()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(favouritesChannels)
        }
    }
}
