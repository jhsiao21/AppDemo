//
//  FriendTableViewModel.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import Foundation

class FriendTableViewModel {
    
    //Output for display
    var friendElements = [FriendElement]()
    
    //Out for generate invite card
    var invitingFriends = [String]()
    
    //Input
    var friends: Friends? {
        didSet {
            guard let fs = friends else { return }
            
            friendElements = [FriendElement]()
            invitingFriends = [String]()
            
            fs.response.forEach { element in
                
                friendElements.append(element)
                
                DispatchQueue.main.async {
                    if element.status == .inviting {
//                        print("name:\(element.name)")
                        self.enqueue(element.name)
                    }
                }
            }
        }
    }
}

extension FriendTableViewModel {
//    var queue: [T] = []

    func enqueue(_ element: String) {
        invitingFriends.append(element)
    }

    func dequeue() -> String? {
        return invitingFriends.isEmpty ? nil : invitingFriends.removeFirst()
    }

    func peek() -> String? {
        return invitingFriends.first
    }

    var isEmpty: Bool {
        return invitingFriends.isEmpty
    }

    var count: Int {
        return invitingFriends.count
    }
}
