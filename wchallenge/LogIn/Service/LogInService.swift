//
//  LogInService.swift
//  wchallenge
//
//  Created by Diego Hernandez on 4/08/21.
//

import Foundation
import Combine

let APIBaseUrl = "https://private-59a7d9-iostrainingapi.apiary-mock.com"

protocol LogInService {
    func makeLogIn(request: RequestLogin) -> AnyPublisher<ResponseLogin, Error>
}

fileprivate enum LoginEnpoint {
    case makeLogIn(request: RequestLogin)
}

extension LoginEnpoint: RequestBuilder {
    
    var identifier: Int? {
        switch self {
        case .makeLogIn:
            return 1
        }
    }
    
    var urlRequest: URLRequest {
        switch self {
        case let .makeLogIn(request):
            guard let url = URL(string: "\(APIBaseUrl)/signin") else {
                preconditionFailure("Invalid URL format")
            }
            var req = URLRequest(url: url)
            req.addValue("application/json", forHTTPHeaderField: "accept")
            req.addValue("application/json", forHTTPHeaderField: "content-type")
            req.httpMethod = "POST"
            do {
                req.httpBody = try JSONEncoder().encode(request)
            }
            catch {
                print("Error encoding body: \(error)")
            }
            return req
        }
    }
}

struct UsersLoginApiService: LogInService {
    
    let apiSession = APISession()
    
    func makeLogIn(request: RequestLogin) -> AnyPublisher<ResponseLogin, Error> {
        apiSession.request(with: LoginEnpoint.makeLogIn(request: request))
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}


