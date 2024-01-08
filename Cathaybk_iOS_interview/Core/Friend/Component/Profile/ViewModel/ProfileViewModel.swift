//
//  ProfileViewModel.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var userData: User?
    
    init() {
        print("ProfileViewModel init()")
        fetchUserData()
    }
    
    func fetchUserData() {
        APIService.shared.fetchUserData { result in
            switch result {
            case .success(let data):
                self.userData = data
                let _ = print(self.userData?.response.first?.name)
            case .failure(let error):
                print("Failed to fetch user data: \(error.localizedDescription)")
            }
        }
    }
}
