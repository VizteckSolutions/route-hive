//
//  BackUpDriverPopupViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/25/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class BackUpDriverPopupViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var okButton: RoutehiveButton!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableBackupDriver.setLanguage(viewController: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.roundCorners(uiViewCorners: .top, radius: 20)
    }
    // MARK: - IBActions
    
    @IBAction func okayButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
