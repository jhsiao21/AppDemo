//
//  User.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import Foundation

struct User : Codable {
    let response: [UserElement]
}

struct UserElement : Codable {
    let name: String
    let kokoid: String
}
