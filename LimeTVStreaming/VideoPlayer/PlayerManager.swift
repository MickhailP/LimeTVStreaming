//
//  PlayerManager.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 15.01.2023.
//

import Foundation
import AVKit
import M3U8Decoder

protocol PlayerManagerProtocol {
    
    func decodePlaylist(from urlString: String, completionHandler: @escaping ([Stream]?, Error?) -> Void)
    func changeResolution(for video: Video, with newResolution: Resolution, in player: AVPlayer)
}


final class PlayerManager: PlayerManagerProtocol {
    
    // MARK: Decoding methods
    
    /// This method uses M3U8Decoder() from external package to decode m3u8 in MainPlaylist that holds all information about HLS translation from URL
    /// - Parameters:
    ///   - urlString: The URL of m3u8 manifest to decode
    ///   - completionHandler: Completion to handle the result of decoding
    func decodePlaylist(from urlString: String, completionHandler: @escaping ([Stream]?, Error?) -> Void)  {
        
        guard let url = URL(string: urlString) else { fatalError("Missing URL") }
        
        let decoder = M3U8Decoder()
        
        decoder.decode(MainPlaylist.self, from: url) { [weak self] result in
            switch result {
                case let .success(playlist):
                    let streams = self?.createStreams(for: playlist, using: url)
                    completionHandler(streams, nil)
                    
                case let .failure(error):
                    print(error)
                    print(error.localizedDescription)
                    completionHandler(nil, error)
            }
        }
    }
    
    
    ///  Convert MainPlaylist in alternate playlist with different streaming quality and return the Video object that holds name of the channel and array of available streams of translation
    /// - Parameters:
    ///   - playlist: MainPlaylist object
    ///   - url:  The URL off main stream
    ///   - channelName: The name of the Channel
    /// - Returns: The Video object
    private func createStreams(for playlist: MainPlaylist, using url: URL ) -> [Stream] {
        playlist.variantStreams.compactMap { streamInfo in
            
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
    }
    
    
    // MARK: Change resolution methods
    /// Change resolution of streaming
    /// - Parameter newResolution: The new resolution of the video.
    func changeResolution(for video: Video, with newResolution: Resolution, in player: AVPlayer) {
        
        guard let stream = video.streams.first(where: {$0.resolution == newResolution}) else {
            print("Failed to change resolution")
            return
        }
        
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
}
