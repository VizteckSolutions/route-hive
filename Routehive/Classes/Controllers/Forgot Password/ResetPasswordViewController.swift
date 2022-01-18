//
//  ResetPasswordViewController.swift
//  Routehive
//
//  Created by Mac on 19/09/2018.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit
import ObjectMapper

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var passwordTextField: RoutehiveTextField!
    @IBOutlet weak var confirmPasswordTextField: RoutehiveTextField!
    @IBOutlet weak var successMessageLabel: UILabel!
    @IBOutlet weak var loginButton: RoutehiveButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: RoutehiveButton!
    
    var phoneCode = ""
    var phoneNumber = ""
    var code = ""
    
    var forgotPassword = Mapper<ForgotPassword>().map(JSON: [:])!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Reset Password"
        setupUIViewController()
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupUIViewController() {
        LocalizableResetPassword.setLanguage(viewController: self)
        passwordTextField.textFieldDelegate = self
        confirmPasswordTextField.textFieldDelegate = self
    }

    // MARK: - Private Methods
    
    func isValidInput() -> Bool {
        
        if passwordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            passwordTextField.showErrorView(errorMessage: LocalizableResetPassword.emptyPassword)
            confirmPasswordTextField.hideErrorView()
            loginButton.shake()
            passwordTextField.becomeFirstResponder()
            return false
            
        } else if confirmPasswordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            confirmPasswordTextField.showErrorView(errorMessage: LocalizableResetPassword.emptyConfirmPassword)
            passwordTextField.hideErrorView()
            loginButton.shake()
            confirmPasswordTextField.becomeFirstResponder()
            return false
            
        } else if passwordTextField.text != confirmPasswordTextField.text {
            confirmPasswordTextField.showErrorView(errorMessage: LocalizableResetPassword.errorPasswordMatched)
            passwordTextField.hideErrorView()
            loginButton.shake()
            confirmPasswordTextField.becomeFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - IBActions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func resetPasswordButtonTaped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        guard isValidInput() else {
            return
        }
        
        forgotPassword.resetPassword(viewController: self, password: passwordTextField.text!, phoneCode: phoneCode, phoneNumber: phoneNumber, verificationCode: code) { (result, error) in
            
            if error == nil {
                self.successView.fadeIn()
                self.navigationController?.transparentNavigationBar()
                self.title = ""
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.hidesBackButton = true
            }
        }
    }
}

extension ResetPasswordViewController: RoutehiveTextFieldDelegate {
    
    // MARK: - RoutehiveTextFieldDelegate
    
    func shouldChangeCharecter(_ textField: UITextField) {
        
        if let customTextfield = textField as? RoutehiveTextField {
            customTextfield.hideErrorView()
        }
    }
}
