//
//  Routes.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 29.06.24.
//

import Foundation

struct Constants {
    
    static let API_KEY = "?api_key=dd4e9a76dbd313f1a0d2e3a37c59f6e6"
    static let mainUrl = "https://api.themoviedb.org/3"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
}

enum Route {
    
    case trandingMovies
    case trendingTv
    case popular
    case upcomingMovies
    case topRated
    case discoverMovies
    case search
    
    var description: String {
        switch self {
        case .trandingMovies:
            return "/trending/movie/day"
        case .trendingTv:
            return "/trending/tv/day"
        case .popular:
            return "/movie/popular"
        case .upcomingMovies:
            return "/movie/upcoming"
        case .topRated:
            return "/movie/top_rated"
        case .discoverMovies:
            return "/discover/movie"
        case .search:
            return "/search/movie"
        }
    }
}

enum Method: String {
    case get = "GET"
    case post = "POST"
}
