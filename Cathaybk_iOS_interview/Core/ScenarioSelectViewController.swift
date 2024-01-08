//
//  ScenarioSelectViewController.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/7.
//

import UIKit

class ScenarioSelectViewController: UIViewController {
    
    let vStackView = UIStackView()
    let scene_1 = UIButton(type: .system)
    let scene_2 = UIButton(type: .system)
    let scene_3 = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()        
    }
    
    private func style() {
        
        view.backgroundColor = UIColor.backgroundWhite
        
        vStackView.axis = .vertical
        vStackView.spacing = 20
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        scene_1.setTitle("無好友畫⾯", for: .normal)
        scene_1.titleLabel?.textAlignment = .center
        scene_1.addTarget(self, action: #selector(scenarioHandle(sender:)), for: .touchUpInside)
        scene_1.tag = Scenario.無好友畫⾯.rawValue
        
        scene_2.setTitle("只有好友列表", for: .normal)
        scene_2.titleLabel?.textAlignment = .center
        scene_2.addTarget(self, action: #selector(scenarioHandle(sender:)), for: .touchUpInside)
        scene_2.tag = Scenario.只有好友列表.rawValue
        
        scene_3.setTitle("好友列表含邀請", for: .normal)
        scene_3.titleLabel?.textAlignment = .center
        scene_3.addTarget(self, action: #selector(scenarioHandle(sender:)), for: .touchUpInside)
        scene_3.tag = Scenario.好友列表含邀請.rawValue
    }
    
    private func layout() {
        
        vStackView.addArrangedSubview(scene_1)
        vStackView.addArrangedSubview(scene_2)
        vStackView.addArrangedSubview(scene_3)
        view.addSubview(vStackView)
        
        NSLayoutConstraint.activate([
            vStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func scenarioHandle(sender: UIButton) {
        let btn = sender as UIButton
        switch btn.tag {
        case Scenario.無好友畫⾯.rawValue:
            let vc = FriendViewController(for: .無好友畫⾯)
            self.navigationController?.pushViewController(vc, animated: true)
        case Scenario.只有好友列表.rawValue:
            let vc = FriendViewController(for: .只有好友列表)
            self.navigationController?.pushViewController(vc, animated: true)
        case Scenario.好友列表含邀請.rawValue:
            let vc = FriendViewController(for: .好友列表含邀請)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = FriendViewController(for: .無好友畫⾯)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
