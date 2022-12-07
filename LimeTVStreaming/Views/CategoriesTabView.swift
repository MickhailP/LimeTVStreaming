//
//  CategoriesTabView.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 03.12.2022.
//

import SwiftUI

struct CategoriesTabView: View {
    
//    @State var currentTab: Int = 0
    @Namespace var namespace
    
    @ObservedObject var viewModel: ChannelsViewViewModel
    
    let tabItemsName: [String] = ["Все", "Избранные"]
    
    
    var body: some View {
        VStack(spacing: 0){
            
            tabBarView
            
            TabView(selection: $viewModel.selectedCategory) {
                // All channels
                ChannelsList(channels: viewModel.filteredChannels).tag(Categories.all)
                // Favourite channels
                ChannelsList(channels: viewModel.filteredChannels).tag(Categories.favourites)
            }
            .ignoresSafeArea(.all)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

extension CategoriesTabView {
    
    var tabBarView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(Array(zip(viewModel.tabItemsCategory.indices, viewModel.tabItemsCategory)), id: \.0) { index, category in
                    tabBarItem(tabName: category.rawValue, tabIndex: index, category: category)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 5)
        .background(Color.gray.opacity(0.4))
    }
    
   private func tabBarItem(tabName: String, tabIndex: Int, category: Categories) -> some View {
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
                        .matchedGeometryEffect(id: "underline", in: namespace, properties:  .frame).animation(.spring(), value: viewModel.selectedCategory)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct CategoriesTabView_Previews: PreviewProvider {
    static let favouritesChannels = Favourites()
    
    static var previews: some View {
        CategoriesTabView(viewModel: ChannelsViewViewModel(networkingService: Networking(), favourites: Favourites()))
            .environmentObject(favouritesChannels)
    }
}

