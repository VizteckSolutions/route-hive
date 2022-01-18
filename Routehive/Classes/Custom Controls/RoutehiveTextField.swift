//
//  VTUITextField.swift
//  Labour Choice
//
//  Created by Umair on 21/06/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

@objc protocol RoutehiveTextFieldDelegate {
    @objc optional func textFieldDidEndEditing(_ textField: UITextField)
    @objc optional func textFieldDidBeginEditing(_ textField: UITextField)
    @objc optional func shouldChangeCharecter(_ textField: UITextField)
    @objc optional func shouldChangeCharecter(_ textField: UITextField, range: NSRange, string: String)
}

class RoutehiveTextField: UITextField, UITextFieldDelegate {
    
    var isCreditCardTextField = false
    var isExpirayDateTextField =  false
    var isCvvField = false
    var isMobileNumberField = false
    var isVerificationCodeTextField = false
    var isYearTextField = false
    var errorView = UIView()
    
    var textFieldDelegate: RoutehiveTextFieldDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupTextFieldUI()
        setupPadding()
        self.delegate = self
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextFieldUI()
        setupPadding()
        self.delegate = self
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        _ = super.textRect(forBounds: bounds)
        let rect = CGRect(
            x: 16, // 10
            y: 0,
            width: bounds.size.width,  //- 25,
            height: bounds.size.height
        )
        return rect
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: 16, // 10
            y: 0,
            width: bounds.size.width,  //-25,
            height: bounds.size.height + 5
        )
        return rect
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: 16, //10
            y: 0,
            width: bounds.size.width,
            height: bounds.size.height
        )
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= 00 // 10
        return textRect
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    // MARK: - Private Methods
    
    func setupTextFieldUI(){
        backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        font = UIFont.appThemeFontWithSize(16.0)
    }
    
    func setupPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: self.frame.size.height))
        rightView = paddingView
        leftView = paddingView
        leftViewMode = .always
        rightViewMode = .always
    }
    
    func showErrorView(errorMessage: String) {
        
        DispatchQueue.main.async {
            // setup Error View
            if let textFieldSuperView = self.superview {
                self.errorView.removeFromSuperview()
                textFieldSuperView.addSubview(self.errorView)
                self.errorView.isHidden = false
                self.errorView.backgroundColor = #colorLiteral(red: 0.8352941176, green: 0.1607843137, blue: 0.1529411765, alpha: 1)
                self.errorView.frame = CGRect(x: self.frame.origin.x + 6, y: self.frame.origin.y+self.frame.height - 2, width: self.frame.width - 12, height: 2.0)
                self.errorView.layer.cornerRadius = self.errorView.frame.height/2
                let userInfo : [String: Any] = [NSLocalizedDescriptionKey: errorMessage]
                let error = NSError(domain: APIClientHandlerErrorDomain, code: 11111, userInfo: userInfo)
                
                if let parentViewController = self.parentViewController {
                    error.showErrorBelowNavigation(viewController: parentViewController)
                }
            }
            
//            self.errorView.fadeIn()
            self.errorView.isHidden = false
        }
    }
    
    func hideErrorView() {
//        errorView.fadeOut()
        errorView.isHidden = true
        errorView.removeFromSuperview()
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if isCreditCardTextField {
            guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
            let currentLength: Int = currentText.count
            
            if currentLength == 20 {
                textField.resignFirstResponder()
                return false
            }
            
            textField.text = currentText.grouping(every: 4, with: " ")
            return false
            
        } else if isExpirayDateTextField {
            guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
            let currentLength: Int = currentText.count
            
            if currentLength == 6 {
                textField.resignFirstResponder()
                return false
            }
            
            textField.text = currentText.grouping(every: 2, with: "/")
            return false
            
        } else if isCvvField {
            guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
            let currentLength: Int = currentText.count
            
            if currentLength == 4 {
                textField.resignFirstResponder()
                return false
            }
        }
        
        textFieldDelegate?.shouldChangeCharecter?(textField, range: range, string: string)
        textFieldDelegate?.shouldChangeCharecter?(textField)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidEndEditing?(textField)
    }
}
