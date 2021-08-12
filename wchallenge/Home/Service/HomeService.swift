//
//  HomeService.swift
//  wchallenge
//
//  Created by Diego Hernandez on 11/08/21.
//

import Foundation
import Combine

protocol HomeService {
    func requestBooks() -> AnyPublisher<[Book], Error>
    func requestComments(bookId: Int) -> AnyPublisher<[Comment], Error>
    func requestSuggestions(bookId: Int) -> AnyPublisher<[Book], Error>
}

fileprivate enum HomeEnpoint {
    case requestBooks
    case requestComments(bookId: Int)
    case requestSuggestions(bookId: Int)
}

extension HomeEnpoint: RequestBuilder {
    
    var identifier: Int? {
        switch self {
        case .requestBooks:
            return 1
        case .requestComments(_):
            return 2
        case .requestSuggestions(_):
            return 3
        }
    }
    
    var urlRequest: URLRequest {
        switch self {
        case .requestBooks:
            guard let url = URL(string: "\(APIBaseUrl)/books") else {
                preconditionFailure("Invalid URL format")
            }
            var req = URLRequest(url: url)
            req.addValue("application/json", forHTTPHeaderField: "accept")
            req.addValue("application/json", forHTTPHeaderField: "content-type")
            req.httpMethod = "GET"
            return req
        case let .requestComments(bookId):
            guard let url = URL(string: "\(APIBaseUrl)/books/\(bookId)/comments") else {
                preconditionFailure("Invalid URL format")
            }
            var req = URLRequest(url: url)
            req.addValue("application/json", forHTTPHeaderField: "accept")
            req.addValue("application/json", forHTTPHeaderField: "content-type")
            req.httpMethod = "GET"
            return req
        case let .requestSuggestions(bookId):
            guard let url = URL(string: "\(APIBaseUrl)/books/\(bookId)/suggestions") else {
                preconditionFailure("Invalid URL format")
            }
            var req = URLRequest(url: url)
            req.addValue("application/json", forHTTPHeaderField: "accept")
            req.addValue("application/json", forHTTPHeaderField: "content-type")
            req.httpMethod = "GET"
            return req
        }
    }
}

struct HomeApiService: HomeService {
    
    let apiSession = APISession()
    
    func requestBooks() -> AnyPublisher<[Book], Error> {
        apiSession.request(with: HomeEnpoint.requestBooks)
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func requestComments(bookId: Int) -> AnyPublisher<[Comment], Error> {
        apiSession.request(with: HomeEnpoint.requestComments(bookId: bookId))
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func requestSuggestions(bookId: Int) -> AnyPublisher<[Book], Error> {
        apiSession.request(with: HomeEnpoint.requestSuggestions(bookId: bookId))
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}


