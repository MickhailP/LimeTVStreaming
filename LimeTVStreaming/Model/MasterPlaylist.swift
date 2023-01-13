//
//  MasterPlaylist.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 04.12.2022.
//

import Foundation
import M3U8Decoder


struct MainPlaylist: Decodable {
    //
//    enum CodingKey: String {
//        case version = "ext_x_version"
//        JSONDecoder.init().convertToSnakeCase
//    }
    
    let version: Int?
    
    let extm3u: Bool
    let ext_x_version: Int?
    let ext_x_independent_segments: Bool?
    let ext_x_media: [EXT_X_MEDIA]?
    let ext_x_stream_inf: [EXT_X_STREAM_INF]
    let ext_x_i_frame_stream_inf: [EXT_X_I_FRAME_STREAM_INF]?
    let uri: [String]

    var variantStreams: [(inf: EXT_X_STREAM_INF, uri: String)] {
        Array(zip(ext_x_stream_inf, uri))
    }
}
