//
//  MarkerIconView.swift
//  Routehive
//
//  Created by Mac on 19/10/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class MarkerIconView: UIView {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceUnit: UILabel!
    
    class func instanceFromNib() -> MarkerIconView {
        return UINib(nibName: "MarkerIconView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MarkerIconView
    }
}
