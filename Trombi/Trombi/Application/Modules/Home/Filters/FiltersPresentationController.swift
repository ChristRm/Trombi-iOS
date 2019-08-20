//
//  BottomBarPresentationController.swift
//  Trombi
//
//  Created by Christian Rusin  on 14/09/2018.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit

final class FiltersPresentationController: UIPresentationController, UIGestureRecognizerDelegate {
    lazy var backgroundView: UIView = self.createDimmingView(0.4)
    
    fileprivate func createDimmingView(_ alpha: CGFloat) -> UIView {
        guard let containerView = containerView else { return UIView(frame: .zero) }
        
        let view = UIView(frame: containerView.bounds)
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: alpha)
        return view
    }
    
    public override func containerViewWillLayoutSubviews() {
        guard let container = self.containerView else { return }
        guard let presented = self.presentedView else { return }
        
        backgroundView.frame = container.bounds
        
        presented.frame = frameOfPresentedViewInContainerView
    }
    
    public override func presentationTransitionWillBegin() {
        guard let container = self.containerView else { return }
        guard let presented = self.presentedView else { return }
        
        backgroundView.alpha = 0.0
        
        container.addSubview(backgroundView)
        container.addSubview(presented)
        
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (_: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.backgroundView.alpha  = 0.8
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let transitionCoordinator = self.presentingViewController.transitionCoordinator
        transitionCoordinator!.animate(alongsideTransition: { (_: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.backgroundView.alpha = 0.0
        }, completion: nil)
    }
}
