//
//  UIImageView.swift
//  Routehive
//
//  Created by Mac on 19/12/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

extension UIImageView {
    
    func setImage(inTableCell cell: UITableViewCell, withUrl url: URL, placeholder: UIImage?, customCenterX: Double = -1.0) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.layoutIfNeeded()
            cell.layoutIfNeeded()
            
            let filter = self.frame.size.width == 0 || self.frame.size.height == 0 ? nil : AspectScaledToFillSizeFilter(size: self.frame.size)
            self.af_setImage(
                withURL: url,
                placeholderImage: nil,
                filter: filter
            )
        }
    }
}
