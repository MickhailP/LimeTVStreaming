//
//  SearchBar.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 03.12.2022.
//

import SwiftUI

struct SearchBar: View {
    
    let placeholderText: String
    @Binding var searchTex: String
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                
            // Search Text field for creating a Request
            TextField(placeholderText, text: $searchTex)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(placeholderText: "Put some text here", searchTex: .constant("Something"))
    }
}

