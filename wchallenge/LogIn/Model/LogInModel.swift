//
//  LogInModel.swift
//  wchallenge
//
//  Created by Diego Hernandez on 4/08/21.
//

import Foundation

struct RequestLogin: Codable{
    /*
     {
         "name": "John",
         "lastname": "Smith",
         "email": "mrsmith@gmail.com",
         age: 28
     }
     */
    let name: String
    let lastname: String
    let email: String
    let age: Int
}

struct ResponseLogin: Decodable {
    /*
     {
       "message": "Logged in!"
     }
     */
    let message: String?
}
