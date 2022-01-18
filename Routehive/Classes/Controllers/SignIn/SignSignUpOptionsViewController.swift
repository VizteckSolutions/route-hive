//
//  SignSignUpOptionsViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/25/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class SignSignUpOptionsViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUIViewController()
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupUIViewController() {
        LocalizableSignInSignUpOptions.setLanguage(viewController: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - IBActions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        Utility.setupLoginAsRootViewController()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        Utility.setupSignUpAsRootViewController()
    }
}
