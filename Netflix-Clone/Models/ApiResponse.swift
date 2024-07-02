//
//  ApiResponse.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 29.06.24.
//

import Foundation

struct ApiResponse<T:Codable>: Codable {
    let results: T
}
