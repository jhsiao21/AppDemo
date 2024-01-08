//
//  SelectedFilterView.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import UIKit

class SelectedFilterView: UIView {
    
    var friendRectangle : PinkRectangleView?
    var chatRectangle : PinkRectangleView?
    private var friendBadge: BadgeHub?
    private var chatBadge: BadgeHub?

    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 36
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .bottom
        
        return stackView
    }()

    private let friendStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.tag = FriendTableFilter.friend.rawValue
        
        return stackView
    }()
    
    private let chatStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.tag = FriendTableFilter.chat.rawValue
        
        return stackView
    }()
    
    private let friendLabel : UILabel = {
        let label = UILabel()
        label.text = "好友"
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let chatLabel : UILabel = {
        let label = UILabel()
        label.text = "聊天"
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
        
    // spacer
    private let spacer: UIView = {
        let stackView = UIView()
                
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func style() {
        friendRectangle = PinkRectangleView()
        friendRectangle?.translatesAutoresizingMaskIntoConstraints = false
        
        chatRectangle = PinkRectangleView()
        chatRectangle?.changeColor(to: UIColor.clear)
        chatRectangle?.translatesAutoresizingMaskIntoConstraints = false
        
        friendBadge = BadgeHub(view: friendLabel)
        friendBadge?.setCount(2)
        
        chatBadge = BadgeHub(view: chatLabel)
        chatBadge?.setCount(100)

        let friendTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        friendStackView.addGestureRecognizer(friendTapGesture)

        let chatTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        chatStackView.addGestureRecognizer(chatTapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let view = sender.view {
            
            switch view.tag {
            case FriendTableFilter.friend.rawValue:
                friendRectangle?.changeColor(to: UIColor.hotPink)
                chatRectangle?.changeColor(to: UIColor.clear)
                print("Friend subview tapped!")
            case FriendTableFilter.chat.rawValue:
                friendRectangle?.changeColor(to: UIColor.clear)
                chatRectangle?.changeColor(to: UIColor.hotPink)
                print("Chat subview tapped!")
            default:
                break
            }
        }
    }
    
    func layout() {
        friendStackView.addArrangedSubview(friendLabel)
        friendStackView.addArrangedSubview(friendRectangle!)
        
        chatStackView.addArrangedSubview(chatLabel)
        chatStackView.addArrangedSubview(chatRectangle!)
        
        hStackView.addArrangedSubview(friendStackView)
        hStackView.addArrangedSubview(chatStackView)
        hStackView.addArrangedSubview(spacer)
        addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: topAnchor),
            hStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            friendRectangle!.topAnchor.constraint(equalTo: friendLabel.bottomAnchor, constant: 6),
            friendRectangle!.widthAnchor.constraint(equalToConstant: 20),
            friendRectangle!.heightAnchor.constraint(equalToConstant: 4),
            
            chatRectangle!.topAnchor.constraint(equalTo: chatLabel.bottomAnchor, constant: 6),
            chatRectangle!.widthAnchor.constraint(equalToConstant: 20),
            chatRectangle!.heightAnchor.constraint(equalToConstant: 4)
        ])
        
    }
}

enum FriendTableFilter : Int {
        
    case friend
    case chat

}
