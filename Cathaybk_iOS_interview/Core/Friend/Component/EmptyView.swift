//
//  EmptyView.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/5.
//

import UIKit

class EmptyView: UIView {
    
    let vStackView = UIStackView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let gradientButton = GradientButton(type: .system)
    let buttonIcon = UIImageView()
    let infoLabel = UILabel()
    let setKokoLabel = UILabel()
    let hStackView = UIStackView()
    
    struct imageSpacing {
        static let height: CGFloat = 172
        static let width: CGFloat = 245
    }
    
    struct addButtonSpacing {
        static let height: CGFloat = 40
        static let width: CGFloat = 192
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension EmptyView {
    func style() {
        
        vStackView.axis = .vertical
        vStackView.alignment = .center
        vStackView.spacing = 20
        vStackView.distribution = .fillProportionally
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "imgFriendsEmpty")?.withRenderingMode(.alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        titleLabel.text = "就從加好友開始吧：）"
        titleLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        titleLabel.textColor = UIColor.greyishBrown
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel.text = "與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包喔：）"
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor.brownGrey
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonIcon.image = UIImage(named: "icAddFriendWhite")?.withRenderingMode(.alwaysOriginal)
        buttonIcon.translatesAutoresizingMaskIntoConstraints = false
        
        gradientButton.setTitleColor(.white, for: .normal)
        gradientButton.setTitle("加好友", for: .normal)
        gradientButton.translatesAutoresizingMaskIntoConstraints = false
        gradientButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        infoLabel.text = "幫助好友更快找到你？"
        infoLabel.font = .systemFont(ofSize: 13)
        infoLabel.textColor = UIColor.brownGrey
        infoLabel.textAlignment = .center
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 建立具有底線的屬性字串
        let attributedString = NSMutableAttributedString(string: "設定 KOKO ID")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        
        // 設定屬性字串到 UILabel
        setKokoLabel.attributedText = attributedString
        setKokoLabel.font = .systemFont(ofSize: 13)
        setKokoLabel.textColor = UIColor.hotPink
        setKokoLabel.textAlignment = .left
        setKokoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.spacing = 2
        hStackView.distribution = .fill
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func layout() {
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(gradientButton)
        gradientButton.addSubview(buttonIcon)
        hStackView.addArrangedSubview(infoLabel)
        hStackView.addArrangedSubview(setKokoLabel)
        addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            //            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65),
            //            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -65),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageSpacing.width),
            imageView.heightAnchor.constraint(equalToConstant: imageSpacing.height),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 41),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 29),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 40),
            subtitleLabel.widthAnchor.constraint(equalToConstant: 240),
            
            gradientButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 25),
            gradientButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            gradientButton.heightAnchor.constraint(equalToConstant: addButtonSpacing.height),
            gradientButton.widthAnchor.constraint(equalToConstant: addButtonSpacing.width),
            buttonIcon.trailingAnchor.constraint(equalTo: gradientButton.trailingAnchor, constant: -8),
            buttonIcon.centerYAnchor.constraint(equalTo: gradientButton.centerYAnchor),
            buttonIcon.widthAnchor.constraint(equalToConstant: 24),
            buttonIcon.heightAnchor.constraint(equalToConstant: 24),
            
            hStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            hStackView.topAnchor.constraint(equalTo: gradientButton.bottomAnchor, constant: 37),
            hStackView.heightAnchor.constraint(equalToConstant: 18),
            
        ])
    }    
    
    @objc private func addButtonTapped() {
        print("addButtonTapped!")
    }
}
