//
//  ChannelsView.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import SwiftUI

struct ChannelsView: View {
    
    @StateObject private var viewModel: ChannelsViewViewModel
    
    init(favourites: Favourites) {
        _viewModel = StateObject(wrappedValue: ChannelsViewViewModel(favourites: favourites))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(placeholderText: "Напишите название телеканала", searchTex: $viewModel.searchableChannel)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.4))
            CategoriesTabView(viewModel: viewModel)
        }
        .alert(isPresented: $viewModel.showErrorMessage) {
            Alert(title: Text("Oops."), message: Text(viewModel.errorMessage))
        }
    }
}

struct ChannelsView_Previews: PreviewProvider {
    
    static let favouritesChannels = Favourites()
    
    static var previews: some View {
        ChannelsView(favourites: Favourites())
            .environmentObject(favouritesChannels)
            .preferredColorScheme(.dark)
        
    }
}
