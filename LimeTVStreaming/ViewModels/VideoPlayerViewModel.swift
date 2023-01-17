//
//  VideoPlayerViewModel.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 04.12.2022.
//

import Foundation
import AVKit
import Combine

final class VideoPlayerViewModel: ObservableObject {
    
    // MARK: - Dependencies
    let playerManager: PlayerManagerProtocol
    private let channel: Channel
    
    // MARK: View properties
    var availableResolutions: [Resolution] {
        if let video = self.video {
            return video.streams.compactMap{ stream in
                stream.resolution
            }
        } else {
            return []
        }
    }
    @Published var selectedResolution: Resolution?
    
    // MARK: Error handling
    @Published var errorMessage = ""
    
    // MARK: Media properties
    @Published var player = AVPlayer()
    @Published private var video: Video?
    
    // MARK: Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: Init
    init(channel: Channel, playerManager: PlayerManagerProtocol) {
        self.channel = channel
        self.playerManager = playerManager
        getVideo(from: channel)
        addResolutionSubscriber()
    }
    
    private func getVideo(from channel: Channel) {
        playerManager.decodePlaylist(from: channel.url) { [weak self] streams, error in
            if let streams {
                self?.video = Video(name: channel.nameRu, streams: streams)
            }
            if let error {
                DispatchQueue.main.async {                    self?.errorMessage = ("THERE WAS AN ERROR: ") + error.localizedDescription
                }
            }
        }
    }
    
    /// Subscribes on Resolution publisher, changes the current resolution of video streaming.
    private func addResolutionSubscriber() {
        $selectedResolution
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: ({ [weak self] resolution in
                
                guard let self = self,
                      let resolution = resolution,
                      let video = self.video
                else {
                    return
                }
                
                self.playerManager.changeResolution(for: video, with: resolution, in: self.player)
                
            }))
            .store(in: &cancellables)
    }
    
    // MARK: Playback controls methods
    /// Unwrap the URL of the streaming, creates a  AVPlayer instance and start playing the video.
    func startStreaming() {
        
        guard let url = URL(string: channel.url) else { return }
        
        player = AVPlayer(url: url)
        player.play()
        print(url)
        print("Player should work")
    }
}
