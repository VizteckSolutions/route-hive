//
//  ViewAddressViewControllerPopup.swift
//  Routehive
//
//  Created by Mac on 07/12/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class ViewAddressViewControllerPopup: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    var localizable = [String: String]()
    
    var isPickup = false
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableViewAddressPopup.setLanguage(viewController: self)
        self.dismissOnTap()
        
        if isPickup {
            self.titleLabel.text = localizable[LocalizableViewAddressPopup.pickupTitle] ?? ""
        } else {
            self.titleLabel.text = localizable[LocalizableViewAddressPopup.dropOffTitle] ?? ""
        }
        
        self.detailLabel.text = address
        
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.roundCorners(uiViewCorners: .top, radius: 20)
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
