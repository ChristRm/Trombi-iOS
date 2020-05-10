//
//  FiletersPanelViewController.swift
//  Trombi
//
//  Created by Christian Rusin  on 13/09/2018.
//  Copyright © 2018 Chris Rusin. All rights reserved.
//

import UIKit

extension FiltersPanelViewController {
    // MARK: - Constants
    
    fileprivate enum Defaults {
        static let updateAnimationDuration = 0.3
    }
}

final class FiltersPanelViewController: UIViewController {
    
    // MARK: - Properties
    
    var filtersViewViewModel: FiltersViewViewModel?
    
    fileprivate var currentlyDisplayedBar: BottomPanel?

    // MARK: - IBOutlet
    
    @IBOutlet fileprivate weak var containerBottomConstraint: NSLayoutConstraint?
    @IBOutlet fileprivate weak var widthConstraint: NSLayoutConstraint?
    @IBOutlet fileprivate weak var bottomConstraint: NSLayoutConstraint?
    
    @IBOutlet fileprivate weak var barContainer: UIView?
    
    // MARK: - init
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    public override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }
    
    private func commonInit() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widthConstraint?.constant = widthOfPanel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let currentlyDisplayedBar = currentlyDisplayedBar {
            setBarHeight(currentlyDisplayedBar.heightOfPanel)

            if let barToDisplayView = (currentlyDisplayedBar as? UIViewController)?.view {
                barToDisplayView.isHidden = false
                initialBarContainerFrame = barContainer?.frame
                barContainer?.bringSubviewToFront(barToDisplayView.superview!)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barContainer?.roundCorners([.topLeft, .topRight], radius: 19.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let filtersViewController = segue.destination as? FiltersViewController {
            filtersViewController.panelIdentifier = segue.identifier
            filtersViewController.widthOfPanel = widthOfPanel()
            filtersViewController.bottomPanelDelegate = self
            filtersViewController.viewModel = filtersViewViewModel

            currentlyDisplayedBar = filtersViewController
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func cancelAreaTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private methods

    private func widthOfPanel() -> CGFloat {
        let isIpad = (UIDevice.current.userInterfaceIdiom == .pad)
        let screenWidth = UIScreen.main.bounds.width
        return isIpad ? screenWidth / 1.5 : screenWidth
    }
    
    private func setBarHeight(_ height: CGFloat) {
        containerBottomConstraint?.constant = height - UIScreen.main.bounds.height
    }

    // MARK: - Gesture handling

    // define a variable to store initial touch position
    private var initialBarContainerFrame: CGRect?

    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {

        guard let safeBarContainer = barContainer else { return }
        guard let safeInitialBarContainerFrame = initialBarContainerFrame else { return }

        let translation = sender.translation(in: barContainer)
        var initialYPos: CGFloat
        if #available(iOS 11.0, *) {
            initialYPos = safeInitialBarContainerFrame.origin.y - safeBarContainer.safeAreaInsets.bottom
        } else {
            initialYPos = safeInitialBarContainerFrame.origin.y
        }

        if sender.state == .changed {
            if translation.y > 0 {
                self.barContainer?.frame = CGRect(x: 0,
                                                  y: initialYPos + translation.y,
                                                  width: safeInitialBarContainerFrame.size.width,
                                                  height: safeInitialBarContainerFrame.size.height)
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            let visibleContainerBar = safeInitialBarContainerFrame.size.height - safeInitialBarContainerFrame.origin.y
            if translation.y > visibleContainerBar/3 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.6,
                               delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0,
                               options: .curveEaseOut,
                               animations: { [weak self] in
                    self?.barContainer?.frame = CGRect(x: safeInitialBarContainerFrame.origin.x,
                                                      y: initialYPos,
                                                      width: safeInitialBarContainerFrame.width,
                                                      height: safeInitialBarContainerFrame.height)
                })
            }
        }
    }
}

// MARK: - BottomPanelDelegate
extension FiltersPanelViewController: BottomPanelDelegate {
    
    func bottomPanel(_ bottomPanel: BottomPanel, willChange height: CGFloat, animated: Bool) {
        let animationDuration = animated ? Defaults.updateAnimationDuration : 0.0

        UIView.animate(withDuration: animationDuration) {
            self.setBarHeight(height)
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension FiltersPanelViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        if presented == self {
            return FiltersPresentationController(presentedViewController: presented,
                                                   presenting: presenting)
        }
        
        return nil
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let barToDisplay = currentlyDisplayedBar else {
            fatalError("Cannot get panel for Filters")
        }

        return BottomBarDismissTransitionAnimation(heightOfBar: barToDisplay.heightOfPanel)
    }
    
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FiltersPresentTransitionAnimation()
    }
}
