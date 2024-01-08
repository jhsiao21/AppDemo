//
//  APIService.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    
    private init(){
        print("APIService init()")
    }
    
    func fetchUserData(completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: Constants.UserData) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? APIError.unknownError))
                return
            }

            do {
                let results = try JSONDecoder().decode(User.self, from: data)
                completion(.success(results.self))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func fetchFriendData(with requestUrl: String, completion: @escaping (Result<Friends, Error>) -> Void) {
                
        guard let url = URL(string: requestUrl) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? APIError.unknownError))
                return
            }

            do {
                let results = try JSONDecoder().decode(Friends.self, from: data)
                completion(.success(results.self))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
}
    
enum APIError: Error {
    case failedToGetData
    case invalidURL
    case unknownError
}

enum Scenario : Int {
    case 無好友畫⾯
    case 只有好友列表
    case 好友列表含邀請
}

struct Constants {
    
    static let baseURL = "https://dimanyen.github.io"
    
    //使⽤者資料
    static let UserData = "\(baseURL)/man.json"
    
    //好友列表1
    static let Friend1 = "\(baseURL)/friend1.json"
    
    //好友列表2
    static let Friend2 = "\(baseURL)/friend2.json"
    
    //好友列表含邀請列表
    static let Friend3 = "\(baseURL)/friend3.json"
    
    //無資料邀請/好友列表
    static let Friend4 = "\(baseURL)/friend4.json"
}
