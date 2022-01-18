//
//  UINavigationController+VT.swift
//  Labour Choice
//
//  Created by Umair on 6/19/17.
//  Copyright © 2017 Umair. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {

    func transparentNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.barTintColor = UIColor.clear
        self.navigationBar.backgroundColor = .clear
    }

    func setupHomeNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationBar.isTranslucent = true
    }

    func setAttributedTitle() {
        let attributes = [NSAttributedStringKey.font: UIFont.appThemeFontWithSize(17.0), NSAttributedStringKey.foregroundColor: UIColor.white] //change size as per your need here.
        self.navigationBar.titleTextAttributes = attributes
    }

    func nonTransparentNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(color: #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 1)), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = .black
        self.navigationBar.backgroundColor = #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 1)
    }

    func setupAppThemeNavigationBar() {
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) , NSAttributedStringKey.font: UIFont.appThemeFontWithSize(17.0)]
    }
    
    func popTo(viewController: AnyClass) {
        
        for controller in self.viewControllers as Array {
            if controller.isKind(of: viewController) {
                self.popToViewController(controller, animated: true)
                break
            }
        }
    }
}
