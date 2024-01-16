//
//  MainTabBarViewController.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import UIKit

class MainTabBarViewController: CustomTabBarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundWhite
                
        let ProductsVC = UINavigationController(rootViewController: ProductsViewController())
        let FriendVC = UINavigationController(rootViewController: ScenarioSelectViewController())
        let HomeVC = UINavigationController(rootViewController: KOViewController())
        let ManageVC = UINavigationController(rootViewController: ManageViewController())
        let SettingVC = UINavigationController(rootViewController: SettingViewController())
//        let SettingVC = UINavigationController(rootViewController: FriendViewController2(for: .好友列表含邀請))
                
        ProductsVC.tabBarItem.image = UIImage(named: "icTabbarProductsOff")?.withRenderingMode(.automatic)
        FriendVC.tabBarItem.image = UIImage(named: "icTabbarFriendsOn")?.withRenderingMode(.automatic)
//        HomeVC.tabBarItem.image = UIImage()
        ManageVC.tabBarItem.image = UIImage(named: "icTabbarManageOff")?.withRenderingMode(.automatic)
        SettingVC.tabBarItem.image = UIImage(named: "icTabbarSettingOff")?.withRenderingMode(.automatic)

        tabBar.backgroundColor = UIColor.backgroundWhite
        tabBar.tintColor = .hotPink
        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage(named: "imgTabbarBg")?.withRenderingMode(.alwaysOriginal)
        tabBar.shadowImage = UIImage()
        setViewControllers([ProductsVC, FriendVC, HomeVC, ManageVC, SettingVC], animated: true)
        
        
    }
}
