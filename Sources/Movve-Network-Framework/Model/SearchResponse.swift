//
//  SearchResponse.swift
//  Movve-SwiftUI
//
//  Created by Petar Glusac on 12.11.22..
//

import Foundation

struct SearchResponse: Decodable {
    let page: Int
    let results: [SearchElementResponse]
}

struct SearchElementResponse: Decodable {
    let id: Int?
    let mediaType: String?
    let title: String?
    let releaseDate: String?
    let posterPath: String?
    let backdropPath: String?

    private enum MovieKeys: String, CodingKey {
        case id
        case mediaType
        case title
        case releaseDate
        case posterPath
        case backdropPath
    }
    
    private enum TVShowKeys: String, CodingKey {
        case id
        case mediaType
        case title = "name"
        case releaseDate = "firstAirDate"
        case posterPath
        case backdropPath
    }
    
    private enum PersonKeys: String, CodingKey {
        case mediaType
    }
    
    init(from decoder: Decoder) throws {
        let personValues = try decoder.container(keyedBy: PersonKeys.self)
        if let mediaType = try personValues.decodeIfPresent(String.self, forKey: .mediaType), mediaType == "person" {
            self.id = nil
            self.mediaType = mediaType
            self.title = nil
            self.releaseDate = nil
            self.posterPath = nil
            self.backdropPath = nil
            return
        }
        let movieValues = try decoder.container(keyedBy: MovieKeys.self)
        if let mediaType = try personValues.decodeIfPresent(String.self, forKey: .mediaType), mediaType == "movie" {
            self.id = try movieValues.decodeIfPresent(Int.self, forKey: .id)
            self.mediaType = mediaType
            self.title = try movieValues.decodeIfPresent(String.self, forKey: .title)
            self.releaseDate = try movieValues.decodeIfPresent(String.self, forKey: .releaseDate)
            self.posterPath = try movieValues.decodeIfPresent(String.self, forKey: .posterPath)
            self.backdropPath = try movieValues.decodeIfPresent(String.self, forKey: .backdropPath)
            return
        }
        
        let tvShowValues = try decoder.container(keyedBy: TVShowKeys.self)
        if let mediaType = try personValues.decodeIfPresent(String.self, forKey: .mediaType), mediaType == "tv" {
            self.id = try tvShowValues.decodeIfPresent(Int.self, forKey: .id)
            self.mediaType = mediaType
            self.title = try tvShowValues.decodeIfPresent(String.self, forKey: .title)
            self.releaseDate = try tvShowValues.decodeIfPresent(String.self, forKey: .releaseDate)
            self.posterPath = try tvShowValues.decodeIfPresent(String.self, forKey: .posterPath)
            self.backdropPath = try tvShowValues.decodeIfPresent(String.self, forKey: .backdropPath)
            return
        }
        
        throw NetworkError.invalidData
    }
}
