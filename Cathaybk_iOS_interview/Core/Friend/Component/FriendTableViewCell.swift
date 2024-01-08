//
//  FriendTableViewCell.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/5.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    static let identifier = "FriendTableViewCell"
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        
        return stackView
    }()
    
    var nameLabel = UILabel()
    var starImageView = UIImageView()
    var profileImage = CircularProfileImageView(size: .small)
//    var thumbnailImageView = UIImageView()
    var moreImageView = UIImageView()
    var transferLabel = UILabel()
    var inviteLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        Style()
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var friendElement: FriendElement? {
        didSet {
            guard let fe = friendElement else { return }
            nameLabel.text = fe.name
            
            switch fe.status {
            case .request:
                inviteLabel.isHidden = true
            case .invited:
                inviteLabel.isHidden = true
            case .inviting:
                inviteLabel.isHidden = false
            }
            
            starImageView.alpha = (fe.isTop == "0") ? 0 : 1
            
            profileImage.updateImage(name: fe.name)
        }
    }    
}

extension FriendTableViewCell {
    
    func Style() {
        
        nameLabel.textColor = UIColor.greyishBrown
        nameLabel.font.withSize(16)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        transferLabel.text = "轉帳"
//        transferLabel.font.withSize(14)
        transferLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        transferLabel.textAlignment = .center
        transferLabel.textColor = UIColor.hotPink
        transferLabel.layer.borderWidth = 1
        transferLabel.layer.borderColor = UIColor.hotPink.cgColor
        transferLabel.translatesAutoresizingMaskIntoConstraints = false
        
        inviteLabel.text = "邀請中"
        inviteLabel.isHidden = true
        inviteLabel.font.withSize(14)
        inviteLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        inviteLabel.textAlignment = .center
        inviteLabel.textColor = UIColor.brownGrey
        inviteLabel.layer.borderWidth = 1
        inviteLabel.layer.borderColor = UIColor.pinkishGrey.cgColor
        inviteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        starImageView = UIImageView(image: UIImage(named: "icFriendsStar")?.withRenderingMode(.alwaysOriginal))
        starImageView.clipsToBounds = true
        starImageView.alpha = 0
        starImageView.translatesAutoresizingMaskIntoConstraints = false
                
//        profileImage = UIImageView(image: UIImage(named: "imgFriendsList")?.withRenderingMode(.alwaysOriginal))
//        profileImage.layer.cornerRadius = thumbnailImageView.bounds.width / 2
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        moreImageView = UIImageView(image: UIImage(named: "icFriendsMore")?.withRenderingMode(.alwaysOriginal))
        moreImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        hStackView.addArrangedSubview(starImageView)
        hStackView.addArrangedSubview(profileImage)
        hStackView.addArrangedSubview(nameLabel)
        hStackView.addArrangedSubview(UIView())
        hStackView.addArrangedSubview(transferLabel)
        hStackView.addArrangedSubview(inviteLabel)
        hStackView.addArrangedSubview(moreImageView)
        
        contentView.addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            
            starImageView.widthAnchor.constraint(equalToConstant: 14),
            starImageView.heightAnchor.constraint(equalToConstant: 14),
            
//            profileImage.widthAnchor.constraint(equalToConstant: 40),
//            profileImage.heightAnchor.constraint(equalToConstant: 40),
            
            hStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
