//
//  UdacityResponse.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 24/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import Foundation

struct UdacityResponse: Codable {
    let status: Int
    let error: String
}

extension UdacityResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
