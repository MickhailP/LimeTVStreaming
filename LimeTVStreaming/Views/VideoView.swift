//
//  VideoView.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 04.12.2022.
//

import SwiftUI
import AVKit
import AVFoundation


struct VideoView: View {
    
    @StateObject var viewModel: VideoPlayerViewModel
    
    // MARK: Init
    init(channel: Channel) {
        _viewModel = StateObject(wrappedValue: VideoPlayerViewModel(channel: channel))
    }
    
    var body: some View {
        ZStack{
            VStack {
                Button("Change resolution") {
                    withAnimation {
                        viewModel.showResolutions.toggle()
                    }
                }
                .padding(5)
                .font(Font.body.bold())
                .buttonStyle(.plain)
                
                VideoPlayer(player: viewModel.player)
                    .ignoresSafeArea(.all)
                    .onAppear {
                        viewModel.startStreaming()
                    }
            }
            // Change Resolution Button
            if viewModel.showResolutions {
                changeResolutionButton
            }
        }
    }
}
extension VideoView {
    var changeResolutionButton: some View {
        VStack(spacing: 20) {
            Spacer()
            ForEach(Resolution.allCases) { resolution in
                
                Button(resolution.displayValue, action: {
                    withAnimation {
                        viewModel.selectedResolution = resolution
                        viewModel.showResolutions.toggle()
                    }
                })
            }
            Button(action: {
                withAnimation {
                    viewModel.showResolutions.toggle()
                }
            }, label: {
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
            })
            .padding(.top)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .transition(.move(edge: .bottom))
    }
}

struct VIideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(channel: Channel.example)
    }
}
