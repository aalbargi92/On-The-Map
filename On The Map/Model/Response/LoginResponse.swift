//
//  LoginResponse.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 24/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}
