//
//  Endpoint.swift
//  Movve-SwiftUI
//
//  Created by Petar Glusac on 12.11.22..
//

import Foundation

public enum Endpoint {
    case multiSearch(query: String, page: Int)
    case popular
    
    public var url: URL? {
        var urlString: String
        
        switch self {
        case .multiSearch(let query, let page): urlString = "\(baseUrl)/search/multi?query=\(query)&page=\(page)"
        case .popular: urlString = "\(baseUrl)/movie/popular"
        }
        
        urlString = urlString.replacingOccurrences(of: " ", with: "%20")
        urlString.contains("?") ? urlString.append("&api_key=\(apiKey)") : urlString.append("?api_key=\(apiKey)")
        
        return URL(string: urlString)
    }
    
    private var baseUrl: String {
        return "https://api.themoviedb.org/3"
    }
    
    private var apiKey: String {
        return "b00dc2e39fd4cc23884c5735882d65a8"
    }
}
