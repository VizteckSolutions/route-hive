//
//  UIViewController+VT.swift
//  Labour Choice
//
//  Created by Umair on 21/06/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

extension UIViewController {

    var isModal: Bool {
        return presentingViewController != nil ||
            navigationController?.presentingViewController?.presentedViewController === navigationController ||
            tabBarController?.presentingViewController is UITabBarController
    }
    
    func addCustomBackButton(isFindLabour: Bool = false) {
        let backButton: UIButton = UIButton (type: UIButtonType.custom)
        backButton.setImage(#imageLiteral(resourceName: "btn_back"), for: UIControlState.normal)

        if isFindLabour {
            backButton.addTarget(self, action: #selector(self.backButtonTapped(button:)), for: UIControlEvents.touchUpInside)

        } else {
            backButton.addTarget(self, action: #selector(self.backButtonPressed(button:)), for: UIControlEvents.touchUpInside)
        }

        backButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let barButton = UIBarButtonItem(customView: backButton)

        navigationItem.leftBarButtonItem = barButton
    }

    func addCustomCrossButton() {
        let crossButton: UIButton = UIButton (type: UIButtonType.custom)
        crossButton.setImage(UIImage(named: "btn_cancel"), for: UIControlState.normal)

        crossButton.addTarget(self, action: #selector(self.barCancelButtonTapped(button:)), for: UIControlEvents.touchUpInside)

        crossButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: crossButton)

        navigationItem.leftBarButtonItem = barButton
    }

    @objc func backButtonPressed(button : UIButton) {

        if navigationController != nil {
            navigationController?.popViewController(animated: true)

//            if self.isKind(of: UserInstaBokkContainerViewController.self) {
//                self.dismiss(animated: true, completion: nil)
//            }

        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func barCancelButtonTapped(button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func backButtonTapped(button: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    func topMostViewController() -> UIViewController {

        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }

        if let tab = self as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }

        if self.presentedViewController == nil {
            return self
        }

        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }

        if let tab = self.presentedViewController as? UITabBarController {

            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }

            return tab.topMostViewController()
        }

        return self.presentedViewController!.topMostViewController()
    }

    func dismissOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewControllerOnTap))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
    }

    @objc func dismissViewControllerOnTap(gesture: UIGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
