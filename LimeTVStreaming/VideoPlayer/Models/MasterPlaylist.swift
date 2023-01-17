//
//  MasterPlaylist.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 04.12.2022.
//

import Foundation
import M3U8Decoder


struct MainPlaylist: Decodable {
    let extm3u: Bool
    let version: Int?
    let independentSegments: Bool?
    let media: [EXT_X_MEDIA]?
    let streamInf: [EXT_X_STREAM_INF]
    let frameStreamInf: [EXT_X_I_FRAME_STREAM_INF]?
    let uri: [String]

    var variantStreams: [(inf: EXT_X_STREAM_INF, uri: String)] {
        Array(zip(streamInf, uri))
    }
    
    enum CodingKeys: String, CodingKey {
        case extm3u
        case version = "ext_x_version"
        case independentSegments = "ext_x_independent_segments"
        case media = "ext_x_media"
        case streamInf = "ext_x_stream_inf"
        case frameStreamInf = "ext_x_i_frame_stream_inf"
        case uri
    }
}
