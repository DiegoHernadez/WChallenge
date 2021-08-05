//
//  Network.swift
//  wchallenge
//
//  Created by Diego Hernandez on 4/08/21.
//

import Foundation
import Combine

public protocol APIService {
    func request<T: Decodable>(with builder: RequestBuilder) -> AnyPublisher<T, Error>
}

public protocol RequestBuilder {
    var identifier: Int? { get }
    var urlRequest: URLRequest {get}
}

public struct APIErrorResponse: Codable {
    public init(code: Int, description: String) {
        self.code = code
        self.description = description
    }
    
    public let code: Int
    public let description: String
    
    
}

public enum APIError: Error {
    case decodingError(String?)
    case httpError(Int)
    case unknown
    case general(APIErrorResponse)
    case invalidSession
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .general(resp):
            return resp.description
        case let .decodingError(msg):
            return msg
        case let .httpError(code):
            return "Http error code: \(code)"
        default:
            return nil
        }
    }
}

public extension DateFormatter {
    static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}

public struct APISession: APIService {
    
    public init() {
    }
    
    public func request<T>(with builder: RequestBuilder) -> AnyPublisher<T, Error> where T: Decodable {
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        let request = builder.urlRequest
        print("Requesting: \(request)")
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .mapError { $0 }
            .flatMap { data, response -> AnyPublisher<T, Error> in
                if let response = response as? HTTPURLResponse {
                    if (200...299).contains(response.statusCode) {
                        print(String(data: data, encoding: .utf8) ?? "No data")
                    return Just(data)
                        .decode(type: T.self, decoder: decoder)
                        .mapError {err in APIError.decodingError(err.localizedDescription)}
                        .eraseToAnyPublisher()
                    } else {
                        do {
                            let errorResponse = try decoder.decode(APIErrorResponse.self, from: data)
                            return Fail(error: APIError.general(errorResponse))
                                .eraseToAnyPublisher()
                        }
                        catch {
                        }
                        return Fail(error: APIError.httpError(response.statusCode))
                            .eraseToAnyPublisher()
                    }
                }
                return Fail(error: APIError.unknown)
                        .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

