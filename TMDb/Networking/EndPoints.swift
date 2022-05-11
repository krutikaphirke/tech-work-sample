//
//  EndPoints.swift
//  TMDb
//
//  Created by Krutika on 2022-05-06.
//

import Foundation
struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
    
}
extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
}

extension Endpoint {
    static let apiKey = URLQueryItem(
        name: "api_key",
        value: "25ad4454e7e7938c8720dffbd06f4177")
    static var popular: Self {
        Endpoint(path: "movie/popular",queryItems: [apiKey])
    }
    static var topRated: Self {
        Endpoint(path: "movie/top_rated",queryItems: [apiKey])
    }
    static func detailMovie(_ id: Int) -> Self{

        return Endpoint(path: "movie/" + "\(id)" ,queryItems: [apiKey])
    }
    
}
