//
//  HomeModel.swift
//  wchallenge
//
//  Created by Diego Hernandez on 11/08/21.
//

import Foundation

struct Book: Decodable {
    /*
        {
         "image": "http://wolox-training.s3.amazonaws.com/uploads/content.jpeg",
         "title": "The Girl on the Train",
         "id": 1,
         "author": "Paula Hawkins",
         "year": "2015",
         "status": "Unavailable",
         "genre": "suspense"
        }
     */
    
    let image: String?
    let title: String?
    let id: Int
    let author: String?
    let year: String?
    let status: String?
    let genere: String?
    
    private enum CodingKeys: String, CodingKey {
        case image
        case title
        case id
        case author
        case year
        case status
        case genere
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image = try? values.decode(String.self, forKey: .image)
        title = try? values.decode(String.self, forKey: .title)
        id = try values.decode(Int.self, forKey: .id)
        author = try? values.decode(String.self, forKey: .author)
        year = try? values.decode(String.self, forKey: .year)
        status = try? values.decode(String.self, forKey: .status)
        genere = try? values.decode(String.self, forKey: .genere)
    }
}

struct User: Decodable {
    /*
     {
       "username": "admin",
       "id": 1,
       "image": "https://goo.gl/1PBWVM"
     }
     */
    let username: String?
    let id: Int
    let image: String?
    
    private enum CodingKeys: String, CodingKey {
        case image
        case username
        case id
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image = try? values.decode(String.self, forKey: .image)
        username = try? values.decode(String.self, forKey: .username)
        id = try values.decode(Int.self, forKey: .id)
    }
}

struct Comment: Decodable {
    /*
     {
         "user": {
           "username": "admin",
           "id": 1,
           "image": "https://goo.gl/1PBWVM"
         },
         "id": 1,
         "content": "I recommend this book! It's really interesting."
       }
     */
    let user: User?
    let id: Int
    let content: String?
    
    private enum CodingKeys: String, CodingKey {
        case user
        case id
        case content
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try? values.decode(User.self, forKey: .user)
        content = try? values.decode(String.self, forKey: .content)
        id = try values.decode(Int.self, forKey: .id)
    }
}
