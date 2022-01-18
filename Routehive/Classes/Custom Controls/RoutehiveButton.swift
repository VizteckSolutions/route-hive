//
//  VTButton.swift
//  Help Connect
//
//  Created by Umair Afzal on 13/12/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import Foundation
import UIKit

class RoutehiveButton: UIButton {
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        titleLabel?.font = UIFont.appThemeFontWithSize(16.0)
        backgroundColor = #colorLiteral(red: 0.7921568627, green: 0.1568627451, blue: 0.1921568627, alpha: 1)
        contentHorizontalAlignment = .center
        layer.cornerRadius = 8.0
        layer.borderWidth = 0.0
        setTitleColor(UIColor.ButtonTextColor(), for: UIControlState())
        isUserInteractionEnabled = true
    }
    
    func setEnabled() {
        setup()
    }
    
    func setDisabled() {
        backgroundColor = #colorLiteral(red: 0.5882352941, green: 0.5803921569, blue: 0.5882352941, alpha: 1)
        isUserInteractionEnabled = false
    }
}
