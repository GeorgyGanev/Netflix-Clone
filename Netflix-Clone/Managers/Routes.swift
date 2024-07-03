//
//  Routes.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 29.06.24.
//

import Foundation

struct Constants {
    
    static let API_KEY = "?api_key=a3718f4656bb449b88e6db6bb38c1876"
    static let UTUBE_API_KEY = "AIzaSyCOH7oIL5OW_g6LLLPRb7ZCbOWWRFRc0fE"
    static let mainUrl = "https://api.themoviedb.org/3"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
    static let uTubeBaseUrl = "https://www.googleapis.com/youtube/v3/search"
}

enum Route {
    
    case trandingMovies
    case trendingTv
    case popular
    case upcomingMovies
    case topRated
    case discoverMovies
    case search
    case searchUTube
    
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
        case .searchUTube:
            return "?key="
        }
    }
}

enum Method: String {
    case get = "GET"
    case post = "POST"
}
