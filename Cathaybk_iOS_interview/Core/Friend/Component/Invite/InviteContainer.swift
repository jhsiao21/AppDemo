//
//  CardContainer.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import UIKit

class InviteContainer: UIView {

    var cardsToBeVisible = 3
    /**
     Horizontal inset of a card in container
     */
    let horizontalInset: CGFloat = 10.0
    /**
     Vertical inset of a card in container
     */
    let verticalInset: CGFloat = 10.0
    
    private var cardViews = [InviteCardView]()
    
    private var remainingCards = 0
    
    private var cardIndex = 0
    
    /**
     Number of all cards provided by datasource
    */
    private var numberOfCardsToShow = 0
    
    private var visibleCards: [InviteCardView] {
        return subviews as? [InviteCardView] ?? []
    }
    
    var dataSource: CardContainerDataSource? {
        didSet {
            reloadData()
        }
    }
    
    var numberOfVisibleCards : Int {
        return visibleCards.count
    }
    
    weak var delegate: CardContainerDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
     This method reloads data in Card Container.
     1. All card views removed
     2. Layout
     3. Adding N cards to container (N = min(numberOfCards, cardsToBeVisible)
    */
    func reloadData() {
        removeAllCardViews()
        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        numberOfCardsToShow = datasource.numberOfCardsToShow()
        remainingCards = numberOfCardsToShow
        cardIndex = 0
        
        for index in 0..<min(numberOfCardsToShow, cardsToBeVisible) {
            guard let cardView = datasource.card(at: index) else { return }
            addCardView(cardView: cardView, atIndex: index)
        }
    }
    
    /**
     This method removes all card views from container
    */
    private func removeAllCardViews() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        
        cardViews = []
    }
    
    // MARK: - Configurations
    /**
     This method adds card view to the card container view
    */
    private func addCardView(cardView: InviteCardView, atIndex index: Int) {
        cardView.delegate = self
        addCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        
        let cardIndex = numberOfCardsToShow - remainingCards
        delegate?.cardContainer(willDisplay: cardView, at: cardIndex)
        
        insertSubview(cardView, at: 0)
        remainingCards -= 1
    }
    
    /**
     This method creates card view's frame based on index of a card
    */
    private func addCardFrame(index: Int, cardView: InviteCardView) {
        var cardViewFrame = bounds
        let horizontalInset = CGFloat(index) * self.horizontalInset
        let verticalInset = CGFloat(index) * self.verticalInset
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
        delegate?.cardContainer(willDisplay: cardView, with: index)
    }
}

extension InviteContainer: InviteCardViewDelegate {
    func selected(view: InviteCardView) {
        delegate?.cardContainer(didSelect: view, at: cardIndex)
    }
    
    private func undoCardFrame(index: Int, cardView: InviteCardView) {
        var cardViewFrame = bounds
        let horizontalInset = CGFloat(index) * self.horizontalInset
        let verticalInset = CGFloat(index) * self.verticalInset
        
        cardViewFrame.size.width += 2 * horizontalInset
        cardViewFrame.origin.x -= horizontalInset
        cardViewFrame.origin.y += cardView.frame.height
        
        cardView.frame = cardViewFrame
    }
    
    func statusChoiceDidEnd(on view: InviteCardView, reply: cardStatus) {
        guard let datasource = dataSource else { return }
        view.removeFromSuperview()
        
        delegate?.card(view)
        
        delegate?.card(view, at: cardIndex)
        cardIndex += 1
        
        if remainingCards > 0 {
            let newIndex = datasource.numberOfCardsToShow() - remainingCards
//            guard let card = datasource.card(at: newIndex) else { return }
            addCardView(cardView: view, atIndex: 2)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.3) {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                }
            }
        } else {
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.3) {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                }
            }
        }
    }
}
