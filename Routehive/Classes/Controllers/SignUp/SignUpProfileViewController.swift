//
//  SignUpProfileViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/19/18.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit
import ObjectMapper

class SignUpProfileViewController: UIViewController {

    // MARK: - Variables & Constants
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var firstNameTextField: RoutehiveTextField!
    @IBOutlet weak var lastNameTextField: RoutehiveTextField!
    @IBOutlet weak var phoneNumberTextField: RoutehiveTextField!
    @IBOutlet weak var passwordTextField: RoutehiveTextField!
    @IBOutlet weak var referalCodeTextField: RoutehiveTextField!
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var termsCheckButton: UIButton!
    @IBOutlet weak var termsConditionButton: UIButton!
    
    @IBOutlet weak var termsTextView: UITextView!
    @IBOutlet weak var continueButton: RoutehiveButton!
    @IBOutlet weak var passwordVisibleButton: UIButton!
    
    var errorEmptyFirstName = ""
    var errorEmptyLastName = ""
    var errorEmptyPhoneNumber = ""
    var errorEmptyPassword = ""
    var errorInvalidPassword = ""
    var errorProfileImage = ""
    var errorTermsConditions = ""
    
    var personalInfo = SignUpData()
    var signIn = Mapper<SignIn>().map(JSON: [:])!
    var countryList = Mapper<CountryList>().map(JSON: [:])!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    // MARK:- UIViewController Helper Methods
    
    func setupViewControllerUI() {
        LocalizableSignUpProfile.setLanguage(viewController: self)
        
        firstNameTextField.text = Driver.shared.firstName
        lastNameTextField.text = Driver.shared.lastName
        
        if let url = URL(string: Driver.shared.profileImage) {
            profileImageView.af_setImage(withURL: url)
        }
        
        firstNameTextField.textFieldDelegate = self
        lastNameTextField.textFieldDelegate = self
        phoneNumberTextField.textFieldDelegate = self
        passwordTextField.textFieldDelegate = self
        
        loadData()
    }
    
    // MARK: - Selectors
    
    // MARK: - IBActions
    
    @IBAction func selectCountryButtonTapped(_ sender: Any) {
//        let selectCountryViewController = SelectCountryViewController()
//        selectCountryViewController.delegate = self
//        self.present(selectCountryViewController, animated: true, completion: nil)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard isValidInput() else {
            return
        }
        personalInfo.firstName = firstNameTextField.text!
        personalInfo.lastName = lastNameTextField.text!
        personalInfo.phoneCode = countryCodeLabel.text!
        personalInfo.phoneNumber = phoneNumberTextField.text!
        personalInfo.password = passwordTextField.text!
        personalInfo.referralCode = referalCodeTextField.text!

        signIn.updatePersonelInfo(viewController: self, personalInfo: personalInfo, pickedImage: profileImageView.image!) { (result, error) in
            
            if error == nil {
                self.saveSPData()
                let verifyNumberViewController = VerifyNumberViewController()
                verifyNumberViewController.addCustomBackButton()
                verifyNumberViewController.isSignUp = true
                verifyNumberViewController.phoneCode = self.countryCodeLabel.text!
                verifyNumberViewController.phoneNumber = self.phoneNumberTextField.text!
                verifyNumberViewController.code = result.code
                self.navigationController?.pushViewController(verifyNumberViewController, animated: true)
            }
        }
    }
    
    @IBAction func termsCheckButtonTapped(_ sender: Any) {
        
        if !personalInfo.acceptedTerms {
            personalInfo.acceptedTerms = true
            termsCheckButton.setImage(#imageLiteral(resourceName: "checkbox_checked"), for: .normal)
            
        } else {
            personalInfo.acceptedTerms = false
            termsCheckButton.setImage(#imageLiteral(resourceName: "checkbox"), for: .normal)
        }
    }
    
    @IBAction func termsConditionButtonTapped(_ sender: Any) {
    }
    
    @IBAction func passwordVisibleButtonTapped(_ sender: Any) {
        
        if passwordVisibleButton.tag == 0 {
            passwordVisibleButton.setImage(#imageLiteral(resourceName: "icon_view_password"), for: .normal)
            passwordVisibleButton.tag = 1
            passwordTextField.isSecureTextEntry = false
            
        } else {
            passwordVisibleButton.setImage(#imageLiteral(resourceName: "icon_hide_password"), for: .normal)
            passwordVisibleButton.tag = 0
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        Utility.presentImagePicker(viewController: self)
    }
    
    // MARK: - Private Methods
    
    
    func saveSPData() {
        Driver.shared.firstName = personalInfo.firstName
        Driver.shared.lastName = personalInfo.lastName
        Driver.shared.phoneNumber = personalInfo.phoneNumber
        Driver.shared.phoneCode = personalInfo.phoneCode
        Driver.shared.profileImage = personalInfo.profileImage
        
        UserDefaults.standard.set(personalInfo.firstName, forKey: kSPFirstName)
        UserDefaults.standard.set(personalInfo.lastName, forKey: kSPLastName)
        UserDefaults.standard.set(personalInfo.phoneNumber, forKey: kSPMobile)
        UserDefaults.standard.set(personalInfo.phoneCode, forKey: kSPMobilecode)
        UserDefaults.standard.set(personalInfo.profileImage, forKey: kSPProfileImageUrl)
    }
    
    func isValidInput() -> Bool {
        hideErrorViews()
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            firstNameTextField.showErrorView(errorMessage: errorEmptyFirstName)
            continueButton.shake()
            firstNameTextField.becomeFirstResponder()
            return false
            
        } else if lastNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            lastNameTextField.showErrorView(errorMessage: errorEmptyLastName)
            continueButton.shake()
            lastNameTextField.becomeFirstResponder()
            return false
            
        } else if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            phoneNumberTextField.showErrorView(errorMessage: errorEmptyPhoneNumber)
            continueButton.shake()
            phoneNumberTextField.becomeFirstResponder()
            return false
            
        } else if passwordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            passwordTextField.showErrorView(errorMessage: errorEmptyPassword)
            continueButton.shake()
            passwordTextField.becomeFirstResponder()
            return false
            
        } else if !(passwordTextField.text?.isValidPassword())! {
            passwordTextField.showErrorView(errorMessage: errorInvalidPassword)
            continueButton.shake()
            passwordTextField.becomeFirstResponder()
            return false
            
        } else if profileImageView.image == #imageLiteral(resourceName: "icon_default_image") {
            NSError.showErrorWithMessage(message: errorProfileImage, viewController: self, type: .error)
            continueButton.shake()
            return false
            
        } else if !personalInfo.acceptedTerms {
            NSError.showErrorWithMessage(message: errorTermsConditions, viewController: self, type: .error)
            continueButton.shake()
            return false
        }
        
        return true
    }
    
    func hideErrorViews() {
        firstNameTextField.hideErrorView()
        lastNameTextField.hideErrorView()
        phoneNumberTextField.hideErrorView()
        passwordTextField.hideErrorView()
    }
    
    func loadData() {
        
        countryList.loadData(viewController: self) { (list, error) in
            self.countryList = list
            
            for code in list.countries {
                
                if code.code == Driver.shared.countryCode {
                    self.countryCodeLabel.text = code.code
                    self.phoneNumberTextField.maxLength = code.numberLength
                    
                    if let url = URL(string: code.imageUrl) {
                        self.flagImageView.af_setImage(withURL: url)
                    }
                    break
                }
            }
        }
    }
}

extension SignUpProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageView.image = pickedImage
//            uploadProfileImage()
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpProfileViewController: RoutehiveTextFieldDelegate, SelectCountryViewControllerDelegate {
    
    // MARK: - RoutehiveTextFieldDelegate
    
    func shouldChangeCharecter(_ textField: UITextField) {
        
        if let customTextfield = textField as? RoutehiveTextField {
            customTextfield.hideErrorView()
        }
    }
    
    // MARK: - SelectCountryViewControllerDelegate
    
    func didSelectCuontry(code: String, flag: UIImage) {
        countryCodeLabel.text = code
        flagImageView.image = flag
    }
}

class SignUpData {
    var firstName = ""
    var lastName = ""
    var phoneCode = ""
    var phoneNumber = ""
    var password = ""
    var profileImage = ""
    var acceptedTerms = false
    var referralCode = ""
}
