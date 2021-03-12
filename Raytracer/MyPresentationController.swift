//
//  MyPresentationController.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 11.03.21.
//

import UIKit

class MyPresentationController: UIPresentationController {
    
    let height:CGFloat
    
    init(presentedViewController: UIViewController, presentingViewController: UIViewController?, height:CGFloat) {
        self.height = height
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = CGSize(width: containerView!.bounds.width, height: height)
        frame.origin.y = containerView!.frame.height - height
        return frame
    }
    
}
