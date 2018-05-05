//
//  AnimatedTabBarController.swift
//  AnimatedTabApp
//
//  Created by Imanou on 05/05/2018.
//  Copyright © 2018 Imanou Petit. All rights reserved.
//

import UIKit

class AnimatedTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let animatedTransitioning = AnimatedTransitioning()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissWithStyle))
        navigationItem.leftBarButtonItem = dismissButton

        title = "Animated"
        delegate = self
    }
    
    @objc func dismissWithStyle(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let fromIndex = tabBarController.viewControllers?.index(of: fromVC) else { return nil }
        guard let toIndex = tabBarController.viewControllers?.index(of: toVC) else { return nil }
        animatedTransitioning.reverse = fromIndex > toIndex
        return animatedTransitioning
    }
    
    deinit {
        print("Quit \(type(of: self))")
    }
    
}
