//
//  ShareRaferralViewController.swift
//  Routehive
//
//  Created by Mac on 19/09/2018.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit

class ShareRaferralViewController: UIViewController {

    // MARK: - Variables & Constants
    
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var messageDetailLabel: UILabel!
    @IBOutlet weak var referralCodeTextField: RoutehiveTextField!
    @IBOutlet weak var copyButton: UIButton!
    
    var referalMessage = ""
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupViewControllerUI() {
        LocalizableReferalCode.setLanguage(viewController: self)
        referralCodeTextField.text = Driver.shared.referralCode
    }
    
    // MARK: - IBActions
    
    @IBAction func copyButtonTapped(_ sender: Any) {
        UIPasteboard.general.string = referralCodeTextField.text!
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        referalMessage = referalMessage.replacingOccurrences(of: "%s", with: referralCodeTextField.text!)
        let shareMessage = referalMessage + "\n" + "IOS: \(Driver.shared.iosRiderAppUrl)" + "\n" + "Android: \(Driver.shared.androidRiderAppUrl)"
        let activityItems: [Any] = [shareMessage]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        present(activityController, animated: true, completion: nil)
    }
}
