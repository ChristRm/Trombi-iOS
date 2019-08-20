//
//  FiltersPresentTransitionAnimation.swift
//  Trombi
//
//  Created by Chris Rusin on 6/27/17.
//  Copyright © 2017 Chris. All rights reserved.
//

import UIKit

final class FiltersPresentTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    var animationTime: Double = 0.7

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTime
    }

    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let presentedView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view {
            if let presentingView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view {
                let presentingHeight = presentingView.frame.height
                let presentedViewFrame = presentedView.frame
                let startFrame = CGRect(x: presentedViewFrame.origin.x, y: presentingHeight, width: presentedViewFrame.width, height: presentedViewFrame.height)

                presentedView.frame = startFrame

                UIView.animate(withDuration: animationTime,
                               delay: 0,
                               usingSpringWithDamping: 0.75,
                               initialSpringVelocity: 0,
                               options: .curveEaseIn, animations: {
                    presentedView.frame = presentedViewFrame
                }, completion: { _ in
                    transitionContext.completeTransition(true)
                })
            }
        }
    }
}

class BottomBarDismissTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    fileprivate var animationTime: Double = 0.6
    var heightOfBar: CGFloat = 0.0

    convenience init(heightOfBar: CGFloat) {
        self.init()
        self.heightOfBar = heightOfBar
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTime
    }

    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let presentingView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view {
            let presentingViewFrame = presentingView.frame
            var finalFrame: CGRect
            var yPos: CGFloat

            if #available(iOS 11.0, *) {
                yPos = heightOfBar + presentingView.safeAreaInsets.bottom
            } else {
                yPos = heightOfBar
            }
            finalFrame = CGRect(x: presentingViewFrame.origin.x,
                                y: yPos,
                                width: presentingViewFrame.width,
                                height: presentingViewFrame.height)

            UIView.animate(withDuration: animationTime,
                           delay: 0,
                           usingSpringWithDamping: 0.9,
                           initialSpringVelocity: 0,
                           options: .curveLinear,
                           animations: {
                            presentingView.frame = finalFrame
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}
