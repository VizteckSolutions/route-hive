//
//  EmailVerificationPopupViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/19/18.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit
import ObjectMapper

protocol EmailVerificationPopupViewControllerDelegate {
    func didTappedOkButton(viewController: EmailVerificationPopupViewController)
}

class EmailVerificationPopupViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var okButton: RoutehiveButton!
    
    var signIn = Mapper<SignIn>().map(JSON: [:])!
    var delegate: EmailVerificationPopupViewControllerDelegate?
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.roundCorners(uiViewCorners: .top, radius: 20.0)
    }
    
    // MARK:- UIViewController Helper Methods
    
    func setupViewControllerUI() {
        LocalizableEmailVerificationPopup.setLanguage(viewController: self)
    }
    
    // MARK: - Selectors
    
    // MARK: - IBActions
    
    @IBAction func okButtonTapped(_ sender: Any) {
        self.delegate?.didTappedOkButton(viewController: self)
    }
    
    // MARK: - Private Methods

}
