//
//  CardAnimationView.swift
//  Demo
//
//  Created by Karsa Wu on 2018/7/21.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit

protocol CardAnimationViewDataSource {
    func numberOfTotalCards(in cards: CardAnimationView) -> Int
    
    func view(for cards:CardAnimationView, index:Int, reusingView: UIView?) -> UIView
}

protocol CardAnimationViewDelegate {
    
    func cards(_ cards: CardAnimationView, beforeSwipingItemAt index: Int)
    func cards(_ cards: CardAnimationView, didRemovedItemAt index: Int)
    func cards(_ cards: CardAnimationView, didLeftRemovedItemAt index: Int)
    func cards(_ cards: CardAnimationView, didRightRemovedItemAt index: Int)
    func cards(_ cards: CardAnimationView, didManualRemovedItemAt index: Int)
}

//拓展进行默认实现，让该代理的方法变为 Optional
extension CardAnimationViewDelegate {
    func cards(_ cards: CardAnimationView, beforeSwipingItemAt index: Int) {}
    func cards(_ cards: CardAnimationView, didRemovedItemAt index: Int) {}
    func cards(_ cards: CardAnimationView, didLeftRemovedItemAt index: Int) {}
    func cards(_ cards: CardAnimationView, didRightRemovedItemAt index: Int) {}
    func cards(_ cards: CardAnimationView, didManualRemovedItemAt index: Int) {}
}


class CardAnimationView: UIView {

    //MARK: - Private
//    var options: CardAnimationOption
    fileprivate var currentIndex = 0
    fileprivate var reusingView: UIView? = nil
    fileprivate var visibleCards = [UIView]()
    fileprivate var swipeEnded = true
    fileprivate var xFromCenter: CGFloat = 0
    fileprivate var yFromCenter: CGFloat = 0
    fileprivate var originalPoint = CGPoint.zero
    
    fileprivate lazy var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragAction(_:)) )
    
    
    /// DataSource
    var dataSource: CardAnimationViewDataSource? {
        didSet {
            reloadData()
        }
    }
    /// Delegate
    var delegate: CardAnimationViewDelegate?
    
    var options: CardAnimationOption {
        didSet {
            setUp()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // //MARK: - init
    required init?(coder aDecoder: NSCoder) {
        options = CardAnimationOption()
        super.init(coder: aDecoder)
    }
    
    override convenience init(frame: CGRect) {
        self.init(options: CardAnimationOption(), frame: frame)
    }
    
    init (options: CardAnimationOption, frame: CGRect ) {
        self.options = options;
        super.init(frame: frame)
    }
    
    func setUp() {
        self.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.isEnabled = options.isPanGestureEnabled;
    }
    
    /**
     Refresh to show data source
     */
    func reloadData() {
        currentIndex = 0
        reusingView = nil
        visibleCards.removeAll()
        if let totalNumber = dataSource?.numberOfTotalCards(in: self) {
            let visibleNumber = options.numberOfVisibleItems > totalNumber ? totalNumber : options.numberOfVisibleItems
            
            for i in 0..<visibleNumber {
                if let card = dataSource?.view(for: self, index: i, reusingView: reusingView) {
                    visibleCards.append(card)
                }
            }
        }
        layoutCards()
    }
    
    
    fileprivate func layoutCards() {
        let count = visibleCards.count
        guard count > 0 else {
            return
        }
        
        subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        layoutIfNeeded()
        let width = frame.size.width
        let height = frame.size.height
        if let lastCard = visibleCards.last {
            let cardWidth = lastCard.frame.size.width
            let cardHeight = lastCard.frame.size.height
            if let totalNumber = dataSource?.numberOfTotalCards(in: self) {
                
                let visibleNumber = options.numberOfVisibleItems > totalNumber ? totalNumber : options.numberOfVisibleItems
                
                var firstCardX = (width - cardWidth - CGFloat(visibleNumber - 1) * fabs(options.offset.horizon)) * 0.5
                if options.offset.horizon < 0 {
                    firstCardX += CGFloat(visibleNumber - 1) * fabs(options.offset.horizon)
                }
                
                var firstCardY = (height - cardHeight - CGFloat(visibleNumber - 1) * fabs(options.offset.vertical)) * 0.5
                if options.offset.vertical < 0 {
                    firstCardY += CGFloat(visibleNumber - 1) * fabs(options.offset.vertical)
                }
                
                UIView.animate(withDuration: 0.08) {
                    for i in 0..<count {
                        let index = count - 1 - i   //add cards form back to front
                        let card = self.visibleCards[index]
                        let size = card.frame.size
                        
                        card.frame = CGRect(x: firstCardX + CGFloat(index) * self.options.offset.horizon, y: firstCardY + CGFloat(index) * self.options.offset.vertical, width: size.width , height: size.height)
                        self.addSubview(card)
                    }
                }
            }
        }
    }
    
    // MARK: Manual swipe the view
    func swipeViewManual() {
        guard visibleCards.count > 0 else {
            return
        }
        
        if let totalNumber = dataSource?.numberOfTotalCards(in: self) {
            if currentIndex > totalNumber - 1 {
                currentIndex = 0
            }
        }
        
        if swipeEnded {
            swipeEnded = false
            delegate?.cards(self, beforeSwipingItemAt: currentIndex)
        }
        
        if let firstCard = visibleCards.first {
            originalPoint = firstCard.center
            let finishPoint = CGPoint(x: originalPoint.x, y: -300)
            UIView.animate(withDuration: 0.5, animations: {
                firstCard.center = finishPoint
            }) { (Bool) in
                self.delegate?.cards(self, didManualRemovedItemAt: self.currentIndex)
                self.cardSwipedAction(firstCard)
            }
            
        }
    }
    
    
    // MARK: PanGesture swipe the view
    @objc func dragAction(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard visibleCards.count > 0 else {
            return
        }
        
        if let totalNumber = dataSource?.numberOfTotalCards(in: self) {
            if currentIndex > totalNumber - 1 {
                currentIndex = 0
            }
        }
        
        if swipeEnded {
            swipeEnded = false
            delegate?.cards(self, beforeSwipingItemAt: currentIndex)
        }
        
        if let firstCard = visibleCards.first {
            xFromCenter = gestureRecognizer.translation(in: firstCard).x  // positive for right swipe, negative for left
            yFromCenter = gestureRecognizer.translation(in: firstCard).y  // positive for up, negative for down
            switch gestureRecognizer.state {
            case .began:
                originalPoint = firstCard.center
            case .changed:
                let rotationStrength: CGFloat = min(xFromCenter / CardAnimationConst.rotationStrength, CardAnimationConst.rotationMax)
                let rotationAngel = CardAnimationConst.rotationAngle * rotationStrength
                let scale = max(1.0 - fabs(rotationStrength) / CardAnimationConst.scaleStrength, CardAnimationConst.scaleMax)
                
                firstCard.center = CGPoint(x: originalPoint.x + xFromCenter, y: originalPoint.y + yFromCenter)
                let transform = CGAffineTransform(rotationAngle: rotationAngel)
                let scaleTransform = transform.scaledBy(x: scale, y: scale)
                firstCard.transform = scaleTransform
            case .ended:
                afterSwipedAction(firstCard)
            default:
                break
            }
        }
    }
    
    func afterSwipedAction(_ card: UIView) {
        if xFromCenter > CardAnimationConst.actionMargin {
            rightActionFor(card)
        } else if xFromCenter < -CardAnimationConst.actionMargin {
            leftActionFor(card)
        } else {
            self.swipeEnded = true
            UIView.animate(withDuration: 0.3) {
                card.center = self.originalPoint
                card.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
        
    }
    
    func rightActionFor(_ card: UIView) {
        let finishPoint = CGPoint(x: 500, y: 2.0 * yFromCenter + originalPoint.y)
        UIView.animate(withDuration: 0.3, animations: {
            card.center = finishPoint
        }) { (Bool) in
            self.delegate?.cards(self, didRightRemovedItemAt: self.currentIndex)
            self.cardSwipedAction(card)
        }
    }
    
    
    func leftActionFor(_ card: UIView) {
        let finishPoint = CGPoint(x: -500, y: 2.0 * yFromCenter + originalPoint.y)
        UIView.animate(withDuration: 0.3, animations: {
            card.center = finishPoint
        }) { (Bool) in
            self.delegate?.cards(self, didLeftRemovedItemAt: self.currentIndex)
            self.cardSwipedAction(card)
        }
    }
    
    
    func cardSwipedAction(_ card: UIView) {
        swipeEnded = true
        card.transform = CGAffineTransform(rotationAngle: 0)
        card.center = originalPoint
        let cardFrame = card.frame
        reusingView = card
        visibleCards.removeFirst()
        card.removeFromSuperview()
        var newCard: UIView?
        if let totalNumber = dataSource?.numberOfTotalCards(in: self) {
            var newIndex = currentIndex + options.numberOfVisibleItems
            if newIndex < totalNumber {
                newCard = dataSource?.view(for: self, index: newIndex, reusingView: reusingView)
            } else {
                if options.showedCyclically {
                    if totalNumber==1 {
                        newIndex = 0
                    } else {
                        newIndex %= totalNumber
                    }
                    newCard = dataSource?.view(for: self, index: newIndex, reusingView: reusingView)
                }
            }
            
            if let card = newCard {
                card.frame = cardFrame
                visibleCards.append(card)
            }
            
            delegate?.cards(self, didRemovedItemAt: currentIndex)
            currentIndex += 1
            layoutCards()
        }
    }


}
