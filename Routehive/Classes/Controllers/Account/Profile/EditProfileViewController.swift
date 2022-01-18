//
//  EditProfileViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/19/18.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit
import ObjectMapper

protocol EditProfileViewControllerDelegate {
    func didTappedSaveButton()
}

class EditProfileViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var firstNameTextField: RoutehiveTextField!
    @IBOutlet weak var lastNameTextField: RoutehiveTextField!
    @IBOutlet weak var phoneNumberTextField: RoutehiveTextField!
    
    var errorFirstName = ""
    var errorLastName = ""
    var errorPhoneNumber = ""
    var errorProfileImage = ""
    var profileSuccess = ""
    
    let saveButton: UIButton = UIButton (type: UIButtonType.custom)
    var delegate: EditProfileViewControllerDelegate?
    var signIn = Mapper<SignIn>().map(JSON: [:])!
    var countryList = Mapper<CountryList>().map(JSON: [:])!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationControllerUI()
        setupViewControllerUI()
    }
    
    // MARK:- UIViewController Helper Methods
    
    func setupViewControllerUI() {
        LocalizableEditProfile.setLanguage(viewController: self)
        loadData()
        firstNameTextField.textFieldDelegate = self
        lastNameTextField.textFieldDelegate = self
        phoneNumberTextField.textFieldDelegate = self
        
        if let url = URL(string: Driver.shared.profileImage) {
            profileImageView.af_setImage(withURL: url)
        }
        
        firstNameTextField.text = Driver.shared.firstName.capitalized
        lastNameTextField.text = Driver.shared.lastName.capitalized
        phoneNumberTextField.text = Driver.shared.phoneNumber
    }
    
    func setupNavigationControllerUI() {
//        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(#colorLiteral(red: 0.8352941176, green: 0, blue: 0, alpha: 1), for: .normal)
        saveButton.addTarget(self, action: #selector(self.saveButtonTapped(button:)), for: UIControlEvents.touchUpInside)
        saveButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        let barButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = barButton
    }
    
    // MARK: - Selectors
    
    @objc func saveButtonTapped(button:UIButton) {
        
        guard isValidInput() else {
            return
        }
        
        signIn.updateProfile(viewController: self, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, pickedImage: profileImageView.image!, phoneCode: countryCodeLabel.text!, phoneNumber: phoneNumberTextField.text!) { (result, error) in
            
            if error == nil {
                
                
                if Driver.shared.phoneCode != self.countryCodeLabel.text || Driver.shared.phoneNumber != self.phoneNumberTextField.text {
                    let verifyNumberViewController = VerifyNumberViewController()
                    verifyNumberViewController.addCustomBackButton()
                    //                    verifyNumberViewController.isSignUp = true
                    verifyNumberViewController.isUpdatePhoneNumber = true
                    verifyNumberViewController.phoneCode = self.countryCodeLabel.text!
                    verifyNumberViewController.phoneNumber = self.phoneNumberTextField.text!
                    verifyNumberViewController.code = result.code
                    verifyNumberViewController.delegate = self
                    self.navigationController?.pushViewController(verifyNumberViewController, animated: true)
                    Utility.saveDriverDataInDefaults(data: result.spData)
                    
                } else {
                    Utility.saveDriverDataInDefaults(data: result.spData)
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.didTappedSaveButton()
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        Utility.presentImagePicker(viewController: self)
    }
    
    @IBAction func countryButtonTapped(_ sender: Any) {
//        let selectCountryViewController = SelectCountryViewController()
//        selectCountryViewController.delegate = self
//        self.present(selectCountryViewController, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    func isValidInput() -> Bool {

        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            firstNameTextField.showErrorView(errorMessage: errorFirstName)
            lastNameTextField.hideErrorView()
            phoneNumberTextField.hideErrorView()
            saveButton.shake()
            firstNameTextField.becomeFirstResponder()
            return false
            
        } else if lastNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            lastNameTextField.showErrorView(errorMessage: errorLastName)
            firstNameTextField.hideErrorView()
            phoneNumberTextField.hideErrorView()
            saveButton.shake()
            lastNameTextField.becomeFirstResponder()
            return false
            
        } else if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            phoneNumberTextField.showErrorView(errorMessage: errorPhoneNumber)
            firstNameTextField.hideErrorView()
            lastNameTextField.hideErrorView()
            saveButton.shake()
            phoneNumberTextField.becomeFirstResponder()
            return false
            
        } else if profileImageView.image == #imageLiteral(resourceName: "icon_default_image") {
            NSError.showErrorWithMessage(message: errorProfileImage, viewController: self, type: .error)
            saveButton.shake()
            return false
        }
        
        return true
    }
    
    func loadData() {
        
        countryList.loadData(viewController: self) { (list, error) in
            self.countryList = list
            
            for code in list.countries {
                
                if code.code == Driver.shared.phoneCode {
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

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, RoutehiveTextFieldDelegate, SelectCountryViewControllerDelegate {

    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
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

extension EditProfileViewController: VerifyNumberViewControllerDelegate {
    
    func numberVerified() {
        NSError.showErrorWithMessage(message: profileSuccess, viewController: self, type: .success)
    }
}
