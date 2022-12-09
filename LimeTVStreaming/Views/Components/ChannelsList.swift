//
//  ChannelsList.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 03.12.2022.
//

import SwiftUI

struct ChannelsList: View {
    
    let channels: [Channel]
    @State private var showPlayer: Bool = false
    @State private var selectedChannel: Channel?
    
    
    var body: some View {
        ScrollView {
            ForEach(channels) { channel in
                ChannelRowView(channel: channel) {
                    showPlayer = true
                    selectedChannel = channel
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .fullScreenCover(item: $selectedChannel, content: { channel in
                VideoView(channel: channel)
            })   
        }
    }
}

struct ChannelsList_Previews: PreviewProvider {
    static let favouritesChannels = Favourites()
    
    static var previews: some View {
        ChannelsList(channels: [Channel.example, Channel.example])
            .environmentObject(favouritesChannels)
    }
}
