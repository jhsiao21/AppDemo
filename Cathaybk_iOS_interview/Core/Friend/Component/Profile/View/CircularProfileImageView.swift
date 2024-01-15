//
//  CircularProfileImageView.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import UIKit


class CircularProfileImageView: UIView {
    var name : String
    var size : ProfileImageSize
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    init(size: ProfileImageSize) {
        self.name = ""
        self.size = size
        super.init(frame: .zero)
        style()
        layout()
        updateImage(name: name)
    }
    
    override init(frame: CGRect) {
        self.name = ""
        self.size = .large
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func style() {
        
        imageView.frame = bounds
        imageView.layer.cornerRadius = size.dimension / 2
    }
    
    private func layout() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            imageView.topAnchor.constraint(equalTo: topAnchor),
//            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: self.size.dimension),
            imageView.heightAnchor.constraint(equalToConstant: self.size.dimension)
        ])
        
        
    }
    
    public func updateImage(name: String) {
        
        if let image = UIImage(named: name) {
            imageView.image = image.withRenderingMode(.alwaysOriginal)
        } else {
            // 如果無圖示，使用預設圖
            imageView.image = UIImage(named: "imgFriendsFemaleDefault")?.withRenderingMode(.alwaysOriginal)
        }
        setNeedsLayout()
//        layoutIfNeeded()
    }
}

enum ProfileImageSize {
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    case xxLarge
    
    var dimension: CGFloat {
        switch self {
        case .xxSmall:  return 28
        case .xSmall:   return 32
        case .small:    return 40
        case .medium:   return 48
        case .large:    return 52
        case .xLarge:   return 60
        case .xxLarge:  return 72
        }
    }
}
