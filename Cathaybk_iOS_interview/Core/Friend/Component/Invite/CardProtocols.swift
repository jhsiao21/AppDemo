//
//  CardProtocols.swift
//  Cathaybk_iOS_interview
//
//  Original from: https://github.com/RVetas/CardContainer
//  Revised by LoganMacMini on 2024/1/4.
//

import UIKit

protocol InviteCardViewDelegate: AnyObject {
    //邀請狀態選擇用
    func statusChoiceDidEnd(on view: InviteCardView, reply: cardStatus)
    
    //點擊事件用
    func selected(view: InviteCardView)
}

enum cardStatus {
    case allow
    case reject
}

protocol CardContainerDataSource: AnyObject {
    /**
     Defines the number of cards to be shown
    */
    func numberOfCardsToShow() -> Int
    
    /**
     Returns the card for a specified index
    */
    func card(at index: Int) -> InviteCardView?
    
}

protocol CardContainerDelegate: AnyObject {
    
    func card(_ view: InviteCardView, at index: Int)
    /**
     This method is called when the view is about to appear in the bottom of the card stack.
    */
    func cardContainer(willDisplay view: InviteCardView, at index: Int)
    
    func cardContainer(willDisplay view: InviteCardView, with innerIndex: Int)
    
    /**
     Tells the delegate that the specified view is selected
    */
    func cardContainer(didSelect view: InviteCardView, at index: Int)
}

//將實作method寫在protocol extension，繼承的子類可以不需要實作method
extension CardContainerDelegate {
    func card(_ view: InviteCardView) {}
    func card(_ view: InviteCardView, at index: Int) {}
    func cardContainer(willDisplay view: InviteCardView, at index: Int) {}
    func cardContainer(willDisplay view: InviteCardView, with innerIndex: Int) {}
    func cardContainer(didSelect view: InviteCardView, at index: Int) {}
}
