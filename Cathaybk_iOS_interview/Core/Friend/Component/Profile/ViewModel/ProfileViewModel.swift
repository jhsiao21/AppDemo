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
#if DEBUG
        print("ProfileViewModel init()")
#endif
        fetchUserData()
    }
    
    func fetchUserData() {
        APIService.shared.fetchUserData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.userData = data
            case .failure(let error):
#if DEBUG
                print("Failed to fetch user data: \(error.localizedDescription)")
#endif
            }
        }
    }
}
