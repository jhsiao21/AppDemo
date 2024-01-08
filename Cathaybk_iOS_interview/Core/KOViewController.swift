//
//  KOViewController.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/7.
//

import UIKit

class KOViewController: UIViewController {

    let titleLabel = UILabel()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        
        style()
        layout()
    }
    
    private func style() {
        titleLabel.text = "KOViewController"
        titleLabel.font = .boldSystemFont(ofSize: 30)
        titleLabel.textColor = .brownGrey
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
