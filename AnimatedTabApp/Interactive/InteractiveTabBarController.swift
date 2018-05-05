//
//  InteractiveTabBarController.swift
//  AnimatedTabApp
//
//  Created by Imanou on 05/05/2018.
//  Copyright © 2018 Imanou Petit. All rights reserved.
//

import UIKit

class InteractiveTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let rightGestureRecognizer = UIScreenEdgePanGestureRecognizer()
    let leftGestureRecognizer = UIScreenEdgePanGestureRecognizer()
    let animatedTransitioning = AnimatedTransitioning()
    var interactiveTransitioning = UIPercentDrivenInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Interactive"
        delegate = self
        
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissWithStyle))
        navigationItem.leftBarButtonItem = dismissButton

        rightGestureRecognizer.edges = .right
        leftGestureRecognizer.edges = .left
        rightGestureRecognizer.addTarget(self, action: #selector(handlePanGesture))
        leftGestureRecognizer.addTarget(self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(rightGestureRecognizer)
        view.addGestureRecognizer(leftGestureRecognizer)
    }
    
    @objc func dismissWithStyle(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Gesture recognizers selectors
    
    @objc func handlePanGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            guard let indices = viewControllers?.indices else { return }
            if gestureRecognizer.edges == .right {
                selectedIndex = indices.index(selectedIndex, offsetBy: 1, limitedBy: indices.endIndex - 1) ?? selectedIndex
            } else if gestureRecognizer.edges == .left {
                selectedIndex = indices.index(selectedIndex, offsetBy: -1, limitedBy: indices.startIndex) ?? selectedIndex
            }
        case .changed:
            interactiveTransitioning.update(percentForGesture(gestureRecognizer))
        case .cancelled, .ended:
            percentForGesture(gestureRecognizer).magnitude >= 0.5 ? interactiveTransitioning.finish() : interactiveTransitioning.cancel()
        default:
            // Something happened, cancel the transition
            interactiveTransitioning.cancel()
        }
    }
    
    func percentForGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        let locationInSourceView = gestureRecognizer.location(in: view)
        let width = view.bounds.width

        // Return an appropriate percentage based on which edge we're dragging from
        switch gestureRecognizer.edges {
        case UIRectEdge.right:  return (width - locationInSourceView.x) / width
        case UIRectEdge.left:   return locationInSourceView.x / width
        default:                return 0
        }
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let fromIndex = tabBarController.viewControllers?.index(of: fromVC) else { return nil }
        guard let toIndex = tabBarController.viewControllers?.index(of: toVC) else { return nil }
        animatedTransitioning.reverse = fromIndex > toIndex
        return animatedTransitioning
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        for gestureRecognizer in view.gestureRecognizers! where gestureRecognizer is UIScreenEdgePanGestureRecognizer {
            if [UIGestureRecognizerState.began, .changed].contains(gestureRecognizer.state) {
                return interactiveTransitioning
            }
        }
        return nil
    }
    
    deinit {
        print("Quit \(type(of: self))")
    }
    
}
