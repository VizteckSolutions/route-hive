//
//  ChangePasswordViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/19/18.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit
import ObjectMapper

protocol ChangePasswordViewControllerDelegate {
    func didTappedChangePasswordButton()
}

class ChangePasswordViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var currentPasswordTextField: RoutehiveTextField!
    @IBOutlet weak var newPasswordTextField: RoutehiveTextField!
    @IBOutlet weak var confirmNewPasswordTextField: RoutehiveTextField!
    @IBOutlet weak var changePasswordButton: RoutehiveButton!
    
    var errorEmptyCurrentPassword = ""
    var errorEmptyNewPassword = ""
    var errorEmptyConfirmPassword = ""
    var errorPasswordMissMatch = ""
    
    var delegate: ChangePasswordViewControllerDelegate?
    var signIn = Mapper<SignIn>().map(JSON: [:])!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupViewControllerUI() {
        currentPasswordTextField.textFieldDelegate = self
        newPasswordTextField.textFieldDelegate = self
        confirmNewPasswordTextField.textFieldDelegate = self
        
        LocalizableChangePassword.setLanguage(viewController: self)
    }
    
    // MARK: - IBActions
    
    @IBAction func changePasswordButtonTapped(_ sender: Any) {
        
        guard isValidInput() else {
            return
        }
        
        signIn.changePassword(viewController: self, currentPassword: currentPasswordTextField.text!, password: newPasswordTextField.text!) { (result, error) in
            
            if error == nil {
                self.navigationController?.popViewController(animated: true)
                self.delegate?.didTappedChangePasswordButton()
            }
        }
    }
    
    // MARK: - Private Methods

    func isValidInput() -> Bool {
        
        if currentPasswordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            currentPasswordTextField.showErrorView(errorMessage: errorEmptyCurrentPassword)
            newPasswordTextField.hideErrorView()
            confirmNewPasswordTextField.hideErrorView()
            changePasswordButton.shake()
            currentPasswordTextField.becomeFirstResponder()
            return false
            
        } else if newPasswordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            newPasswordTextField.showErrorView(errorMessage: errorEmptyNewPassword)
            currentPasswordTextField.hideErrorView()
            confirmNewPasswordTextField.hideErrorView()
            changePasswordButton.shake()
            newPasswordTextField.becomeFirstResponder()
            return false
            
        } else if confirmNewPasswordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            confirmNewPasswordTextField.showErrorView(errorMessage: errorEmptyConfirmPassword)
            currentPasswordTextField.hideErrorView()
            newPasswordTextField.hideErrorView()
            changePasswordButton.shake()
            confirmNewPasswordTextField.becomeFirstResponder()
            return false
            
        } else if newPasswordTextField.text != confirmNewPasswordTextField.text {
            confirmNewPasswordTextField.showErrorView(errorMessage: errorPasswordMissMatch)
            currentPasswordTextField.hideErrorView()
            newPasswordTextField.hideErrorView()
            changePasswordButton.shake()
            confirmNewPasswordTextField.becomeFirstResponder()
            return false
        }
        return true
    }
}

extension ChangePasswordViewController: RoutehiveTextFieldDelegate {
    
    // MARK: - RoutehiveTextFieldDelegate
    
    func shouldChangeCharecter(_ textField: UITextField) {
        
        if let customTextfield = textField as? RoutehiveTextField {
            customTextfield.hideErrorView()
        }
    }
}
