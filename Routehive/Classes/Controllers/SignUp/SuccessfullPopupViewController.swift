//
//  SuccessfullPopupViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/19/18.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit

protocol SuccessfullPopupViewControllerDelegate {
    func didTappedContinueButton(viewController: SuccessfullPopupViewController)
}

class SuccessfullPopupViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var continueButton: RoutehiveButton!
    
    var isOfferSubmittedPopup = false
    var delegate: SuccessfullPopupViewControllerDelegate?
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isOfferSubmittedPopup {
            LocalizableSubmittedSuccessfullyPopup.setLanguage(viewController: self)
            logoImageView.image = #imageLiteral(resourceName: "icon_posted")
            
        } else {
            LocalizableSuccessfullEmailPopup.setLanguage(viewController: self)
            logoImageView.image = #imageLiteral(resourceName: "icon_verified")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.roundCorners(uiViewCorners: .top, radius: 20.0)
    }
    
    // MARK: - IBActions
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        delegate?.didTappedContinueButton(viewController: self)
    }
}
