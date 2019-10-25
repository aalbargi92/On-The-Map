//
//  LoginRequest.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 24/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import Foundation

struct LoginBody: Codable {
    let username: String
    let password: String
}

struct LoginRequest: Codable {
    let udacity: LoginBody
}
