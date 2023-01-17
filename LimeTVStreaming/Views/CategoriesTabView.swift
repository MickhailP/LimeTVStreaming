//
//  CategoriesTabView.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 03.12.2022.
//

import SwiftUI

struct CategoriesTabView: View {
    
    @Namespace var namespace
    
    @ObservedObject var viewModel: ChannelsViewViewModel
    
    let tabItemsName: [String] = ["Все", "Избранные"]
    
    
    var body: some View {
        VStack(spacing: 0){
            
            tabBarView
            
            TabView(selection: $viewModel.selectedCategory) {
                // All channels
                ChannelsList(channels: viewModel.filteredChannels)
                    .tag(Categories.all)
                // Favourite channels
                ChannelsList(channels: viewModel.filteredChannels)
                    .tag(Categories.favourites)
            }
            .ignoresSafeArea(.all)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

extension CategoriesTabView {
    
    private var tabBarView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(viewModel.tabItemsCategory, id: \.self) {category in
                    tabBarItem(tabName: category.rawValue, category: category)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 5)
        .background(Color.gray.opacity(0.4))
    }
    
    /// Creates an item for a custom Tab bar as a button.
    /// - Parameters:
    ///   - tabName: Displayed name of the item
    ///   - category: The Category  compares with selected Category in View Model of CategoriesTabView to indicate selected category by creating an underlying bar.
    /// - Returns: Button View
   private func tabBarItem(tabName: String, category: Categories) -> some View {
        Button {
            withAnimation(.spring()){
                viewModel.selectedCategory = category
            }
        } label: {
            VStack{
                Text(tabName)
                
                if viewModel.selectedCategory == category {
                    Color.blue
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties:  .frame)
                        .animation(.spring(), value: viewModel.selectedCategory)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct CategoriesTabView_Previews: PreviewProvider {
    static let favouritesChannels = FavouritesChannelsDataService()
    
    static var previews: some View {
        CategoriesTabView(viewModel: ChannelsViewViewModel(networkingService: Networking.shared, favourites: FavouritesChannelsDataService()))
            .environmentObject(favouritesChannels)
    }
}

