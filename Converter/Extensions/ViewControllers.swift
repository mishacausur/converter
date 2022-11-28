//
//  ViewControllers.swift
//  Converter
//
//  Created by Misha Causur on 30.10.2022.
//

import UIKit.UIViewController

extension UIViewController {
    
    func add(_ child: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.addChild(child)
            self?.view.addSubview(child.view)
            child.didMove(toParent: self)
        }
    }

    func remove() {
        DispatchQueue.main.async { [weak self] in
            guard self?.parent != nil else { return }
            self?.willMove(toParent: nil)
            self?.view.removeFromSuperview()
            self?.removeFromParent()
        }
    }
}
