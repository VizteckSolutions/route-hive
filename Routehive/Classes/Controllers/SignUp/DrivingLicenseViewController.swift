//
//  DrivingLicenseViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/24/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper

class DrivingLicenseViewController: UIViewController {
    
    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var stepsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sideAImageView: UIImageView!
    @IBOutlet weak var sideAActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sideAButton: UIButton!
    @IBOutlet weak var nextButton: RoutehiveButton!
    @IBOutlet weak var expiryDateTextField: RoutehiveTextField!
    @IBOutlet weak var frontSideLabel: UILabel!
    
    var errorExpiryDate = ""
    var errorImageUpload = ""
    var doneLabel = ""
    var cancelLabel = ""
    
    var datePicker = UIDatePicker()
    var signIn = Mapper<SignIn>().map(JSON: [:])!
    
    // MARK: - UIviewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    // MARK: = UIViewController Helper Methods
    
    func setupViewControllerUI() {
        LocalizableDrivingLicense.setLanguage(viewController: self)
        datePicker.datePickerMode = .date
        datePicker.locale = NSLocale.current
        let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        print("Tomorrow Date: \(tomorrowDate ?? Date())")
        datePicker.minimumDate = tomorrowDate
        
        if let tomorDate = tomorrowDate {
            datePicker.date = tomorDate
            print("tomorDate: \(tomorDate)")
        }
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        expiryDateTextField.inputView = datePicker
        expiryDateTextField.setImageToRightView(image: #imageLiteral(resourceName: "icon_birthday"), width: 15, height: 15)
        expiryDateTextField.textFieldDelegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: doneLabel, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: cancelLabel, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.toolBarCancelButtonTapped))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.tintColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        toolBar.isUserInteractionEnabled = true
        
        expiryDateTextField.inputAccessoryView = toolBar
        
        sideAActivityIndicator.isHidden = true
    }
    
    
    // MARK: - Selectors
    
    @objc func doneButtonTapped() {
        
        if expiryDateTextField.isFirstResponder {
            expiryDateTextField.resignFirstResponder()
        }
    }
    
    @objc func toolBarCancelButtonTapped() {
        
        if expiryDateTextField.isFirstResponder {
            expiryDateTextField.resignFirstResponder()
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day, .minute, .hour], from: sender.date)
        
        if let day = componenets.day, let year = componenets.year, let month = componenets.month {
            
            if expiryDateTextField.isFirstResponder {
                expiryDateTextField.text = "\(day)-\(month)-\(year)"
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func sideAButtonTapped(_ sender: UIButton) {
        Utility.presentImagePicker(viewController: self)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        guard isValidInput() else {
            return
        }
        let expriryDateTimeInterval: Double = datePicker.date.timeIntervalSince1970
        
        signIn.updateDrivingLicenseInfo(viewController: self, pickedImage: self.sideAImageView.image!, drivingLicenseExpiryDate: expriryDateTimeInterval) { (result, error) in
            
            if error == nil {
                let bankDetailsViewController = BankDetailsViewController()
                bankDetailsViewController.addCustomBackButton()
                self.navigationController?.pushViewController(bankDetailsViewController, animated: true)
            }
        }
    }
    
    // MARK: - Private Methods
    
    func isValidInput() -> Bool {
        
        if expiryDateTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            expiryDateTextField.showErrorView(errorMessage: errorExpiryDate)
            nextButton.shake()
            expiryDateTextField.becomeFirstResponder()
            return false
            
        } else if sideAImageView.image == #imageLiteral(resourceName: "upload_front_side") {
            NSError.showErrorWithMessage(message: errorImageUpload, viewController: self)
            nextButton.shake()
            return false
        }
        
        return true
    }
}

extension DrivingLicenseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.sideAImageView.image = pickedImage
            frontSideLabel.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension DrivingLicenseViewController: RoutehiveTextFieldDelegate {
    
    // MARK: - RoutehiveTextFieldDelegate
    
    func shouldChangeCharecter(_ textField: UITextField) {
        
        if let customTextfield = textField as? RoutehiveTextField {
            customTextfield.hideErrorView()
        }
    }
}
