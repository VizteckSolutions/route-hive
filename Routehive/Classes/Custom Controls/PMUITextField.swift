//
//  PMUITextField.swift
//  PamperMoi
//
//  Created by Umair Afzal on 14/02/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import Foundation
import UIKit

protocol PMUITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField)
    func textFieldDidBeginEditing(_ textField: UITextField)
}

class PMUITextField: UITextField, UITextFieldDelegate {

    var isCreditCardTextField = false
    var isExpirayDateTextField =  false
    var isCvvField = false
    var isMobileNumberField = false
    var isVerificationCodeTextField = false

    var textFieldDelegate: PMUITextFieldDelegate?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupTextField()
        self.delegate = self
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
        self.delegate = self
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        _ = super.textRect(forBounds: bounds)

        if self.rightView != nil {
            let rect = CGRect(x: 20, y: 0, width: bounds.size.width - 60, height: bounds.size.height)
            return rect

        }

        let rect = CGRect(x: 20, y: 0, width: bounds.size.width - 20, height: bounds.size.height)
        return rect
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {

        if self.rightView != nil {
            let rect = CGRect(x: 20, y: 0, width: bounds.size.width - 60, height: bounds.size.height)
            return rect
        }

        let rect = CGRect(x: 20, y: 0, width: bounds.size.width - 20, height: bounds.size.height)
        return rect
    }

    func setupTextField() {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 0.0
        self.backgroundColor = UIColor.white
        self.borderStyle = .none
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = true

        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
    }
}

extension PMUITextField {

    // MARK: - UITextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        let currentLength: Int = currentText.count

        if isCreditCardTextField {

            if currentLength == 20 {
                textField.resignFirstResponder()
                return false
            }

            textField.text = currentText.grouping(every: 4, with: " ")
            return false

        } else if isExpirayDateTextField {

            if currentLength == 6 {
                textField.resignFirstResponder()
                return false
            }

            textField.text = currentText.grouping(every: 2, with: "/")
            return false

        } else if isCvvField {

            if currentLength == 4 {
                textField.resignFirstResponder()
                return false
            }

        } else if isVerificationCodeTextField {

            if currentLength == 5 {
                textField.resignFirstResponder()
                return false
            }
        }

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidBeginEditing(textField)

        if isMobileNumberField && textField.text == "" {
            textField.text = "+92"
        }

        if isVerificationCodeTextField {
            //textField.font = UIFont.appThemeFontWithSize(25.0)
            //textField.textAlignment = .center
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidEndEditing(textField)
    }
}
