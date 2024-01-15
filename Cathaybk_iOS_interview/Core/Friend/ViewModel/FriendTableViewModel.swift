//
//  FriendTableViewModel.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import Foundation
import RxSwift
import RxCocoa

class FriendTableViewModel {
    
    //Output for display
    //    var friendElements = [FriendElement]()
    var friendElements: BehaviorRelay<[FriendElement]> = BehaviorRelay(value: [])
//    var friendElements: BehaviorSubject<[FriendElement]> = BehaviorSubject(value: [])
    
    var userElement : BehaviorRelay<[UserElement]> = BehaviorRelay(value: [])
        
    //Input
    var userData: [UserElement]? {
        didSet {
            guard let ud = userData else { return }
                                    
            userElement.accept(ud)
        }
    }
    
    //Input
    var friends: Friends? {
        didSet {
            guard let fs = friends else { return }
            
            let mappedElements = fs.response.map { element in
                
                return FriendElement(
                    name: element.name,
                    status: element.status,
                    isTop: element.isTop,
                    fid: element.fid,
                    updateDate: element.updateDate
                )
            }
            
            friendElements.accept(mappedElements)
        }
    }
    
    func fetchUserData() {
        APIService.shared.fetchUserData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.userData = data.response
                
            case .failure(let error):
                print("Failed to fetch user data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFriendData(scenario scene:Scenario) {        
        switch scene {
        case .無好友畫⾯:
            request(with: Constants.Friend4)
        case .只有好友列表:
            fetchAndMergeFriendData { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    self.friends = data
                    
                case .failure(let error):
                    print("Failed to fetch user data: \(error.localizedDescription)")
                }
            }
        case .好友列表含邀請:
            request(with: Constants.Friend3)
        }
    }
    
    func request(with url: String) {
        APIService.shared.fetchFriendData(with: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                print("fetchFriendData() success")
                self.friends = data
                
            case .failure(let error):
                print("Failed to fetch user data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchAndMergeFriendData(completion: @escaping (Result<Friends, Error>) -> Void) {
        let group = DispatchGroup()
        var firstRequestResults: Friends?
        var secondRequestResults: Friends?
        var errors: [Error] = []
        // Merge the results
        var mergedResults: [String: FriendElement] = [:]
        
        group.enter()
        APIService.shared.fetchFriendData(with: Constants.Friend1) { result in
            defer { group.leave() }
            switch result {
            case .success(let data):
                firstRequestResults = data
            case .failure(let error):
                completion(.failure(error))
                print("Failed to fetch user data: \(error.localizedDescription)")
            }
        }
        
        group.enter()
        APIService.shared.fetchFriendData(with: Constants.Friend2) { result in
            defer { group.leave() }
            switch result {
            case .success(let data):
                secondRequestResults = data
            case .failure(let error):
                completion(.failure(error))
                print("Failed to fetch user data: \(error.localizedDescription)")
            }
        }
        
        // Once all requests have completed
        group.notify(queue: .main) {
            if !errors.isEmpty {
                // If there were any errors, return the first one
                completion(.failure(errors.first!))
                return
            }
            
            // Helper function to merge friends data
            func merge(friends: Friends) {
                for friend in friends.response {
                    // If the friend is already present, compare updateDate
                    if let existingFriend = mergedResults[friend.fid],
                       let newDate = Int(friend.updateDate.replacingOccurrences(of: "/", with: "")),
                       let existingDate = Int(existingFriend.updateDate.replacingOccurrences(of: "/", with: ""))
                    {
                        if newDate > existingDate {
                            mergedResults[friend.fid] = friend
                        }
                    } else {
                        mergedResults[friend.fid] = friend
                    }
                }
            }
            
            // Merge data from the first request
            if let firstResults = firstRequestResults {
                merge(friends: firstResults)
            }
            
            // Merge data from the second request
            if let secondResults = secondRequestResults {
                merge(friends: secondResults)
            }
            
            // 將字典中的 values 取出轉換為 [FriendElement]
            let friendElementsArray: [FriendElement] = Array(mergedResults.values)
            
            // 使用這個 [FriendElement] 建立一個新的 Friends 物件
            let friends: Friends = Friends(response: friendElementsArray)
            
            completion(.success(friends))
        }
    }

    func searchFriends(query: String) -> Observable<[FriendElement]> {
            return friendElements
                .map { friends in
                    friends.filter { friend in
                        // 这里的匹配逻辑取决于你的需求，比如你可能会检查朋友的名字是否包含搜索查询。
                        friend.name.contains(query)
                    }
                }
        }
}
