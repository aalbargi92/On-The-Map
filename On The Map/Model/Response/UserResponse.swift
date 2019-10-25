//
//  UserResponse.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 25/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import Foundation

struct UserBody: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct UserResponse: Codable {
    let user: UserBody
}
