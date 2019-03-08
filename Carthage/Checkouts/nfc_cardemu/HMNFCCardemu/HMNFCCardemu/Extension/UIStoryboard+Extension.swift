//  UIStoryboard.swift
//  Created on 2018/1/26
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

import UIKit

extension Bundle {
    static var NFCCardemu: Bundle? {
        return Bundle(for: CardDetectionViewController.self)
    }
}

extension UINib {
    convenience init(cardemulet nibName: String) {
        self.init(nibName: nibName, bundle: Bundle.NFCCardemu)
    }
}

extension UIStoryboard {

    enum StoryBoard: String  {
        case Detection = "Detection"
        case OpenCard = "OpenCard"
    }

    convenience init(openCard storyBoard: StoryBoard) {
        self.init(name: storyBoard.rawValue, bundle: Bundle.NFCCardemu)
    }

    func instantiate<T: UIViewController>() -> T {
        let vc = self.instantiateViewController(withIdentifier: T.storyboardIdentifier)
        guard let _ = vc as? T else {
            fatalError("can't instance vc with identifier \(T.storyboardIdentifier)")
        }
        return vc as! T
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return "\(self)"
    }
}

extension UIViewController: StoryboardIdentifiable {}
