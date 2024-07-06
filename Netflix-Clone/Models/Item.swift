//
//  Movie.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 29.06.24.
//

import Foundation

//struct TrendingMoviesResponse: Codable {
//    let results: [Movie]
//}

struct Item: Codable {
    let id: Int
    let title, name, original_title, original_name, overview, media_type, poster_path, release_date: String?
    let vote_count: Int?
    let vote_average: Double?
}
