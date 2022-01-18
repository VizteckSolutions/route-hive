//
//  ForgotPasswordViewController.swift
//  Routehive
//
//  Created by Mac on 19/09/2018.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation


class ForgotPasswordViewController: UIViewController, SelectCountryViewControllerDelegate {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var sendButton: RoutehiveButton!
    @IBOutlet weak var numberTextField: RoutehiveTextField!
    @IBOutlet weak var descriptionLabel: UILabel!

    var locationPermisionMessage = ""
    var settingsButtonTitle = ""
    
    var forgotPassword = Mapper<ForgotPassword>().map(JSON: [:])!
    var countryList = Mapper<CountryList>().map(JSON: [:])!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUIViewController()
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupUIViewController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        LocalizableForgotPassword.setLocationPermissionLanguage(viewController: self)
        
        getLocation()
        
        Driver.shared.delegate = self
        LocalizableForgotPassword.setLanguage(viewController: self)
        numberTextField.textFieldDelegate = self
    }

    // MARK: - Private Methods
    
    func loadData() {
        
        countryList.loadData(viewController: self) { (list, error) in
            self.countryList = list
            
            for code in list.countries {
                
                if code.code == Driver.shared.countryCode {
                    self.countryCodeLabel.text = code.code
                    self.numberTextField.maxLength = code.numberLength
                    
                    if let url = URL(string: code.imageUrl) {
                        self.flagImageView.af_setImage(withURL: url)
                    }
                    break
                }
            }
        }
    }
    
    func isValidInput() -> Bool {
        
        if numberTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            numberTextField.showErrorView(errorMessage: LocalizableForgotPassword.emptyPhoneNumber)
            sendButton.shake()
            numberTextField.becomeFirstResponder()
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
            
            Driver.shared.getCountry { (country) in
                self.loadData()
            }
            //            Driver.shared.startEmittingLocation()
            
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
    
    // MARK: - IBActions

    @IBAction func sendCodeButtonTapped(_ sender: Any) {
        
        guard isValidInput() else {
            return
        }
        
        forgotPassword.forgotPassword(viewController: self, phoneCode: countryCodeLabel.text!, phoneNumber: numberTextField.text!) { (result, error) in
            
            if error == nil {
                let verifyNumberViewController = VerifyNumberViewController()
                verifyNumberViewController.addCustomBackButton()
                verifyNumberViewController.phoneCode = self.countryCodeLabel.text!
                verifyNumberViewController.phoneNumber = self.numberTextField.text!
                verifyNumberViewController.code = result.verificatioCode
                self.navigationController?.pushViewController(verifyNumberViewController, animated: true)
            }
        }
    }
    
    @IBAction func countryButtonTapped(_ sender: Any) {
//        let selectCountryViewController = SelectCountryViewController()
//        selectCountryViewController.delegate = self
//        self.present(selectCountryViewController, animated: true, completion: nil)
    }

    // MARK: - SelectCountryViewControllerDelegate

    func didSelectCuontry(code: String, flag: UIImage) {
        countryCodeLabel.text = code
        flagImageView.image = flag
    }
}

extension ForgotPasswordViewController: RoutehiveTextFieldDelegate {
    
    // MARK: - RoutehiveTextFieldDelegate
    
    func shouldChangeCharecter(_ textField: UITextField) {
        
        if let customTextfield = textField as? RoutehiveTextField {
            customTextfield.hideErrorView()
        }
    }
}

extension ForgotPasswordViewController: DriverDelegate, ApplicationMainDelegate {
    
    // MARK: - DriverDelegate
    
    func didChangeLocationAuthorization() {
        
        Driver.shared.getCountry { (country) in
            self.loadData()
        }
    }
    
    // MARK: - ApplicationMainDelegate
    
    func applicationDidBecomeActiveSignup() {
        getLocation()
    }
}
