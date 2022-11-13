//
//  Error.swift
//  Movve-SwiftUI
//
//  Created by Petar Glusac on 12.11.22..
//

import Foundation

public enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
    case unknown
}
