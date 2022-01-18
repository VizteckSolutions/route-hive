//
//  SignUpViewController.swift
//  Routehive
//
//  Created by Mac on 18/09/2018.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation

class SignUpViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var signupTitleLabel: UILabel!
    @IBOutlet weak var signupDetailLabel: UILabel!
    @IBOutlet weak var alreadyAccountLabel: UILabel!
    
    @IBOutlet weak var emailTextField: RoutehiveTextField!
    @IBOutlet weak var signupButton: RoutehiveButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var errorEmptyEmail = ""
    var errorInvalidEmail = ""
    var locationPermisionMessage = ""
    var settingsButtonTitle = ""
    
    var signIn = Mapper<SignIn>().map(JSON: [:])!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getLocation()
    }
    
    // MARK:- UIViewController Helper Methods
    
    func setupViewControllerUI() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        LocalizableSignUp.setLanguage(viewController: self)
        emailTextField.textFieldDelegate = self
        Driver.shared.delegate = self
    }
    
    func setupNavigationControllerUI() {
        
    }
    
    // MARK: - Private Methods
    
    func isValidInput() -> Bool {
        
        if emailTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            emailTextField.showErrorView(errorMessage: errorEmptyEmail)
            signupButton.shake()
            emailTextField.becomeFirstResponder()
            return false
            
        } else if !(emailTextField.text?.isValidEmail())! {
            emailTextField.showErrorView(errorMessage: errorInvalidEmail)
            signupButton.shake()
            emailTextField.becomeFirstResponder()
            return false
        }
        
        return true
    }

    func showLocationAlert() {
        
        let alertController = UIAlertController (title: locationPermisionMessage, message: "", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: settingsButtonTitle, style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func getLocation() {
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("********* Location Permition AuthorizedAlways **************")
            
            Driver.shared.getCountry { (country) in}
            
        case .denied:
            print("********* Location Permition Denied **************")
            showLocationAlert()
            
        case .notDetermined:
            print("********* Location Permition NotDetermined **************")
            Driver.shared.locationManager.requestAlwaysAuthorization()
            Driver.shared.locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            print("********* Location Permition Restricted **************")
            showLocationAlert()
        }
    }
    
    // MARK: - Selectors
    
    // MARK: - IBActions
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        guard isValidInput() else {
            return
        }
        
        signIn.signUp(viewController: self, email: emailTextField.text!, country: Driver.shared.country) { (result, error) in
            
            if error == nil {
                
                if result.isEmailVerified {
                    let signUpProfileViewController = SignUpProfileViewController()
                    signUpProfileViewController.addCustomBackButton()
                    self.navigationController?.pushViewController(signUpProfileViewController, animated: true)
                    
                } else {
                    let emailVerificationPopupViewController = EmailVerificationPopupViewController()
                    emailVerificationPopupViewController.delegate = self
                    self.signIn = result
                    emailVerificationPopupViewController.modalPresentationStyle = .overCurrentContext
                    self.navigationController?.present(emailVerificationPopupViewController, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        Utility.setupLoginAsRootViewController()
    }
}

extension SignUpViewController: EmailVerificationPopupViewControllerDelegate, SuccessfullPopupViewControllerDelegate {
    
    // MARK: - EmailVerificationPopupViewControllerDelegate
    
    func didTappedOkButton(viewController: EmailVerificationPopupViewController) {
        viewController.dismiss(animated: false, completion: nil)
        
        signIn.isEmailVerified(viewController: self, token: signIn.token) { (result, error) in
            
            if error == nil {
                Utility.saveDriverDataInDefaults(data: result.spData)
                let successfullPopupViewController = SuccessfullPopupViewController()
                successfullPopupViewController.delegate = self
                successfullPopupViewController.modalPresentationStyle = .overCurrentContext
                self.navigationController?.present(successfullPopupViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    // MARK: - SuccessfullPopupViewControllerDelegate
    
    func didTappedContinueButton(viewController: SuccessfullPopupViewController) {
        viewController.dismiss(animated: false, completion: nil)
        
        let signUpProfileViewController = SignUpProfileViewController()
        signUpProfileViewController.addCustomBackButton()
        self.navigationController?.pushViewController(signUpProfileViewController, animated: true)
    }
}

extension SignUpViewController: RoutehiveTextFieldDelegate {
    
    // MARK: - RoutehiveTextFieldDelegate
    
    func shouldChangeCharecter(_ textField: UITextField) {
        
        if let customTextfield = textField as? RoutehiveTextField {
            customTextfield.hideErrorView()
        }
    }
}

extension SignUpViewController: DriverDelegate, ApplicationMainDelegate {
    
    // MARK: - DriverDelegate
    
    func didChangeLocationAuthorization() {
        
        Driver.shared.getCountry { (country) in
        }
    }
    
    // MARK: - ApplicationMainDelegate
    
    func applicationDidBecomeActiveSignup() {
        getLocation()
    }
}
