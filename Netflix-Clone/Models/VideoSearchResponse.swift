//
//  VideoSearchResponse.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 3.07.24.
//

import Foundation


struct VideoSearchResponse: Codable {
    let items: [VideoItem]
}

struct VideoItem: Codable {
    let id: VideoId
}

struct VideoId: Codable {
    let videoId: String?
}
