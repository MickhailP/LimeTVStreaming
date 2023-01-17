//
//  InfoSection.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 03.12.2022.
//

import SwiftUI

struct InfoSection: View {
    
    let title:String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.callout)
        }
    }
}

struct InfoSection_Previews: PreviewProvider {
    static var previews: some View {
        InfoSection(title: "THT", description: "Music time")
    }
}
