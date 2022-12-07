//
//  ImagePreview.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import SwiftUI

struct ImagePreview: View {

    private let frameSize: CGFloat
    
    @StateObject private var viewModel: ImagePreviewViewModel
    
    // MARK: Init
    init(frameSize: CGFloat, imageURL: String) {
        self.frameSize = frameSize
        _viewModel = StateObject(wrappedValue: ImagePreviewViewModel(imageURL: imageURL))
    }
    
    // MARK: View
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            } else {
                ProgressView()
            }
        }
        .frame(width: frameSize, height: frameSize)
    }
}

// MARK: Preview
struct ImagePreview_Previews: PreviewProvider {
    static var previews: some View {
        ImagePreview(frameSize: 75, imageURL: Channel.example.image)
    }
}
