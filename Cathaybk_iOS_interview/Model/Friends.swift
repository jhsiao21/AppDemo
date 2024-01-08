//
//  Friend.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import Foundation

struct Friends : Codable {
    let response: [FriendElement]
}

struct FriendElement : Codable {
    let name: String
    var status: Status  //接受邀請後，需要改變狀態值，所以使用var
    let isTop: String
    let fid: String
    let updateDate: String
}

//0:邀請送出, 1:已完成 2:邀請中
enum Status : Int, Codable {
    case request
    case invited
    case inviting
}
