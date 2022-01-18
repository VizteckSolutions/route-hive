//
//  SignInViewController.swift
//  Routehive
//
//  Created by Mac on 18/09/2018.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit
import ObjectMapper

class SignInViewController: UIViewController {

    // MARK: - Constants And Variables
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: RoutehiveTextField!
    @IBOutlet weak var passwordTextField: RoutehiveTextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: RoutehiveButton!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    var signIn = Mapper<SignIn>().map(JSON: [:])!
    
    // MARK: - UIController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIViewController()
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupUIViewController() {
        LocalizableSignIn.setLanguage(viewController: self)
        
        emailTextField.textFieldDelegate = self
        passwordTextField.textFieldDelegate = self
    }

    // MARK: - Private Methods
    
    func setupHome() {
        let navigationController = UINavigationController()
        Utility.saveDriverDataInDefaults(data: signIn.spData)
        
        switch signIn.signUpStepCompleted {
            
        case 0:
            let signUpProfileViewController = SignUpProfileViewController()
            navigationController.viewControllers = [signUpProfileViewController]
            navigationController.navigationBar.isTranslucent = false
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        case 1:
            let vehicleInfoViewController = VehicleInfoViewController()
            navigationController.viewControllers = [vehicleInfoViewController]
            navigationController.navigationBar.isTranslucent = false
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        case 2:
            let myKadViewController = MyKadViewController()
            navigationController.viewControllers = [myKadViewController]
            navigationController.navigationBar.isTranslucent = false
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        case 3:
            let drivingLicenseViewController = DrivingLicenseViewController()
            navigationController.viewControllers = [drivingLicenseViewController]
            navigationController.navigationBar.isTranslucent = false
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        case 4:
            let bankDetailsViewController = BankDetailsViewController()
            navigationController.viewControllers = [bankDetailsViewController]
            navigationController.navigationBar.isTranslucent = false
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        default:
            Utility.setupHomeViewController()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func forgetPasswordButtonTapped(_ sender: Any) {
        let forgotPasswodViewController = ForgotPasswordViewController()
        forgotPasswodViewController.addCustomBackButton()
        self.navigationController?.pushViewController(forgotPasswodViewController, animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard isValidInput() else {
            return
        }
        
        signIn.signIn(viewController: self, email: emailTextField.text!, passsword: passwordTextField.text!) { (result, error) in
            
            if error == nil {
                self.signIn = result
                self.setupHome()
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        Utility.setupSignUpAsRootViewController()
    }
    
    // MARK: - Private Methods
    
    func isValidInput() -> Bool {
        hideErrorViews()
        
        if emailTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            emailTextField.showErrorView(errorMessage: LocalizableSignIn.emptyEmail)
            loginButton.shake()
            emailTextField.becomeFirstResponder()
            return false
            
        } else if !emailTextField.text!.isValidEmail() {
            emailTextField.showErrorView(errorMessage: LocalizableSignIn.invalidEmail)
            loginButton.shake()
            emailTextField.becomeFirstResponder()
            return false
            
        } else if passwordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            passwordTextField.showErrorView(errorMessage: LocalizableSignIn.emptyPassword)
            loginButton.shake()
            passwordTextField.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    func hideErrorViews() {
        emailTextField.hideErrorView()
        passwordTextField.hideErrorView()
    }
}

extension SignInViewController: RoutehiveTextFieldDelegate {
    
    // MARK: - RoutehiveTextFieldDelegate
    
    func shouldChangeCharecter(_ textField: UITextField) {
        
        if let customTextfield = textField as? RoutehiveTextField {
            customTextfield.hideErrorView()
        }
    }
}
