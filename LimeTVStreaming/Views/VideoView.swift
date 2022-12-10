//
//  VideoView.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 04.12.2022.
//

import SwiftUI
import AVKit


struct VideoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: VideoPlayerViewModel
    
    // MARK: Init
    init(channel: Channel) {
        _viewModel = StateObject(wrappedValue: VideoPlayerViewModel(channel: channel))
    }
    
    var body: some View {
        ZStack{
            VideoPlayer(player: viewModel.player)
                .ignoresSafeArea(.all)
                .onAppear {
                    viewModel.startStreaming()
                }
            
            
            // Change Resolution Button
            if viewModel.showResolutions {
                changeResolutionButton
            }
        }
        .overlay(alignment: .topLeading) {
            customPlaybackControls
        }
    }
}
extension VideoView {
    var changeResolutionButton: some View {
        VStack(spacing: 20) {
            Spacer()
            ForEach(viewModel.availableResolutions) { resolution in
                
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
    
    var customPlaybackControls: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation {
                    dismiss()
                }
            } label: {
                Image(systemName: "xmark.circle")
                    .padding(8)
            }
            
            Divider()
            
            Button {
                withAnimation {
                    viewModel.showResolutions.toggle()
                }
            } label: {
                Image(systemName: "slider.horizontal.2.square.on.square")
                    .padding(8)
            }
        }
        .buttonStyle(.plain)
        .frame(maxHeight: 30)
        .background(.gray.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
        .padding()
    }
}

struct VIideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(channel: Channel.example)
    }
}
