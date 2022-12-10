//
//  LimeTVStreamingApp.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import SwiftUI

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
