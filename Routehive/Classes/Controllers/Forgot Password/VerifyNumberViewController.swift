//
//  VerifyNumberViewController.swift
//  Routehive
//
//  Created by Mac on 19/09/2018.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit
import ObjectMapper

protocol VerifyNumberViewControllerDelegate {
    func numberVerified()
}

class VerifyNumberViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    @IBOutlet weak var stepsImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var stepsBottomLineView: UIView!
    @IBOutlet weak var verificationCodeTextField: RoutehiveTextField!
    @IBOutlet weak var verifyButton: RoutehiveButton!
    @IBOutlet weak var resendCodeButton: UIButton!
    @IBOutlet weak var notYourNumberButton: UIButton!
    
    
    var forgotPassword = Mapper<ForgotPassword>().map(JSON: [:])!
    var signIn = Mapper<SignIn>().map(JSON: [:])!
    var isSignUp = false
    var phoneCode = ""
    var phoneNumber = ""
    var code = ""
    var isUpdatePhoneNumber = false
    var delegate: VerifyNumberViewControllerDelegate?
    
    var detailText = ""
    var verifyGetStartedButtonTitle = ""
    var verifyButtonTitle = ""
    var resendCodeSuccess = ""
    var errorEmptyCode = ""
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSError.showErrorWithMessage(message: code, viewController: self)
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupUIViewController() {
        LocalizableVerifyNumber.setLanguage(viewController: self)
        
//        NSError.showErrorWithMessage(message: code, viewController: self, type: .success)
        verifyButton.backgroundColor = #colorLiteral(red: 0.6274509804, green: 0.6235294118, blue: 0.6274509804, alpha: 1)
        verifyButton.isUserInteractionEnabled = false
        verificationCodeTextField.textFieldDelegate = self
        
        if isSignUp {
            stepsImageView.isHidden = false
            stepsBottomLineView.isHidden = false
            detailLabel.text = "\(detailText) (\(phoneCode + phoneNumber))."
            
        } else {
            detailLabel.text = "\(detailText) (\(phoneCode + phoneNumber))."
            stepsImageView.isHidden = true
            stepsBottomLineView.isHidden = true
        }
    }

    // MARK: - Private Methods
    
    func verifyResetPasswordCode() {
        
        guard isValidInput() else {
            return
        }
        
        forgotPassword.verifyResetPassword(viewController: self, phoneCode: phoneCode, phoneNumber: phoneNumber, verificationCode: self.verificationCodeTextField.text!) { (result, error) in
            
            if error == nil {
                let resetPasswordViewController = ResetPasswordViewController()
                resetPasswordViewController.addCustomBackButton()
                resetPasswordViewController.phoneCode = self.phoneCode
                resetPasswordViewController.phoneNumber = self.phoneNumber
                resetPasswordViewController.code = self.code
                self.navigationController?.pushViewController(resetPasswordViewController, animated: true)
            }
        }
    }
    
    func verifySignUpCode() {
        
        guard isValidInput() else {
            return
        }
        
        signIn.verifyPhoneNumber(viewController: self, verificationCode: self.verificationCodeTextField.text!) { (result, error) in
            
            if error == nil {
                
                if self.isUpdatePhoneNumber {
                    Driver.shared.phoneNumber = self.phoneNumber
                    Driver.shared.phoneCode = self.phoneCode
                    UserDefaults.standard.set(self.phoneNumber, forKey: kSPMobile)
                    UserDefaults.standard.set(self.phoneCode, forKey: kSPMobilecode)
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.numberVerified()
                    return
                }
                let vehicleInfoViewController = VehicleInfoViewController()
                vehicleInfoViewController.addCustomBackButton()
                self.navigationController?.pushViewController(vehicleInfoViewController, animated: true)
            }
        }
    }
    
    func resendSignUpVerificationCode() {
        
        signIn.resendVerificationCode(viewController: self) { (result, error) in
            
            if error == nil {
                NSError.showErrorWithMessage(message: self.resendCodeSuccess, viewController: self, type: .success)
            }
        }
    }
    
    func resendForgotVerificationCode() {
        
        forgotPassword.forgotPassword(viewController: self, phoneCode: phoneCode, phoneNumber: phoneNumber) { (result, error) in
            
            if error == nil {
                NSError.showErrorWithMessage(message: self.resendCodeSuccess, viewController: self, type: .success)
            }
        }
    }
    
    func isValidInput() -> Bool {
        
        if verificationCodeTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            NSError.showErrorWithMessage(message: self.errorEmptyCode, viewController: self, type: .error)
            return false
        }
        
        return true
    }
    
    // MARK: - IBaction

    @IBAction func verifyButtonTapped(_ sender: Any) {
        
        if !isSignUp && !isUpdatePhoneNumber {
            verifyResetPasswordCode()
            
        } else {
            verifySignUpCode()
        }
    }
    
    @IBAction func resendCodeButtonTapped(_ sender: Any) {
        
        if isSignUp || isUpdatePhoneNumber {
            resendSignUpVerificationCode()
            
        } else {
            resendForgotVerificationCode()
        }
    }
    
    @IBAction func notYourNumberTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension VerifyNumberViewController: RoutehiveTextFieldDelegate {
    
    // MARK: - RoutehiveTextFieldDelegate
    
    func shouldChangeCharecter(_ textField: UITextField, range: NSRange, string: String) {
        
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {return}
        let currentLength: Int = currentText.count
        
        if let _ = textField as? RoutehiveTextField {
            
            if currentLength < 4 {
                verifyButton.setTitle(verifyButtonTitle, for: .normal)
                verifyButton.backgroundColor = #colorLiteral(red: 0.6274509804, green: 0.6235294118, blue: 0.6274509804, alpha: 1)
                verifyButton.isUserInteractionEnabled = false
                
            } else if currentLength >= 4 {
                verifyButton.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.1411764706, blue: 0.1764705882, alpha: 1)
                verifyButton.isUserInteractionEnabled = true
                
                if isSignUp {
                    verifyButton.setTitle(verifyGetStartedButtonTitle, for: .normal)
                }
            }
        }
    }
}
