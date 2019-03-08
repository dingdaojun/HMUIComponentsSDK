//
//  CardAnimationOption.swift
//  Demo
//
//  Created by Karsa Wu on 2018/7/21.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import Foundation
import UIKit

struct CardAnimationConst {
    static let rotationStrength: CGFloat = 320
    static let rotationMax: CGFloat      = 1.0
    static let rotationAngle: CGFloat    = .pi * 0.125
    static let scaleStrength: CGFloat    = 4.0
    static let scaleMax: CGFloat         = 0.93
    static let actionMargin: CGFloat     = 120
}


struct  CardAnimationOption {
    var numberOfVisibleItems: Int
    var offset: (horizon: CGFloat, vertical: CGFloat)
    var showedCyclically: Bool
    var isPanGestureEnabled : Bool
    
    init(numberOfVisibleItems :Int = 3, offset: (horizon: CGFloat, vertical: CGFloat) = (5, 5), showedCyclically: Bool = true, isPanGestureEnabled: Bool = true ) {
        
        self.numberOfVisibleItems = numberOfVisibleItems
        self.offset = offset
        self.showedCyclically  = showedCyclically
        self.isPanGestureEnabled = isPanGestureEnabled
    }
}

