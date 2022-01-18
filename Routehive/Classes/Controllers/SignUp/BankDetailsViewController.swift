//
//  BankDetailsViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/24/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper

class BankDetailsViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var stepsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bankNameTextField: RoutehiveTextField!
    @IBOutlet weak var accountTitleTextField: RoutehiveTextField!
    @IBOutlet weak var accountNumberTextField: RoutehiveTextField!
    @IBOutlet weak var doneButton: RoutehiveButton!
    
    var errorBankName = ""
    var errorAccountTitle = ""
    var errorAccountNumber = ""
    
    var banksPickerView = UIPickerView()
    var selectedBankIndex = 0
    var banks = Mapper<Banks>().map(JSON: [:])!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupViewControllerUI() {
        LocalizableBankDetail.setLanguage(viewController: self)
        bankNameTextField.setImageToRightView(image: #imageLiteral(resourceName: "arrow_down"), width: 15, height: 15)
        bankNameTextField.inputView = banksPickerView
        
        bankNameTextField.textFieldDelegate = self
        accountTitleTextField.textFieldDelegate = self
        accountNumberTextField.textFieldDelegate = self
        
        banksPickerView.delegate = self
        banksPickerView.dataSource = self
        
        loadData()
    }
    
    // MARK: - Private Methods
    
    func loadData() {
        
        banks.fetchBanks(viewController: self) { (result, error) in
            
            if error == nil {
                self.banks = result
                self.banksPickerView.reloadAllComponents()
            }
        }
    }
    
    func isValidInput() -> Bool {
        
        if bankNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            bankNameTextField.showErrorView(errorMessage: errorBankName)
            accountTitleTextField.hideErrorView()
            accountNumberTextField.hideErrorView()
            doneButton.shake()
            bankNameTextField.becomeFirstResponder()
            return false
            
        } else if accountTitleTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            accountTitleTextField.showErrorView(errorMessage: errorAccountTitle)
            bankNameTextField.hideErrorView()
            accountNumberTextField.hideErrorView()
            doneButton.shake()
            accountTitleTextField.becomeFirstResponder()
            return false
            
        } else if accountNumberTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            accountNumberTextField.showErrorView(errorMessage: errorAccountNumber)
            bankNameTextField.hideErrorView()
            accountTitleTextField.hideErrorView()
            doneButton.shake()
            accountNumberTextField.becomeFirstResponder()
            return false
            
        }
        
        return true
    }
    
    // MARK: - IBActions
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        guard isValidInput() else {
            return
        }

        banks.updateBankInfo(viewController: self, bankId: banks.bank[selectedBankIndex].id, accountHolderName: accountTitleTextField.text!, accountNumber: accountNumberTextField.text!) { (result, error) in

            if error == nil {
                let exploreAppViewController = ExploreAppViewController()
                self.present(exploreAppViewController, animated: true, completion: nil)
            }
        }
    }
}

extension BankDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - UIPickerView Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return banks.bank.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return banks.bank[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if banks.bank.count > 0 {
            selectedBankIndex = row
            bankNameTextField.text = banks.bank[row].name
        }
    }
}

extension BankDetailsViewController: RoutehiveTextFieldDelegate {
    
    // MARK: - RoutehiveTextFieldDelegate
    
    func shouldChangeCharecter(_ textField: UITextField) {
        
        if let customTextfield = textField as? RoutehiveTextField {
            customTextfield.hideErrorView()
        }
    }
}
