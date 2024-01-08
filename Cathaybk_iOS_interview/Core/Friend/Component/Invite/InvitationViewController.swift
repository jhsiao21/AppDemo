//
//  InvitationViewController.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/5.
//

import UIKit

class InvitationViewController: UIViewController {

    var invitationCardView : InviteCardView?
    
    init(name: String) {
        super.init(nibName: nil, bundle: nil)
        
        invitationCardView = InviteCardView()
        invitationCardView?.nameLabel.text = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
    }
    
    func style() {
        invitationCardView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        view.addSubview(invitationCardView ?? UIView())
        
        NSLayoutConstraint.activate([
            invitationCardView!.topAnchor.constraint(equalTo: view.topAnchor),
            invitationCardView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            invitationCardView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            invitationCardView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
