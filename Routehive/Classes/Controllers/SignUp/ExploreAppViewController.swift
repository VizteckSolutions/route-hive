//
//  ExploreAppViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/24/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class ExploreAppViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var exploreAppButton: RoutehiveButton!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableEploreApp.setLanguage(viewController: self)
    }
    
    // MARK: - IBActions
    
    @IBAction func exploreAppButtonTapped(_ sender: Any) {
        Utility.setupHomeViewController()
    }
}
