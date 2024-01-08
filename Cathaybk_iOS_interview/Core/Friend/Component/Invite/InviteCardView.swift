//
//  InviteCardView.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import UIKit

class InviteCardView: UIView {
    
    weak var delegate: InviteCardViewDelegate?

    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
//    private let thumbnailImageView = CircularProfileImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    let thumbnailImageView = CircularProfileImageView(size: .small)
    
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    //名字
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.greyishBrown
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //邀請訊息
    private let msgLabel : UILabel = {
        let label = UILabel()
        label.text = "邀請你成為好友:)"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.brownGrey
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //同意按鈕
    private let allowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btnFriendsAgree"), for: .normal)
        button.tintColor = UIColor.hotPink
        button.addTarget(self, action: #selector(allowButtonTapped), for: .touchUpInside)
        
        // 約束寬度
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        // 約束高度
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return button
    }()
    
    //拒絕按鈕
    private let rejectButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btnFriendsDelet"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(rejectButtonTapped), for: .touchUpInside)
        
        // 約束寬度
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        // 約束高度
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 6
    private var fillColor: UIColor = .white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addShadow()
        addGestureOnCards()
    }
    
    func addGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(sender:))))
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        delegate?.selected(view: self)
    }
    
    @objc func allowButtonTapped() {
        delegate?.statusChoiceDidEnd(on: self, reply: .allow)
    }
    
    @objc func rejectButtonTapped() {
        delegate?.statusChoiceDidEnd(on: self, reply: .reject)
    }
    
    func addShadow() {
        shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black10.cgColor
//        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.shadowRadius = 16
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
}

extension InviteCardView {
    
    private func style() {
        layer.cornerRadius = cornerRadius
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    private func layout() {
        hStackView.addArrangedSubview(thumbnailImageView)
        hStackView.addArrangedSubview(vStackView)
        vStackView.addArrangedSubview(nameLabel)
        vStackView.addArrangedSubview(msgLabel)
        hStackView.addArrangedSubview(UIView())
        hStackView.addArrangedSubview(allowButton)
        hStackView.addArrangedSubview(rejectButton)
        
        addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: topAnchor),
            hStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
