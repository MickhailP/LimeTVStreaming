//
//  FavouriteButton.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 03.12.2022.
//

import SwiftUI

struct FavouriteButton: View {
    
    let channelID: Int
    
    @EnvironmentObject var favourites: Favourites
    
    var isFavourite: Bool {
        if favourites.contains(channelID) {
            return true
        } else {
           return false
        }
    }
    
    var body: some View {
        Button {
            if isFavourite {
                favourites.deleteFromFavourites(channelID)
            } else {
                favourites.addToFavourites(channelID)
            }
            
        } label: {
            Image(systemName: isFavourite ? "star.fill" : "star")
                .foregroundColor(.blue)
                .font(.title3)
        }
    }
}

struct FavouriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteButton(channelID: 11)
    }
}
