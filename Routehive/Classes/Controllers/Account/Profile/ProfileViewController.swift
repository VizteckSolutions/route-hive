//
//  ProfileViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/19/18.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit
import ObjectMapper

class ProfileViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberTitleLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var changePasswordButton: UIButton!
    
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondLineView: UIView!
    @IBOutlet weak var thirdLineView: UIView!
    @IBOutlet weak var fourthLineView: UIView!
    
    var profileSuccess = ""
    var PasswordSuccess = ""
    
    let editButton: UIButton = UIButton (type: UIButtonType.custom)
    var signIn = Mapper<SignIn>().map(JSON: [:])!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupNavigationControllerUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         setupViewControllerUI()
    }
    
    // MARK:- UIViewController Helper Methods
    
    func setupViewControllerUI() {
        LocalizableMyProfile.setLanguage(viewController: self)
        populateData()
    }
    
    func setupNavigationControllerUI() {
        editButton.setTitleColor(#colorLiteral(red: 0.8352941176, green: 0, blue: 0, alpha: 1), for: .normal)
        editButton.addTarget(self, action: #selector(self.editButtonTapped(button:)), for: UIControlEvents.touchUpInside)
        editButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        let barButton = UIBarButtonItem(customView: editButton)
        navigationItem.rightBarButtonItem = barButton
    }
    
    // MARK: - Selectors
    
    @objc func editButtonTapped(button:UIButton) {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.addCustomBackButton()
        editProfileViewController.profileSuccess = profileSuccess
        editProfileViewController.signIn = signIn
        editProfileViewController.delegate = self
        self.navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func changePasswordButtonTapped(_ sender: Any) {
        let changePasswordViewController = ChangePasswordViewController()
        changePasswordViewController.addCustomBackButton()
        changePasswordViewController.delegate = self
        self.navigationController?.pushViewController(changePasswordViewController, animated: true)
    }
    
    // MARK: - Private Methods
    
    func populateData() {
        self.phoneNumberLabel.text = Driver.shared.phoneCode + Driver.shared.phoneNumber
        
        if Driver.shared.name != "" {
            nameLabel.text = Driver.shared.name.capitalized
            
        } else {
            nameLabel.text = Driver.shared.firstName.capitalized + " " + Driver.shared.lastName.capitalized
        }
        
        self.emailLabel.text = Driver.shared.email
        
        if let url = URL(string: Driver.shared.profileImage) {
            self.profileImageView.af_setImage(withURL: url)
        }
        
        firstLineView.isHidden = false
        secondLineView.isHidden = false
        thirdLineView.isHidden = false
        fourthLineView.isHidden = false
    }
}

extension ProfileViewController: ChangePasswordViewControllerDelegate, EditProfileViewControllerDelegate {
    
    // MARK: - EditProfileViewControllerDelegate
    
    func didTappedSaveButton() {
        NSError.showErrorWithMessage(message: profileSuccess, viewController: self, type: .success)
    }
    
    // MARK: - ChangePasswordViewControllerDelegate
    
    func didTappedChangePasswordButton() {
        NSError.showErrorWithMessage(message: PasswordSuccess, viewController: self, type: .success)
    }
}
