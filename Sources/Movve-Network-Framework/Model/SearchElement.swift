//
//  SearchElement.swift
//  Movve-SwiftUI
//
//  Created by Petar Glusac on 12.11.22..
//

import Foundation

public struct SearchElement: Codable {
    let id: Int
    let mediaType: String
    let title: String
    let releaseDate: String
    let posterPath: String
    let backdropPath: String
}

public struct SearchElements: Codable {
    let page: Int
    let results: [SearchElement]
    
    init(response: SearchResponse) {
        self.page = response.page
        self.results = response.results.compactMap { searchResponse -> SearchElement? in
            guard let id = searchResponse.id, let mediaType = searchResponse.mediaType, let title = searchResponse.title, let releaseDate = searchResponse.releaseDate, let posterPath = searchResponse.posterPath, let backdropPath = searchResponse.backdropPath else {
                return nil
            }
            return SearchElement(id: id, mediaType: mediaType, title: title, releaseDate: releaseDate, posterPath: posterPath, backdropPath: backdropPath)
        }
    }
}
