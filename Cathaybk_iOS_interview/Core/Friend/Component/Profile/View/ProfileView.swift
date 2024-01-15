//
//  ProfileView.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import UIKit

class ProfileView : UIView {

    private var profileImage = CircularProfileImageView(size: .large)
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .bottom
        
        return stackView
    }()
    
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "紫晽"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let kokoidLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.text = "設定 KOKO ID >"
        label.textAlignment = .center
        label.tintColor = .label
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
        print("ProfileView init()")

        layout()
    }
    
    private func layout() {
        
        hStackView.addArrangedSubview(vStackView)
        hStackView.addArrangedSubview(spacer)
        hStackView.addArrangedSubview(profileImage)
        vStackView.addArrangedSubview(nameLabel)
        vStackView.addArrangedSubview(kokoidLabel)
        addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: topAnchor),
            hStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            profileImage.widthAnchor.constraint(equalToConstant: profileImage.size.dimension),
            profileImage.heightAnchor.constraint(equalToConstant: profileImage.size.dimension),
        ])
    }
     
    func configure(userData: UserElement?) {
        
        guard let user = userData else { return }
        
        DispatchQueue.main.async { [self] in
            nameLabel.text = user.name
            kokoidLabel.text = "KOKO ID：\(String(describing: user.kokoid)) >"
            profileImage.updateImage(name: user.kokoid)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
