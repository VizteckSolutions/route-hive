//
//  VehicleInfoViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/24/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper

class VehicleInfoViewController: UIViewController {

    // MARK: - Variables & Constants
    
    @IBOutlet weak var stepsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var vehicleOwnerShipTextField: RoutehiveTextField!
    @IBOutlet weak var vehicleTypeTextField: RoutehiveTextField!
    @IBOutlet weak var manufaturerTextField: RoutehiveTextField!
    @IBOutlet weak var modelTextField: RoutehiveTextField!
    @IBOutlet weak var companyNameTextField: RoutehiveTextField!
    @IBOutlet weak var companyRegistrationNumberTextField: RoutehiveTextField!
    @IBOutlet weak var vehiclePlateNumberTextField: RoutehiveTextField!
    @IBOutlet weak var vehicleColorTextField: RoutehiveTextField!
    @IBOutlet weak var insuranceExpiryTextField: RoutehiveTextField!
    @IBOutlet weak var inspectionExpiryDateTextField: RoutehiveTextField!
    
    @IBOutlet weak var personalFieldsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var manufacturerFieldTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var vehicleRegistrationCardLabel: UILabel!
    @IBOutlet weak var vehicleInsuranceCoverLabel: UILabel!
    @IBOutlet weak var vehicleInspectionCoverLabel: UILabel!
    
    @IBOutlet weak var registrationFrontSideLabel: UILabel!
    @IBOutlet weak var insuranceFrontSideLabel: UILabel!
    @IBOutlet weak var inspectionFrontSideLabel: UILabel!
    
    @IBOutlet weak var registrationFrontImageView: UIImageView!
    @IBOutlet weak var insuranceFrontImageView: UIImageView!
    @IBOutlet weak var inspectionFrontImageView: UIImageView!
    
    @IBOutlet weak var inspectionView: UIView!
    @IBOutlet weak var insuranceView: UIView!
    @IBOutlet weak var registrationView: UIView!
    
    @IBOutlet weak var registrationSideAActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var insuranceSideAActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var inspectionSideAActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var registrationSideAButton: UIButton!
    @IBOutlet weak var insuranceSideAButton: UIButton!
    @IBOutlet weak var inspectionSideAButton: UIButton!
    
    var errorVehicleOwnerShip = ""
    var errorVehicleType = ""
    var errorManufaturer = ""
    var errorModel = ""
    var errorCompanyName = ""
    var errorCompanyRegistrationNumber = ""
    var errorVehiclePlateNumber = ""
    var errorVehicleColor = ""
    var errorRegistrationImage = ""
    var errorInsuranceImage = ""
    var errorInspectionImage = ""
    var errorInsuranceExpiry = ""
    var errorInspectionExpiry = ""
    var errorUploadingImage = ""
    var errorImageProgress = ""
    var errorCombination = ""
    var doneLabel = ""
    var cancelLabel = ""
    
    var personalLabel = ""
    var companyLabel = ""
    
    var isUploadingregistrationImage = false
    var isUploadingInsuranceImage = false
    var isUploadinginspectionImage = false
    
    @IBOutlet weak var nextButton: RoutehiveButton!
    @IBOutlet weak var infoBackupDriverButton: UIButton!
    @IBOutlet weak var optBackupDriverButton: UIButton!
    
    var ownerPickerView = UIPickerView()
    var vehicleTypePickerView = UIPickerView()
    var manufecturerPickerView = UIPickerView()
    var modelTypePickerView = UIPickerView()
    var datePicker = UIDatePicker()
    var inspectionDatePicker = UIDatePicker()
    
    var selectedOwnershipIndex = 0
    var selectedVehicleTypeIndex = -1
    var selectedManufecturerIndex = -1
    var selectedModelIndex = 0
    
    var vehicleInfo = VehicleInfoData()
    var vehicleModels = [Int]()
    
    var signIn = Mapper<SignIn>().map(JSON: [:])!
    var vehicles = Mapper<Vehicles>().map(JSON: [:])!
    var selectedVehicleModels = [VehicleModels]()
    
    // MARK: - UIviewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupViewControllerUI() {
        LocalizableVehicleInfo.setLanguage(viewController: self)
        
        vehicleOwnerShipTextField.setImageToRightView(image: #imageLiteral(resourceName: "arrow_down"), width: 15, height: 15)
        vehicleTypeTextField.setImageToRightView(image: #imageLiteral(resourceName: "arrow_down"), width: 15, height: 15)
        manufaturerTextField.setImageToRightView(image: #imageLiteral(resourceName: "arrow_down"), width: 15, height: 15)
        modelTextField.setImageToRightView(image: #imageLiteral(resourceName: "arrow_down"), width: 15, height: 15)
        
        vehicleOwnerShipTextField.textFieldDelegate = self
        vehicleTypeTextField.textFieldDelegate = self
        manufaturerTextField.textFieldDelegate = self
        modelTextField.textFieldDelegate = self
        companyNameTextField.textFieldDelegate = self
        companyRegistrationNumberTextField.textFieldDelegate = self
        vehiclePlateNumberTextField.textFieldDelegate = self
        vehicleColorTextField.textFieldDelegate = self
        
        datePicker.datePickerMode = .date
        datePicker.locale = NSLocale.current
        let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        datePicker.minimumDate = tomorrowDate
        
        inspectionDatePicker.datePickerMode = .date
        inspectionDatePicker.locale = NSLocale.current
        inspectionDatePicker.minimumDate = tomorrowDate
        
        if let tomorDate = tomorrowDate {
            datePicker.date = tomorDate
            inspectionDatePicker.date = tomorDate
            print("tomorDate: \(tomorDate)")
        }
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        inspectionDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        insuranceExpiryTextField.inputView = datePicker
        insuranceExpiryTextField.setImageToRightView(image: #imageLiteral(resourceName: "icon_birthday"), width: 15, height: 15)
        insuranceExpiryTextField.textFieldDelegate = self
        
        inspectionExpiryDateTextField.inputView = inspectionDatePicker
        inspectionExpiryDateTextField.setImageToRightView(image: #imageLiteral(resourceName: "icon_birthday"), width: 15, height: 15)
        inspectionExpiryDateTextField.textFieldDelegate = self
        
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
        
        insuranceExpiryTextField.inputAccessoryView = toolBar
        inspectionExpiryDateTextField.inputAccessoryView = toolBar
        
        vehicleOwnerShipTextField.inputView = ownerPickerView
        vehicleTypeTextField.inputView = vehicleTypePickerView
        manufaturerTextField.inputView = manufecturerPickerView
        modelTextField.inputView = modelTypePickerView

        ownerPickerView.delegate = self
        ownerPickerView.dataSource = self
        
        vehicleTypePickerView.delegate = self
        vehicleTypePickerView.dataSource = self
        
        manufecturerPickerView.delegate = self
        manufecturerPickerView.dataSource = self
        
        modelTypePickerView.delegate = self
        modelTypePickerView.dataSource = self
        modelTextField.isHidden = true
        
        registrationSideAActivityIndicator.isHidden = true
        insuranceSideAActivityIndicator.isHidden = true
        inspectionSideAActivityIndicator.isHidden = true
        
        registrationView.isHidden = true
        insuranceView.isHidden = true
        inspectionView.isHidden = true
        
        loadVehicles()
    }
    
    // MARK: - Private Methods
    
    func hideErrorViews() {
        vehicleOwnerShipTextField.hideErrorView()
        vehicleTypeTextField.hideErrorView()
        manufaturerTextField.hideErrorView()
        modelTextField.hideErrorView()
        vehicleColorTextField.hideErrorView()
        companyNameTextField.hideErrorView()
        companyRegistrationNumberTextField.hideErrorView()
        vehiclePlateNumberTextField.hideErrorView()
        insuranceExpiryTextField.hideErrorView()
    }
    
    func isValidPersonalInput() -> Bool {
        hideErrorViews()
        
        if vehicleOwnerShipTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            vehicleOwnerShipTextField.showErrorView(errorMessage: errorVehicleOwnerShip)
            nextButton.shake()
            vehicleOwnerShipTextField.becomeFirstResponder()
            return false
            
        } else if vehicleTypeTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            vehicleTypeTextField.showErrorView(errorMessage: errorVehicleType)
            nextButton.shake()
            vehicleTypeTextField.becomeFirstResponder()
            return false
            
        } else if manufaturerTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            manufaturerTextField.showErrorView(errorMessage: errorManufaturer)
            nextButton.shake()
            manufaturerTextField.becomeFirstResponder()
            return false
            
        } else if modelTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            modelTextField.showErrorView(errorMessage: errorModel)
            nextButton.shake()
            modelTextField.becomeFirstResponder()
            return false
            
        } else if vehiclePlateNumberTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            vehiclePlateNumberTextField.showErrorView(errorMessage: errorVehiclePlateNumber)
            nextButton.shake()
            vehiclePlateNumberTextField.becomeFirstResponder()
            return false
            
        } else if vehicleColorTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            vehicleColorTextField.showErrorView(errorMessage: errorVehicleColor)
            nextButton.shake()
            vehicleColorTextField.becomeFirstResponder()
            return false
            
        } else if vehicleInfo.registrationUrl == "" {
            NSError.showErrorWithMessage(message: errorRegistrationImage, viewController: self, type: .error)
            nextButton.shake()
            return false
        }
        
        if Driver.shared.country == CountryType.Indonesia.rawValue { return true } else {
            
            if vehicleInfo.insuranceUrl == "" {
                NSError.showErrorWithMessage(message: errorInsuranceImage, viewController: self, type: .error)
                nextButton.shake()
                return false
                
            } else if insuranceExpiryTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
                insuranceExpiryTextField.showErrorView(errorMessage: errorInsuranceExpiry)
                nextButton.shake()
                insuranceExpiryTextField.becomeFirstResponder()
                return false
            }
        }
        return true
    }
    
    func isValidCompanyInput() -> Bool {
        hideErrorViews()
        
        if vehicleOwnerShipTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            vehicleOwnerShipTextField.showErrorView(errorMessage: errorVehicleOwnerShip)
            nextButton.shake()
            vehicleOwnerShipTextField.becomeFirstResponder()
            return false
            
        } else if vehicleTypeTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            vehicleTypeTextField.showErrorView(errorMessage: errorVehicleType)
            nextButton.shake()
            vehicleTypeTextField.becomeFirstResponder()
            return false
            
        } else if manufaturerTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            manufaturerTextField.showErrorView(errorMessage: errorManufaturer)
            nextButton.shake()
            manufaturerTextField.becomeFirstResponder()
            return false
            
        } else if modelTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            modelTextField.showErrorView(errorMessage: errorModel)
            nextButton.shake()
            modelTextField.becomeFirstResponder()
            return false
            
        } else if companyNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            companyNameTextField.showErrorView(errorMessage: errorCompanyName)
            nextButton.shake()
            companyNameTextField.becomeFirstResponder()
            return false
            
        } else if companyRegistrationNumberTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            companyRegistrationNumberTextField.showErrorView(errorMessage: errorCompanyRegistrationNumber)
            nextButton.shake()
            companyRegistrationNumberTextField.becomeFirstResponder()
            return false
            
        } else if vehiclePlateNumberTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            vehiclePlateNumberTextField.showErrorView(errorMessage: errorVehiclePlateNumber)
            nextButton.shake()
            vehiclePlateNumberTextField.becomeFirstResponder()
            return false
            
        } else if vehicleColorTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            vehicleColorTextField.showErrorView(errorMessage: errorVehicleColor)
            nextButton.shake()
            vehicleColorTextField.becomeFirstResponder()
            return false
            
        } else if vehicleInfo.registrationUrl == "" {
            NSError.showErrorWithMessage(message: errorRegistrationImage, viewController: self, type: .error)
            nextButton.shake()
            return false
        }
        
        if Driver.shared.country == CountryType.Indonesia.rawValue { return true } else {
            
            if vehicleInfo.insuranceUrl == "" {
                NSError.showErrorWithMessage(message: errorInsuranceImage, viewController: self, type: .error)
                nextButton.shake()
                return false
                
            } else if insuranceExpiryTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
                insuranceExpiryTextField.showErrorView(errorMessage: errorInsuranceExpiry)
                nextButton.shake()
                insuranceExpiryTextField.becomeFirstResponder()
                return false
            }
        }
        
        if vehicleInfo.inspectionUrl == "" {
            NSError.showErrorWithMessage(message: errorInspectionImage, viewController: self, type: .error)
            nextButton.shake()
            return false
            
        }  else if inspectionExpiryDateTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            inspectionExpiryDateTextField.showErrorView(errorMessage: errorInspectionExpiry)
            nextButton.shake()
            inspectionExpiryDateTextField.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    func loadVehicles() {
        
        vehicles.fetchVehiclesData(viewController: self) { (result, error) in
            
            if error == nil {
                self.vehicles = result
                self.ownerPickerView.reloadAllComponents()
                self.vehicleTypePickerView.reloadAllComponents()
                self.manufecturerPickerView.reloadAllComponents()
                self.modelTypePickerView.reloadAllComponents()
            }
        }
    }
    
    func showHideFields() {
        
        if vehicles.ownerShip[selectedOwnershipIndex].type == 1 {
            showPersonalFields()
            
        } else {
            showCompanyFields()
        }
    }
    
    func showPersonalFields() {
        self.view.layoutIfNeeded()
        companyNameTextField.isHidden = true
        companyRegistrationNumberTextField.isHidden = true
        registrationView.isHidden = false
        inspectionView.isHidden = true
        
        if Driver.shared.country == CountryType.Indonesia.rawValue {
            insuranceView.isHidden = true
        } else {
            insuranceView.isHidden = false
        }
        vehiclePlateNumberTextField.isHidden = false
        vehicleColorTextField.isHidden = false
        personalFieldsTopConstraint.constant = 0
        
        if selectedVehicleTypeIndex < 0 {
            manufacturerFieldTopConstraint.constant = 0
        }
    }

    func showCompanyFields() {
        self.view.layoutIfNeeded()
        companyNameTextField.isHidden = false
        companyRegistrationNumberTextField.isHidden = false
        vehiclePlateNumberTextField.isHidden = false
        vehicleColorTextField.isHidden = false
        registrationView.isHidden = false
        inspectionView.isHidden = false
        
        if Driver.shared.country == CountryType.Indonesia.rawValue {
            insuranceView.isHidden = true
        } else {
            insuranceView.isHidden = false
        }
        personalFieldsTopConstraint.constant = 15
        
        if selectedVehicleTypeIndex < 0 {
            manufacturerFieldTopConstraint.constant = 0
        }
    }

    func uploadImage(pickedImage: UIImage) {
        
        if isUploadingregistrationImage {
            self.registrationSideAActivityIndicator.isHidden = false
            self.registrationSideAActivityIndicator.startAnimating()
            
        } else if isUploadingInsuranceImage {
            self.insuranceSideAActivityIndicator.isHidden = false
            self.insuranceSideAActivityIndicator.startAnimating()
            
        } else if isUploadinginspectionImage {
            self.inspectionSideAActivityIndicator.isHidden = false
            self.inspectionSideAActivityIndicator.startAnimating()
        }
        
        signIn.uploadImage(viewController: self, type: .identityDocumentsImages, pickedImage: pickedImage) { (success, ImageUrl) in
            
            if success {
                
                if self.isUploadingregistrationImage {
                    self.isUploadingregistrationImage = false
                    self.registrationSideAActivityIndicator.isHidden = true
                    self.registrationFrontSideLabel.isHidden = true
                    self.registrationSideAActivityIndicator.stopAnimating()
                    self.registrationFrontImageView.image = pickedImage
                    self.vehicleInfo.registrationUrl = ImageUrl
                    
                } else if self.isUploadingInsuranceImage {
                    self.isUploadingInsuranceImage = false
                    self.insuranceSideAActivityIndicator.isHidden = true
                    self.insuranceFrontSideLabel.isHidden = true
                    self.insuranceSideAActivityIndicator.stopAnimating()
                    self.insuranceFrontImageView.image = pickedImage
                    self.vehicleInfo.insuranceUrl = ImageUrl
                    
                } else if self.isUploadinginspectionImage {
                    self.isUploadinginspectionImage = false
                    self.inspectionSideAActivityIndicator.isHidden = true
                    self.inspectionFrontSideLabel.isHidden = true
                    self.inspectionSideAActivityIndicator.stopAnimating()
                    self.inspectionFrontImageView.image = pickedImage
                    self.vehicleInfo.inspectionUrl = ImageUrl
                }
                
            } else {
                NSError.showErrorWithMessage(message: self.errorUploadingImage, viewController: self)
                
                if self.isUploadingregistrationImage {
                    self.isUploadingregistrationImage = false
                    self.registrationSideAActivityIndicator.isHidden = true
                    self.registrationSideAActivityIndicator.stopAnimating()
                    
                } else if self.isUploadingInsuranceImage {
                    self.isUploadingInsuranceImage = false
                    self.insuranceSideAActivityIndicator.isHidden = true
                    self.insuranceSideAActivityIndicator.stopAnimating()
                    
                } else if self.isUploadinginspectionImage {
                    self.isUploadinginspectionImage = false
                    self.inspectionSideAActivityIndicator.isHidden = true
                    self.inspectionSideAActivityIndicator.stopAnimating()
                }
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc func doneButtonTapped() {
        
        if insuranceExpiryTextField.isFirstResponder {
            insuranceExpiryTextField.resignFirstResponder()
            
        } else if inspectionExpiryDateTextField.isFirstResponder {
            inspectionExpiryDateTextField.resignFirstResponder()
        }
    }
    
    @objc func toolBarCancelButtonTapped() {
        
        if insuranceExpiryTextField.isFirstResponder {
            insuranceExpiryTextField.resignFirstResponder()
            
        } else if inspectionExpiryDateTextField.isFirstResponder {
            inspectionExpiryDateTextField.resignFirstResponder()
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day, .minute, .hour], from: sender.date)
        
        if let day = componenets.day, let year = componenets.year, let month = componenets.month {
            
            if insuranceExpiryTextField.isFirstResponder {
                insuranceExpiryTextField.text = "\(day)-\(month)-\(year)"
                
            } else if inspectionExpiryDateTextField.isFirstResponder {
                inspectionExpiryDateTextField.text = "\(day)-\(month)-\(year)"
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func registrationSideAButtonTapped(_ sender: Any) {
        
        if !isUploadingInsuranceImage && !isUploadinginspectionImage {
            isUploadingregistrationImage = true
            isUploadingInsuranceImage = false
            isUploadinginspectionImage = false
            Utility.presentImagePicker(viewController: self)
            
        } else {
            NSError.showErrorWithMessage(message: errorImageProgress, viewController: self)
        }
    }
    
    @IBAction func insuranceSideAButtonTapped(_ sender: Any) {
        
        if !isUploadingregistrationImage && !isUploadinginspectionImage {
            isUploadingregistrationImage = false
            isUploadingInsuranceImage = true
            isUploadinginspectionImage = false
            Utility.presentImagePicker(viewController: self)
            
        } else {
            NSError.showErrorWithMessage(message: errorImageProgress, viewController: self)
        }
    }
    
    @IBAction func inspectionSideAButtonTapped(_ sender: Any) {
        
        if !isUploadingregistrationImage && !isUploadingInsuranceImage {
            isUploadingregistrationImage = false
            isUploadingInsuranceImage = false
            isUploadinginspectionImage = true
            Utility.presentImagePicker(viewController: self)
            
        } else {
            NSError.showErrorWithMessage(message: errorImageProgress, viewController: self)
        }
    }
    
    @IBAction func optBackupDriverButtonTapped(_ sender: Any) {
        
        if optBackupDriverButton.tag == 0 {
            optBackupDriverButton.tag = 1
            optBackupDriverButton.setImage(#imageLiteral(resourceName: "checkbox_checked"), for: .normal)
            vehicleInfo.isBackupDriver = 2
            
        } else {
            optBackupDriverButton.tag = 0
            optBackupDriverButton.setImage(#imageLiteral(resourceName: "checkbox"), for: .normal)
            vehicleInfo.isBackupDriver = 1
        }
    }
    
    @IBAction func infoBackupDriverButtonTapped(_ sender: Any) {
        let backUpDriverPopupViewController = BackUpDriverPopupViewController()
        backUpDriverPopupViewController.modalPresentationStyle = .overCurrentContext
        self.present(backUpDriverPopupViewController, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        if vehicleOwnerShipTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            hideErrorViews()
            vehicleOwnerShipTextField.showErrorView(errorMessage: errorVehicleOwnerShip)
            nextButton.shake()
            vehicleOwnerShipTextField.becomeFirstResponder()
            return
        }
        
        if vehicles.ownerShip[selectedOwnershipIndex].id == 1 {
            
            guard isValidPersonalInput() else {
                return
            }
            
        } else {
            
            guard isValidCompanyInput() else {
                return
            }
        }
        
        vehicleInfo.vehicleOwnershipType = vehicles.ownerShip[selectedOwnershipIndex].id
        vehicleInfo.vehicleTypeId = vehicles.vehicleTypes[selectedVehicleTypeIndex].id
        vehicleInfo.vehicleManufacturerId = vehicles.vehicleManufacturers[selectedManufecturerIndex].id
        vehicleInfo.vehicleModelId = selectedVehicleModels[selectedModelIndex].id
        vehicleInfo.vehiclePlateNumber = vehiclePlateNumberTextField.text!
        vehicleInfo.vehicleColor = vehicleColorTextField.text!
        let expriryDateTimeInterval: Double = datePicker.date.timeIntervalSince1970
        vehicleInfo.insuranceExpiryDate = expriryDateTimeInterval
        
        if vehicleInfo.vehicleOwnershipType == 1 {
            vehicleInfo.companyName = ""
            vehicleInfo.companyRegistrationNumber = ""
            vehicleInfo.inspectionUrl = ""
            vehicleInfo.inspectionExpiryDate = 0
            
        } else {
            vehicleInfo.companyName = companyNameTextField.text!
            vehicleInfo.companyRegistrationNumber = companyRegistrationNumberTextField.text!
            let expriryDateTimeInterval1: Double = inspectionDatePicker.date.timeIntervalSince1970
            vehicleInfo.inspectionExpiryDate = expriryDateTimeInterval1
        }
        
        signIn.updateVehicleInfo(viewController: self, vehicleInfo: vehicleInfo) { (result, error) in
            
            if error == nil {
                let myKadViewController = MyKadViewController()
                myKadViewController.addCustomBackButton()
                self.navigationController?.pushViewController(myKadViewController, animated: true)
            }
        }
    }
}

extension VehicleInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - UIPickerView Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == ownerPickerView {
            return vehicles.ownerShip.count
            
        } else if pickerView == vehicleTypePickerView {
            return vehicles.vehicleTypes.count
            
        } else if pickerView == manufecturerPickerView {
            return vehicles.vehicleManufacturers.count
            
        }
        return selectedVehicleModels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == ownerPickerView {
            
            if vehicles.ownerShip[row].type == 1 {
                return personalLabel
                
            } else {
                return companyLabel
            }
            
        } else if pickerView == vehicleTypePickerView {
            return vehicles.vehicleTypes[row].name
            
        } else if pickerView == manufecturerPickerView {
            return vehicles.vehicleManufacturers[row].name
            
        } else {
            return selectedVehicleModels[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == ownerPickerView {
            
            if vehicles.ownerShip[row].type == 1 {
                vehicleOwnerShipTextField.text = personalLabel
                
            } else {
                vehicleOwnerShipTextField.text = companyLabel
            }
            
            selectedOwnershipIndex = row
            showHideFields()
            
        } else if pickerView == vehicleTypePickerView {
            selectedVehicleTypeIndex = row
            vehicleTypeTextField.text = vehicles.vehicleTypes[row].name
            manufaturerTextField.isHidden = false
            manufacturerFieldTopConstraint.constant = 15
            
            if selectedManufecturerIndex > -1 {
                selectedVehicleModels = vehicles.vehicleModels.filter{$0.vehicleTypeId == vehicles.vehicleTypes[selectedVehicleTypeIndex].id && $0.vehicleManufacturerId == vehicles.vehicleManufacturers[selectedManufecturerIndex].id}
                modelTextField.isHidden = false
                modelTextField.text = ""
                modelTypePickerView.reloadAllComponents()
            }
            
        } else if pickerView == manufecturerPickerView {
            
            if vehicles.vehicleManufacturers.count > 0 {
                selectedManufecturerIndex = row
                manufaturerTextField.text = vehicles.vehicleManufacturers[row].name
                
                selectedVehicleModels = vehicles.vehicleModels.filter{$0.vehicleTypeId == vehicles.vehicleTypes[selectedVehicleTypeIndex].id && $0.vehicleManufacturerId == vehicles.vehicleManufacturers[selectedManufecturerIndex].id}
                modelTextField.isHidden = false
                //            modelFieldTopConstraint.constant = 15
                modelTextField.text = ""
                modelTypePickerView.reloadAllComponents()
            }
            
        } else {
            
            if selectedVehicleModels.count > 0 {
                modelTextField.text = selectedVehicleModels[row].name
                selectedModelIndex = row
            }
        }
    }
}

extension VehicleInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.uploadImage(pickedImage: pickedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension VehicleInfoViewController: RoutehiveTextFieldDelegate {
    
    // MARK: - RoutehiveTextFieldDelegate
    
    func shouldChangeCharecter(_ textField: UITextField) {
        
        if let customTextfield = textField as? RoutehiveTextField {
            customTextfield.hideErrorView()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == modelTextField && selectedVehicleModels.count == 0 {
            textField.resignFirstResponder()
            NSError.showErrorWithMessage(message: errorCombination, viewController: self)
        }
    }
}

class VehicleInfoData {
    var vehicleOwnershipType = 0
    var vehicleTypeId = 0
    var vehicleManufacturerId = 0
    var vehicleModelId = 0
    var vehiclePlateNumber = ""
    var vehicleColor = ""
    var companyName = ""
    var companyRegistrationNumber = ""
    var isBackupDriver = 1
    
    var registrationUrl = ""
    var insuranceUrl = ""
    var insuranceExpiryDate: Double = 0
    var inspectionExpiryDate: Double = 0
    var inspectionUrl = ""
}
