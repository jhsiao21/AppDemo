//
//  SettingViewController.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import UIKit

class SettingViewController: UIViewController  {
 
    let titleLabel = UILabel()
//    var closureStorage : UIViewPropertyAnimator?
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    private func style() {
//        view.backgroundColor = .gray        
        titleLabel.text = "SettingViewController"
        titleLabel.font = .boldSystemFont(ofSize: 30)
        titleLabel.textColor = .brownGrey
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

