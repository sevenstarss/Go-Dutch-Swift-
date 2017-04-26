//
//  MainTabBarController.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 27.12.16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit
import TransitionTreasury
import TransitionAnimation

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView  : UIView = viewController.view
        if fromView == toView {
            return false
        }
        
        let viewSize = fromView.frame
        fromView.superview?.addSubview(toView)
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        toView.frame = CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: viewSize.size.height)
        UIView.animate(withDuration: 0.3, animations: {
            toView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: viewSize.size.height)
        }) { (finished) in
            if finished {
                fromView.removeFromSuperview()
            }
        }
        
        return true
    }
}
