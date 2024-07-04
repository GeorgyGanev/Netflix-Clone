//
//  APIColler.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 29.06.24.
//

import Foundation

enum ApiError: Error {
    case failedToGetData
    case invalidUrl
}

class APIColler {
    
    static let shared = APIColler()
    private init() {}
    
    func getTrendingMovies(completion: @escaping(Result<[Item], Error>) -> Void) {
        request(route: .trandingMovies, method: .get, completion: completion)
    }
    
    func getTrendingTv(completion: @escaping(Result<[Item], Error>) -> Void) {
        request(route: .trendingTv, method: .get, completion: completion)
    }
    
    func getPopularMovies(completion: @escaping(Result<[Item], Error>) -> Void) {
        request(route: .popular, method: .get, completion: completion)
    }
    
    func getUpcomingMovies(completion: @escaping(Result<[Item], Error>) -> Void) {
        request(route: .upcomingMovies, method: .get, completion: completion)
    }
    
    func getTopRatedMovies(completion: @escaping(Result<[Item], Error>) -> Void) {
        request(route: .topRated, method: .get, completion: completion)
    }
    
    func discoverMovies(completion: @escaping(Result<[Item], Error>) -> Void) {
        request(route: .discoverMovies, method: .get, completion: completion)
    }
    
    func search(query: String, completion: @escaping(Result<[Item], Error>) -> Void) {
        request(route: .search, method: .get, query: query, completion: completion)
    }
    
    
    func getUtubeVideo(query: String, completion: @escaping(Result<VideoSearchResponse, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.uTubeBaseUrl)?key=\(Constants.UTUBE_API_KEY)&q=\(query)") else {
            completion(.failure(ApiError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(ApiError.failedToGetData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(VideoSearchResponse.self, from: data)
                completion(.success(response))
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
    }
        
    private func handleResponse<T: Codable>(result: Result<Data, Error>?, completion: @escaping(Result<T, Error>) -> Void) {
        guard let result = result else {
            completion(.failure(ApiError.failedToGetData))
            return
        }
        
        switch result {
        case .success(let data):
            if let response = try? JSONDecoder().decode(ApiResponse<T>.self, from: data)  {
                completion(.success(response.results))
            } else {
                completion(.failure(ApiError.failedToGetData))
            }
            
        case .failure(_):
            completion(.failure(ApiError.failedToGetData))
        }
    }
    
    private func request<T: Codable>(route: Route, method: Method, query: String? = nil, completion: @escaping(Result<T, Error>) -> Void) {
        
        guard let urlRequest = createUrlRequest(route: route, method: .get, query: query) else {
            completion(.failure(ApiError.invalidUrl))
            return
        }
        
        var result: Result<Data, Error>?
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let data = data {
                result = .success(data)
            } else if let error {
                result = .failure(error)
            }
            
            DispatchQueue.main.async {
                self.handleResponse(result: result, completion: completion)
            }
        }.resume()
            
    }
    
    private func createUrlRequest(route: Route, method: Method, query: String? = nil) -> URLRequest? {
        
        var urlString: String = ""
        
        if let query = query {
                urlString = Constants.mainUrl + route.description + Constants.API_KEY + "&query=\(query)"
        } else {
            urlString = Constants.mainUrl + route.description + Constants.API_KEY
        }
        
        guard let url = URL(string: urlString) else {return nil}
        
        return URLRequest(url: url)
    }
}
