//
//  ChannelRowView.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import SwiftUI

struct ChannelRowView: View {
    
    
    let channel: Channel
    
    let action: () -> Void
    
    init(channel: Channel, action: @escaping () -> Void) {
        self.channel = channel
        self.action = action
    }
    
    // MARK: View
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                ImagePreview(frameSize: 75, imageURL: channel.image, imageKey: channel.id)
                InfoSection(title: channel.nameRu, description: channel.current.title)
                
                Spacer()
                
                FavouriteButton(channelID: channel.id)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct ChannelRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelRowView(channel: Channel.example) {
            
        }
    }
}
