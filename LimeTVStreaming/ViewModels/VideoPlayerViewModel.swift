//
//  VideoPlayerViewModel.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 04.12.2022.
//

import Foundation
import AVKit
import Combine
import M3U8Decoder

final class VideoPlayerViewModel: ObservableObject {
    
    
    // MARK: View properties
    @Published var selectedResolution: Resolution?
    @Published var player = AVPlayer()
    
    
    var availableResolutions: [Resolution] {
        if let video = self.video {
            return video.streams.compactMap({ stream in
                stream.resolution
            })
        } else {
            return []
        }
    }
    
    // MARK: Media properties
    private let channel: Channel
    @Published private var video: Video?
    
    // MARK: Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: Init
    init(channel: Channel) {
        self.channel = channel
        
        decodePlaylist(from: channel.url) { [weak self] playlist, url in
            let video = self?.decodeStreams(from: playlist, mainURL: url, channelName: channel.nameRu)
            DispatchQueue.main.async {
                self?.video = video
            }
        }
        addResolutionSubscriber()
    }
    
    
    // MARK: Playback controls methods
    /// Unwrap the URL of the streaming, creates a  AVPlayer instance and start playing the video.
    func startStreaming() {
        if let url = URL(string: channel.url) {
            player = AVPlayer(url: url)
            player.play()
            print(url)
            print("Player should work")
        }
    }
    
    // MARK: Change resolution methods
    /// Change resolution of streaming
    /// - Parameter newResolution: The new resolution of the video.
    private func changeResolution(with newResolution: Resolution) {
        
        guard let stream = video?.streams.first(where: {$0.resolution == newResolution}) else {
            print("Failed to change resolution")
            return
        }
        print("STREAM\n", stream)
        
        let currentTime: CMTime
        if let currentItem = player.currentItem {
            currentTime = currentItem.currentTime()
        } else {
            currentTime = .zero
        }
        
        player.replaceCurrentItem(with: AVPlayerItem(url: stream.streamURL))
        player.seek(to: currentTime, toleranceBefore: .zero, toleranceAfter: .zero)
        player.play()
        
        print("Resolution changed")
        
    }
    
    
    /// Subscribes on Resolution publisher, changes the current resolution of video streaming.
    private func addResolutionSubscriber() {
        $selectedResolution
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: ({ [weak self] resolution in
                guard let self = self, let resolution = resolution else { return }
                self.changeResolution(with: resolution)
                
            }))
            .store(in: &cancellables)
        
    }
    
    // MARK: Decoding methods
    
    /// This method uses M3U8Decoder() from external package to decode m3u8 in MainPlaylist that holds all information about HLS translation from URL
    /// - Parameters:
    ///   - urlString: The URL of m3u8 manifest to decode
    ///   - completionHandler: Completion to handle the result of decoding
    private func decodePlaylist(from urlString: String, completionHandler: @escaping (MainPlaylist, URL) -> Void ) {
        
        guard let url = URL(string: urlString) else { fatalError("Missing URL") }
        
        let decoder = M3U8Decoder()
        
        decoder.decode(MainPlaylist.self, from: url) { result in
            switch result {
                case let .success(playlist):
                    completionHandler(playlist, url)
                    
                case let .failure(error):
                    print(error)
                    print(error.localizedDescription)
            }
        }
    }
    
    
    ///  Convert MainPlaylist in alternate playlist with different streaming quality and return the Video object that holds name of the channel and array of available streams of translation
    /// - Parameters:
    ///   - playlist: MainPlaylist object
    ///   - url:  The URL off main stream
    ///   - channelName: The name of the Channel
    /// - Returns: The Video object
    private func decodeStreams(from playlist: MainPlaylist, mainURL url: URL, channelName: String) -> Video {
        
        let streams = playlist.variantStreams.compactMap { streamInfo in
            
            guard let newURL = URL(string: streamInfo.uri, relativeTo: url) else {
                fatalError("Missing URL")
            }
            
            // Create a Stream based on the height of the video
            switch streamInfo.inf.resolution?.height {
                case 240:
                    return Stream(resolution: .p240, streamURL: newURL )
                case 360:
                    return Stream(resolution: .p360, streamURL: newURL )
                case 480:
                    return Stream(resolution: .p480, streamURL: newURL )
                case 576:
                    return Stream(resolution: .p576, streamURL: newURL )
                case 720:
                    return Stream(resolution: .p720, streamURL: newURL )
                case 1080:
                    return Stream(resolution: .p1080, streamURL: newURL )
                default:
                    return Stream(resolution: nil, streamURL: url)
            }
        }
        return Video(name: channelName, streams: streams)
    }
}
