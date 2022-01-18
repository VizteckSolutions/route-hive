//
//  UITableView.swift
//  iosProjectAchitecture
//
//  Created by Umair Afzal on 21/05/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.numberOfRows(inSection:  self.numberOfSections-1), section:  self.numberOfSections-1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}

extension UITableViewCell {
    
    func setupActivityIndicator(center: CGPoint) {
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = center
        activityIndicator.tag = 6565
        activityIndicator.color = UIColor.gray
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        self.bringSubview(toFront: activityIndicator)
    }
    
    func stopActivityIndicator() {
        if let activityInficator = self.viewWithTag(6565) {
            activityInficator.removeFromSuperview()
        }
    }
}
