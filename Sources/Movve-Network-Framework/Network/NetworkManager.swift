//
//  NetworkManager.swift
//  Movve-SwiftUI
//
//  Created by Petar Glusac on 12.11.22..
//

import Foundation
import Combine

public class NetworkManager {
    private let session: URLSession
    private var cancellables = Set<AnyCancellable>()
    
    private let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func performMultipleSearch(query: String, page: Int) -> Future<SearchElements, NetworkError> {
        Future { [weak self] promise in
            guard let self else {
                return promise(.failure(.unknown))
            }
            
            self.fetch(endpoint: .multiSearch(query: query, page: page), type: SearchResponse.self, decoder: self.decoder)
                .map { searchResponse in
                    SearchElements(response: searchResponse)
                }
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { value in
                    promise(.success(value))
                }
                .store(in: &self.cancellables)
        }
    }
    
    public func performMultipleSearch(query: String, page: Int, callback: @escaping (Result<SearchElements, NetworkError>) -> Void) {
        fetch(endpoint: .multiSearch(query: query, page: page), type: SearchResponse.self, decoder: decoder)
            .map { searchResponse in
                SearchElements(response: searchResponse)
            }
            .sink { completion in
                if case let .failure(error) = completion {
                    callback(.failure(error))
                }
            } receiveValue: { value in
                callback(.success(value))
            }
            .store(in: &self.cancellables)
    }
    
    private func fetch<T: Decodable>(endpoint: Endpoint, type: T.Type, decoder: JSONDecoder) -> Future<T, NetworkError> {
        Future { [weak self] promise in
            guard let self else {
                return promise(.failure(.unknown))
            }
            
            guard let url = endpoint.url else {
                return promise(.failure(.invalidUrl))
            }
            
            self.session.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                        throw NetworkError.invalidResponse
                    }
                    return data
                }
                .decode(type: T.self, decoder: decoder)
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case _ as DecodingError:
                            promise(.failure(.invalidData))
                        case let error as NetworkError:
                            promise(.failure(error))
                        default:
                            promise(.failure(.unknown))
                        }
                    }
                } receiveValue: { value in
                    promise(.success(value))
                }
                .store(in: &self.cancellables)
        }
    }
    
}
