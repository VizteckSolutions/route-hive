//
//  SourceMarkerIconView.swift
//  Routehive
//
//  Created by Mac on 04/12/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class SourceMarkerIconView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    class func instanceFromNib() -> SourceMarkerIconView {
        return UINib(nibName: "SourceMarkerIconView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SourceMarkerIconView
    }

}
