//
//  Localization.swift
//  Routehive
//
//  Created by Zeshan on 05/10/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import Foundation

typealias LocalizationCompletionHandler = (_ error: NSError?) -> Void

class Localization {
    
    class func getTranslations(completionBlock: @escaping LocalizationCompletionHandler) {
        
        APIClient.shared.fetchTranslations(lastUpdatedTime: Driver.shared.lastLanguageUpdatedTime) { (result, error) in
            
            if error == nil {
                
                if let data = result as? [String: AnyObject] {
                    
                    if let isTranslationUpdated = data["isTranslationUpdated"] as? Bool {
                        
                        if isTranslationUpdated {
                            
                            if let innerData = data["translations"] as? [String:String] {
                                
                                CoreDataHelper.clearLocalDB(completion: { (success, error) in
                                    
                                    if error == nil {
                                        
                                        CoreDataHelper.insertLanguage(usingDictionary: innerData, completion: { (success, error) in
                                            
                                            if error == nil {
                                                completionBlock(nil)
                                            }
                                        })
                                    }
                                })
                            }
                            
                        } else {
                            completionBlock(error)
                        }
                    }
                }
                
            } else {
                completionBlock(error)
            }
        }
    }
}

// MARK: - SignIn

class LocalizableSignIn {
    static let screenSpecifier = "Login_Sp_"
    static let title = screenSpecifier + "Title"
    static let subTitle = screenSpecifier + "SubTitle"
    static let emailPlaceholder = screenSpecifier +  "HintEmail"
    static let passwordPlaceHolder = screenSpecifier +  "HintPassword"
    static let loginButtonTitle = screenSpecifier +  "Login"
    static let forgorPsswordButtonTitle = screenSpecifier + "ForgotPwd"
    static let dontHaveAccount = screenSpecifier + "DontHaveAccount"
    static let signUpButtonTitle = screenSpecifier + "SignUp"
    static let emailValidationError = screenSpecifier + "ErrorInValidEmail"
    static let passwordValidationError = screenSpecifier + "ErrorInValidPassword"
    static let emailEmptyError = screenSpecifier + "ErrorInEmptyEmail"
    static let passwordEmptyError = screenSpecifier + "ErrorInEmptyPassword"
    
    static var emptyEmail = ""
    static var invalidEmail = ""
    static var emptyPassword = ""
    static var invalidPassword = ""
    
    
    class func setLanguage(viewController: SignInViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableSignIn.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.titleLabel.text = languageStrings[LocalizableSignIn.title]
                viewController.subTitleLabel.text = languageStrings[LocalizableSignIn.subTitle]
                viewController.emailTextField.placeholder = languageStrings[LocalizableSignIn.emailPlaceholder]
                viewController.passwordTextField.placeholder = languageStrings[LocalizableSignIn.passwordPlaceHolder]
                viewController.forgotPasswordButton.setTitle(languageStrings[LocalizableSignIn.forgorPsswordButtonTitle], for: .normal)
                viewController.loginButton.setTitle(languageStrings[LocalizableSignIn.loginButtonTitle], for: .normal)
                viewController.dontHaveAccountLabel.text = languageStrings[LocalizableSignIn.dontHaveAccount]
                viewController.signupButton.setTitle(languageStrings[LocalizableSignIn.signUpButtonTitle], for: .normal)
                LocalizableSignIn.emptyEmail = languageStrings[LocalizableSignIn.emailEmptyError] ?? ""
                LocalizableSignIn.invalidEmail = languageStrings[LocalizableSignIn.emailValidationError] ?? ""
                LocalizableSignIn.emptyPassword = languageStrings[LocalizableSignIn.passwordEmptyError] ?? ""
                LocalizableSignIn.invalidPassword = languageStrings[LocalizableSignIn.passwordValidationError] ?? ""
            }
        }
    }
}

class LocalizableForgotPassword {
    static let screenSpecifier = "Forgot_Password_Key_"
    
    static let title = screenSpecifier + "Title"
    static let message = screenSpecifier + "SubTitle"
    static let phoneNumberplaceholder = screenSpecifier + "PhoneNumber"
    static let sendVarificationCodeButtonTitle = screenSpecifier + "SendCode"
    static let emptyPhoneNumberError = screenSpecifier + "ErrorEmptyPhoneNumber"
    static var emptyPhoneNumber = ""
    
    static let locationScreenSpecifier = "Signup_Key_"
    static let locationPermision = locationScreenSpecifier + "LocationPermision"
    static let settingsButton = locationScreenSpecifier + "SettingsButton"
    
    class func setLanguage(viewController: ForgotPasswordViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableForgotPassword.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.descriptionLabel.text = languageStrings[LocalizableForgotPassword.message]
                viewController.numberTextField.placeholder = languageStrings[LocalizableForgotPassword.phoneNumberplaceholder]
                viewController.sendButton.setTitle(languageStrings[LocalizableForgotPassword.sendVarificationCodeButtonTitle], for: .normal)
                viewController.title = languageStrings[LocalizableForgotPassword.title]
                
                LocalizableForgotPassword.emptyPhoneNumber = languageStrings[LocalizableForgotPassword.emptyPhoneNumberError] ?? ""
            }
        }
    }
    
    class func setLocationPermissionLanguage(viewController: ForgotPasswordViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableForgotPassword.locationScreenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.locationPermisionMessage = languageStrings[locationPermision] ?? ""
                viewController.settingsButtonTitle = languageStrings[settingsButton] ?? ""
            }
        }
    }
}

class LocalizableSignInSignUpOptions {
    static let screenSpecifier = "Redirection_Key_"
    static let title = screenSpecifier + "Title"
    static let subtitle = screenSpecifier + "SubTitle"
    static let loginButtonTitle = screenSpecifier + "Login"
    static let signUpButtonTitle = screenSpecifier + "SignUp"
    
    class func setLanguage(viewController: SignSignUpOptionsViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableSignInSignUpOptions.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.titleLabel.text = languageStrings[LocalizableSignInSignUpOptions.title]
                viewController.subTitleLabel.text = languageStrings[LocalizableSignInSignUpOptions.subtitle] ?? "" + " © 2018"
                viewController.loginButton.setTitle(languageStrings[LocalizableSignInSignUpOptions.loginButtonTitle], for: .normal)
                viewController.signUpButton.setTitle(languageStrings[LocalizableSignInSignUpOptions.signUpButtonTitle], for: .normal)
            }
        }
    }
}

class LocalizableVerifyNumber {
    static let screenSpecifier = "Verify_Number_Key_"
    static let title = screenSpecifier + "Title"
    static let message = screenSpecifier + "SubTitle"
    static let notYourNumberButtonTitle = screenSpecifier + "NotYourNumber"
    static let verficationCodePlaceholder = screenSpecifier + "HintCode"
    static let verifyButtonText = screenSpecifier + "Verify"
    static let resendCodeButtonTitle = screenSpecifier + "ReSendCode"
    static let verifyGetStartedButton = screenSpecifier + "VerifyGetStarted"
    
    static var resendCodeSuccess = screenSpecifier + "ResendCodeSuccess"
    static var errorEmptyCode = screenSpecifier + "ErrorEmptyCode"
    
    class func setLanguage(viewController: VerifyNumberViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableVerifyNumber.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[LocalizableVerifyNumber.title]
                viewController.notYourNumberButton.setTitle(languageStrings[LocalizableVerifyNumber.notYourNumberButtonTitle], for: .normal)
                viewController.verificationCodeTextField.placeholder = languageStrings[LocalizableVerifyNumber.verficationCodePlaceholder]
                viewController.resendCodeButton.setTitle(languageStrings[LocalizableVerifyNumber.resendCodeButtonTitle], for: .normal)
                viewController.verifyButton.setTitle(languageStrings[LocalizableVerifyNumber.verifyButtonText], for: .normal)
                
                viewController.detailText = languageStrings[LocalizableVerifyNumber.message] ?? ""
                viewController.verifyGetStartedButtonTitle = languageStrings[LocalizableVerifyNumber.verifyGetStartedButton] ?? ""
                viewController.verifyButtonTitle = languageStrings[LocalizableVerifyNumber.verifyButtonText] ?? ""
                viewController.resendCodeSuccess = languageStrings[resendCodeSuccess] ?? ""
                viewController.errorEmptyCode = languageStrings[errorEmptyCode] ?? ""
            }
        }
    }
}

class LocalizableResetPassword {
    static let screenSpecifier = "Reset_Password_"
    static let title = screenSpecifier + "Title"
    static let message = screenSpecifier + "SubTitle"
    static let passwordPlaceholder = screenSpecifier + "Hint_NewPassword"
    static let confirmPasswordPlaceholder = screenSpecifier + "Hint_ConfirmPassword"
    static let resetPasswordButtonTitle = screenSpecifier + "ResetPassword"
    static let successResetPasswordMessage = screenSpecifier + "SuccessResetPassword"
    static let successLoginMessage = screenSpecifier + "SuccessLogin"
    static let loginButtonTitle = screenSpecifier + "ButtonLogin"
    static let passwordNotMatchError = screenSpecifier + "Error_PasswordNotMatched"
    static let errorEmptyPassword = screenSpecifier + "ErrorEmptyPassword"
    static let errorEmptyConfirmPassword = screenSpecifier + "ErrorEmptyConfirmPassword"
    
    
    static var emptyPassword = ""
    static var emptyConfirmPassword = ""
    static var errorPasswordMatched = ""
    
    class func setLanguage(viewController: ResetPasswordViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableResetPassword.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[LocalizableResetPassword.title]
                viewController.messageLabel.text = languageStrings[LocalizableResetPassword.message]
                viewController.passwordTextField.placeholder = languageStrings[LocalizableResetPassword.passwordPlaceholder]
                viewController.confirmPasswordTextField.placeholder = languageStrings[LocalizableResetPassword.confirmPasswordPlaceholder]
                viewController.resetPasswordButton.setTitle(languageStrings[LocalizableResetPassword.resetPasswordButtonTitle], for: .normal)
                viewController.successMessageLabel.text = "\(languageStrings[LocalizableResetPassword.successResetPasswordMessage] ?? "")\n\(languageStrings[LocalizableResetPassword.successLoginMessage] ?? "")"
                viewController.loginButton.setTitle(languageStrings[LocalizableResetPassword.loginButtonTitle], for: .normal)
                
                emptyPassword = languageStrings[LocalizableResetPassword.errorEmptyPassword] ?? ""
                emptyConfirmPassword = languageStrings[LocalizableResetPassword.errorEmptyConfirmPassword] ?? ""
                errorPasswordMatched = languageStrings[LocalizableResetPassword.passwordNotMatchError] ?? ""
            }
        }
    }
}

// MARK: - SignUp

class LocalizableSignUp {
    static let screenSpecifier = "Signup_Key_"
    static let title = screenSpecifier + "Title"
    static let subTitle = screenSpecifier + "SubTitle"
    static let emailPlaceholder = screenSpecifier +  "HintEmail"
    static let signUpButtonTitle = screenSpecifier +  "SignUp"
    static let alreadyHaveAccount = screenSpecifier + "AlreadyHaveAccount"
    static let loginButtonTitle = screenSpecifier + "Login"
    static let errorEmptyEmail = screenSpecifier + "ErrorEmptyEmail"
    static let errorInvalidEmail = screenSpecifier + "ErrorInvalidEmail"
    
    static let locationPermision = screenSpecifier + "LocationPermision"
    static let settingsButton = screenSpecifier + "SettingsButton"
    
    class func setLanguage(viewController: SignUpViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableSignUp.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.signupTitleLabel.text = languageStrings[LocalizableSignUp.title]
                viewController.signupDetailLabel.text = languageStrings[LocalizableSignUp.subTitle]
                viewController.emailTextField.placeholder = languageStrings[LocalizableSignUp.emailPlaceholder]
                viewController.signupButton.setTitle(languageStrings[LocalizableSignUp.signUpButtonTitle], for: .normal)
                viewController.loginButton.setTitle(languageStrings[LocalizableSignUp.loginButtonTitle], for: .normal)
                viewController.alreadyAccountLabel.text = languageStrings[LocalizableSignUp.alreadyHaveAccount]
                
                viewController.errorEmptyEmail = languageStrings[LocalizableSignUp.errorEmptyEmail] ?? ""
                viewController.errorInvalidEmail = languageStrings[LocalizableSignUp.errorInvalidEmail] ?? ""
                viewController.locationPermisionMessage = languageStrings[locationPermision] ?? ""
                viewController.settingsButtonTitle = languageStrings[settingsButton] ?? ""
            }
        }
    }
}

class LocalizableEmailVerificationPopup {
    static let screenSpecifier = "Email_Sent_Key_"
    static let message = screenSpecifier + "Body"
    static let buttonTitle = screenSpecifier + "ButtonContinue"
    
    class func setLanguage(viewController: EmailVerificationPopupViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableEmailVerificationPopup.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.detailLabel.text = languageStrings[LocalizableEmailVerificationPopup.message]
                viewController.okButton.setTitle(languageStrings[LocalizableEmailVerificationPopup.buttonTitle], for: .normal)
            }
        }
    }
}

class LocalizableSuccessfullEmailPopup {
    static let screenSpecifier = "EmailVerified_Key_"
    static let title = screenSpecifier + "Heading"
    static let message = screenSpecifier + "Body"
    static let buttonTitle = screenSpecifier + "Continue"
    
    class func setLanguage(viewController: SuccessfullPopupViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableSuccessfullEmailPopup.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.titleLabel.text = languageStrings[LocalizableSuccessfullEmailPopup.title]
                viewController.detailLabel.text = languageStrings[LocalizableSuccessfullEmailPopup.message]
                viewController.continueButton.setTitle(languageStrings[LocalizableSuccessfullEmailPopup.buttonTitle], for: .normal)
            }
        }
    }
}

class LocalizableSignUpProfile {
    static let screenSpecifier = "ProfileReg_Key_"
    static let title = screenSpecifier + "Title"
    static let message = screenSpecifier + "SubTitle"
    static let firstNamePlaceholder = screenSpecifier + "FirstName"
    static let lastNamePlaceholder = screenSpecifier + "LastName"
    static let phoneNumberPlaceholder = screenSpecifier + "PhoneNumber"
    static let createPasswordPlaceholder = screenSpecifier + "Password"
    static let referralCodePlaceholder = screenSpecifier + "ReferralCode"
    
    static let readCondition = screenSpecifier + "ReadConditions"
    static let readConditionLabel = screenSpecifier + "ReadConditionLabel"
    static let termsConditionButtonTitle = screenSpecifier + "TermsConditions"
    static let continueButtonTitle = screenSpecifier + "Continue"
    static let errorFirstName = screenSpecifier + "ErrorEmptyFirstName"
    static let errorLastName = screenSpecifier + "ErrorEmptyLastName"
    static let errorPhoneNumber = screenSpecifier + "ErrorEmptyPhoneNumber"
    static let errorPassword = screenSpecifier + "ErrorEmptyPassword"
    static let errorTerms = screenSpecifier + "ErrorTermsCondtions"
    static let errorInvalidPassword = screenSpecifier + "Error_InvalidPassword"
    static let errorEmptyProfileImage = screenSpecifier + "Error_NoImage"
    
    class func setLanguage(viewController: SignUpProfileViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableSignUpProfile.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[LocalizableSignUpProfile.title]
                viewController.detailLabel.text = languageStrings[LocalizableSignUpProfile.message]
                
                viewController.firstNameTextField.placeholder = languageStrings[LocalizableSignUpProfile.firstNamePlaceholder]
                viewController.lastNameTextField.placeholder = languageStrings[LocalizableSignUpProfile.lastNamePlaceholder]
                viewController.phoneNumberTextField.placeholder = languageStrings[LocalizableSignUpProfile.phoneNumberPlaceholder]
                viewController.passwordTextField.placeholder = languageStrings[LocalizableSignUpProfile.createPasswordPlaceholder]
                viewController.referalCodeTextField.placeholder = languageStrings[LocalizableSignUpProfile.referralCodePlaceholder]
//                viewController.termsLabel.text = languageStrings[LocalizableSignUpProfile.readConditionLabel]
                
//                viewController.termsConditionButton.setTitle(languageStrings[LocalizableSignUpProfile.termsConditionButtonTitle], for: .normal)
                viewController.continueButton.setTitle(languageStrings[LocalizableSignUpProfile.continueButtonTitle], for: .normal)
                
                viewController.termsTextView.attributedText = NSMutableAttributedString().attributedString(withText: languageStrings[LocalizableSignUpProfile.readCondition] ?? "", color: #colorLiteral(red: 0.7921568627, green: 0, blue: 0.05098039216, alpha: 1), textColor: #colorLiteral(red: 0.1450980392, green: 0.137254902, blue: 0.1450980392, alpha: 1), colorChnageString: [languageStrings[LocalizableSignUpProfile.termsConditionButtonTitle]?.lowercased() ?? ""], linkable: true, links: [kTermsAndConditionsUrl], font: .appThemeFontWithSize(16.0))
//                viewController.termsTextView.isScrollEnabled = false
                viewController.errorEmptyFirstName = languageStrings[LocalizableSignUpProfile.errorFirstName] ?? ""
                viewController.errorEmptyLastName = languageStrings[LocalizableSignUpProfile.errorLastName] ?? ""
                viewController.errorEmptyPhoneNumber = languageStrings[LocalizableSignUpProfile.errorPhoneNumber] ?? ""
                viewController.errorEmptyPassword = languageStrings[LocalizableSignUpProfile.errorPassword] ?? ""
                viewController.errorInvalidPassword = languageStrings[LocalizableSignUpProfile.errorInvalidPassword] ?? ""
                viewController.errorProfileImage = languageStrings[LocalizableSignUpProfile.errorEmptyProfileImage] ?? ""
                viewController.errorTermsConditions = languageStrings[LocalizableSignUpProfile.errorTerms] ?? ""
            }
        }
    }
}

class LocalizableVehicleInfo {
    static let screenSpecifier = "VehicleInfo_Key_"
    static let title = screenSpecifier + "Title"
    static let message = screenSpecifier + "SubTitle"
    
    static let ownerShipPlaceholder = screenSpecifier + "VehicleOwner"
    static let vehicleTypePlaceholder = screenSpecifier + "VehicleType"
    static let manufecturerPlaceholder = screenSpecifier + "Manufacturer"
    static let modelPlaceholder = screenSpecifier + "Model"
    static let companyNamePlaceholder = screenSpecifier + "CompanyName"
    static let companyRegistrationPlaceholder = screenSpecifier + "CompanyRegistration"
    static let plateNumberPlaceholder = screenSpecifier + "PlateNumber"
    static let vehicleColorPlaceholder = screenSpecifier + "Color"
    static let insuranceExpiryPlaceholder = screenSpecifier + "InsuranceExpiry"
    static let inspectionExpiryPlaceholder = screenSpecifier + "InspectionExpiry"
    
    static let registrationCardLabel = screenSpecifier + "TagRegistration"
    static let insuranceCoverLabel = screenSpecifier + "TagInsurance"
    static let inspectionCoverLabel = screenSpecifier + "TagInspection"
    static let frontSideLabel = screenSpecifier + "FrontSideLabel"
    
    
    static let nextButtonTitle = screenSpecifier + "Next"
    static let backupDriverButtonTitle = screenSpecifier + "BackupDriverButtonTitle"
    
    static let errorVehicleOwnerShip = screenSpecifier + "ErrorVehicleOwnerShip"
    static let errorVehicleType = screenSpecifier + "ErrorVehicleType"
    static let errorManufaturer = screenSpecifier + "ErrorManufaturer"
    static let errorModel = screenSpecifier + "ErrorModel"
    static let errorCompanyName = screenSpecifier + "ErrorCompanyName"
    static let errorCompanyRegistrationNumber = screenSpecifier + "ErrorRegistrationNumber"
    static let errorVehiclePlateNumber = screenSpecifier + "ErrorVehiclePlateNumber"
    static let errorVehicleColor = screenSpecifier + "ErrorVehicleColor"
    static let errorRegistrationImage = screenSpecifier + "ErrorRegistrationImage"
    static let errorInsuranceImage = screenSpecifier + "ErrorInsuranceImage"
    static let errorInspectionImage = screenSpecifier + "ErrorInspectionImage"
    
    static let errorUploadingImage = screenSpecifier + "ErrorUploadingImage"
    static let errorImageProgress = screenSpecifier + "ErrorImageProgress"
    static let errorInsuranceExpiry = screenSpecifier + "ErrorInsuranceExpiry"
    static let errorInspectionExpiry = screenSpecifier + "ErrorInspectionExpiry"
    static let errorCombination = screenSpecifier + "ErrorCombination"
    static let doneLabel = screenSpecifier + "Done"
    static let cancelLabel = screenSpecifier + "Cancel"
    static let personalLabel = screenSpecifier + "Personal"
    static let companyLabel = screenSpecifier + "Company"

    class func setLanguage(viewController: VehicleInfoViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableVehicleInfo.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[LocalizableVehicleInfo.title]
                viewController.titleLabel.text = languageStrings[LocalizableVehicleInfo.message]
                
                viewController.vehicleOwnerShipTextField.placeholder = languageStrings[LocalizableVehicleInfo.ownerShipPlaceholder]
                viewController.vehicleTypeTextField.placeholder = languageStrings[LocalizableVehicleInfo.vehicleTypePlaceholder]
                viewController.manufaturerTextField.placeholder = languageStrings[LocalizableVehicleInfo.manufecturerPlaceholder]
                viewController.modelTextField.placeholder = languageStrings[LocalizableVehicleInfo.modelPlaceholder]
                viewController.companyNameTextField.placeholder = languageStrings[LocalizableVehicleInfo.companyNamePlaceholder]
                viewController.companyRegistrationNumberTextField.placeholder = languageStrings[LocalizableVehicleInfo.companyRegistrationPlaceholder]
                viewController.vehiclePlateNumberTextField.placeholder = languageStrings[LocalizableVehicleInfo.plateNumberPlaceholder]
                viewController.vehicleColorTextField.placeholder = languageStrings[LocalizableVehicleInfo.vehicleColorPlaceholder]
                viewController.insuranceExpiryTextField.placeholder = languageStrings[insuranceExpiryPlaceholder]
                viewController.inspectionExpiryDateTextField.placeholder = languageStrings[inspectionExpiryPlaceholder]
                
                if Driver.shared.country == CountryType.Indonesia.rawValue {
                    viewController.vehicleRegistrationCardLabel.text = "STNK (Surat Tanda Nomor Kendaraan)"
                    
                } else {
                    viewController.vehicleRegistrationCardLabel.text = languageStrings[LocalizableVehicleInfo.registrationCardLabel]
                }
                
                viewController.vehicleInsuranceCoverLabel.text = languageStrings[LocalizableVehicleInfo.insuranceCoverLabel]
                viewController.vehicleInspectionCoverLabel.text = languageStrings[LocalizableVehicleInfo.inspectionCoverLabel]
                
                viewController.registrationFrontSideLabel.text = languageStrings[LocalizableVehicleInfo.frontSideLabel]
                viewController.insuranceFrontSideLabel.text = languageStrings[LocalizableVehicleInfo.frontSideLabel]
                viewController.inspectionFrontSideLabel.text = languageStrings[LocalizableVehicleInfo.frontSideLabel]
                
                viewController.nextButton.setTitle(languageStrings[LocalizableVehicleInfo.nextButtonTitle], for: .normal)
                viewController.optBackupDriverButton.setTitle(languageStrings[LocalizableVehicleInfo.backupDriverButtonTitle], for: .normal)
                
                viewController.errorVehicleOwnerShip = languageStrings[LocalizableVehicleInfo.errorVehicleOwnerShip] ?? ""
                viewController.errorVehicleType = languageStrings[LocalizableVehicleInfo.errorVehicleType] ?? ""
                viewController.errorManufaturer = languageStrings[LocalizableVehicleInfo.errorManufaturer] ?? ""
                viewController.errorModel = languageStrings[LocalizableVehicleInfo.errorModel] ?? ""
                viewController.errorCompanyName = languageStrings[LocalizableVehicleInfo.errorCompanyName] ?? ""
                viewController.errorCompanyRegistrationNumber = languageStrings[LocalizableVehicleInfo.errorCompanyRegistrationNumber] ?? ""
                viewController.errorVehiclePlateNumber = languageStrings[LocalizableVehicleInfo.errorVehiclePlateNumber] ?? ""
                viewController.errorVehicleColor = languageStrings[LocalizableVehicleInfo.errorVehicleColor] ?? ""
                viewController.errorRegistrationImage = languageStrings[LocalizableVehicleInfo.errorRegistrationImage] ?? ""
                viewController.errorInsuranceImage = languageStrings[LocalizableVehicleInfo.errorInsuranceImage] ?? ""
                viewController.errorInspectionImage = languageStrings[LocalizableVehicleInfo.errorInspectionImage] ?? ""
                
                viewController.errorUploadingImage = languageStrings[LocalizableVehicleInfo.errorUploadingImage] ?? ""
                viewController.errorImageProgress = languageStrings[LocalizableVehicleInfo.errorImageProgress] ?? ""
                viewController.errorInsuranceExpiry = languageStrings[errorInsuranceExpiry] ?? ""
                viewController.errorInspectionExpiry = languageStrings[errorInspectionExpiry] ?? ""
                
                viewController.errorCombination = languageStrings[errorCombination] ?? ""
                viewController.doneLabel = languageStrings[doneLabel] ?? ""
                viewController.cancelLabel = languageStrings[cancelLabel] ?? ""
                
                viewController.personalLabel = languageStrings[personalLabel] ?? ""
                viewController.companyLabel = languageStrings[companyLabel] ?? ""
            }
        }
    }
}

class LocalizableBackupDriver {
    static let screenSpecifier = "BackupDriver_Key_"
    static let titleLabel = screenSpecifier + "Title"
    static let detailLabel = screenSpecifier + "SubTitle"
    static let okButtonTitle = screenSpecifier + "Okay"
    
    class func setLanguage(viewController: BackUpDriverPopupViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableBackupDriver.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.titleLabel.text = languageStrings[LocalizableBackupDriver.titleLabel]
                viewController.detailLabel.text = languageStrings[LocalizableBackupDriver.detailLabel]
                viewController.okButton.setTitle(languageStrings[LocalizableBackupDriver.okButtonTitle], for: .normal)
            }
        }
    }
}


class LocalizableMyKad {
    static let screenSpecifier = "MyKad_Key_"
    static let title = screenSpecifier + "Title"
    static let message = screenSpecifier + "SubTitle"
    
    static let indonesiaMessage = screenSpecifier + "IndonesiaSubTitle"
    static let skckSubTitle = screenSpecifier + "SkckSubTitle"
    static let backSideLabel = screenSpecifier + "BackSideLabel"
    
    static let frontSideLabel = screenSpecifier + "FrontSideLabel"
    static let nextButtonTitle = screenSpecifier + "Next"
    
    static let errorUploadingImageA = screenSpecifier + "ErrorUploadingImageA"
    static let errorUploadingImageB = screenSpecifier + "ErrorUploadingImageB"
    static let errorUploadingImageServer = screenSpecifier + "ErrorUploadingImageServer"
    static let errorImageProgress = screenSpecifier + "ErrorImageProgress"
    
    class func setLanguage(viewController: MyKadViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableMyKad.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                
                if Driver.shared.country == CountryType.Indonesia.rawValue {
                    viewController.title = "KTP (Kartu Tanda Penduduk)"
                    viewController.titleLabel.text = languageStrings[LocalizableMyKad.indonesiaMessage]
                    viewController.skckTitleLabel.text = languageStrings[skckSubTitle]
                    
                } else {
                    viewController.title = languageStrings[LocalizableMyKad.title]
                    viewController.titleLabel.text = languageStrings[LocalizableMyKad.message]
                }
                
                viewController.frontSideLabel.text = languageStrings[LocalizableMyKad.frontSideLabel]
                viewController.backSideLabel.text = languageStrings[LocalizableMyKad.backSideLabel]
                viewController.skckFrontSideLabel.text = languageStrings[LocalizableMyKad.frontSideLabel]
                viewController.nextButton.setTitle(languageStrings[LocalizableMyKad.nextButtonTitle], for: .normal)
                
                viewController.errorUploadingImageA = languageStrings[errorUploadingImageA] ?? ""
                viewController.errorUploadingImageB = languageStrings[errorUploadingImageB] ?? ""
                viewController.errorUploadingImageServer = languageStrings[errorUploadingImageServer] ?? ""
                viewController.errorImageProgress = languageStrings[errorImageProgress] ?? ""
            }
        }
    }
}

class LocalizableDrivingLicense {
    static let screenSpecifier = "DrivingLicense_Key_"
    static let title = screenSpecifier + "Title"
    static let message = screenSpecifier + "SubTitle"
    static let indonesiaMessage = screenSpecifier + "IndonesiaSubTitle"
    static let frontSideLabel = screenSpecifier + "FrontSideLabel"
    static let licenseExpiryPlaceholder = screenSpecifier + "LicenseExpiry"
    static let SIMExpiryPlaceholder = screenSpecifier + "SIMExpiry"
    static let nextButtonTitle = screenSpecifier + "Next"
    static let errorExpiryDate = screenSpecifier + "ErrorExpiryDate"
    static let errorSIMExpiryDate = screenSpecifier + "ErrorSIMExpiryDate"
    
    static let errorImageUpload = screenSpecifier + "ErrorImageUpload"
    static let doneLabel = screenSpecifier + "Done"
    static let cancelLabel = screenSpecifier + "Cancel"
    
    class func setLanguage(viewController: DrivingLicenseViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableDrivingLicense.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                
                if Driver.shared.country == CountryType.Indonesia.rawValue {
                    viewController.title = "SIM (Surat Ijin Mengemudi)"
                    viewController.titleLabel.text = languageStrings[LocalizableDrivingLicense.indonesiaMessage]
                    viewController.expiryDateTextField.placeholder = languageStrings[LocalizableDrivingLicense.SIMExpiryPlaceholder]
                    viewController.errorExpiryDate = languageStrings[LocalizableDrivingLicense.errorSIMExpiryDate] ?? ""
                    
                } else {
                    viewController.title = languageStrings[LocalizableDrivingLicense.title]
                    viewController.titleLabel.text = languageStrings[LocalizableDrivingLicense.message]
                    viewController.expiryDateTextField.placeholder = languageStrings[LocalizableDrivingLicense.licenseExpiryPlaceholder]
                    viewController.errorExpiryDate = languageStrings[LocalizableDrivingLicense.errorExpiryDate] ?? ""
                }
                
                viewController.frontSideLabel.text = languageStrings[LocalizableDrivingLicense.frontSideLabel]
                viewController.nextButton.setTitle(languageStrings[LocalizableDrivingLicense.nextButtonTitle], for: .normal)
                viewController.doneLabel = languageStrings[doneLabel] ?? ""
                viewController.cancelLabel = languageStrings[cancelLabel] ?? ""
                viewController.errorImageUpload = languageStrings[errorImageUpload] ?? ""
            }
        }
    }
}

class LocalizableBankDetail {
    static let screenSpecifier = "Bank_Key_"
    static let title = screenSpecifier + "Title"
    static let message = screenSpecifier + "SubTitle"
    static let bankNamePlaceholder = screenSpecifier + "BankName"
    static let accountHolderNamePlaceholder = screenSpecifier + "HolderName"
    static let accountNumberPlaceholder = screenSpecifier + "AccountNumber"
    static let doneButtonTitle = screenSpecifier + "Done"
    
    static let errorBankName = screenSpecifier + "ErrorBankName"
    static let errorAccountTitle = screenSpecifier + "ErrorAccountHolderName"
    static let errorAccountNumber = screenSpecifier + "ErrorAccountNumber"
    
    class func setLanguage(viewController: BankDetailsViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableBankDetail.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[LocalizableBankDetail.title]
                viewController.titleLabel.text = languageStrings[LocalizableBankDetail.message]
                viewController.bankNameTextField.placeholder = languageStrings[LocalizableBankDetail.bankNamePlaceholder]
                viewController.accountTitleTextField.placeholder = languageStrings[LocalizableBankDetail.accountHolderNamePlaceholder]
                viewController.accountNumberTextField.placeholder = languageStrings[LocalizableBankDetail.accountNumberPlaceholder]
                viewController.doneButton.setTitle(languageStrings[LocalizableBankDetail.doneButtonTitle], for: .normal)
                
                viewController.errorBankName = languageStrings[LocalizableBankDetail.errorBankName] ?? ""
                viewController.errorAccountTitle = languageStrings[LocalizableBankDetail.errorAccountTitle] ?? ""
                viewController.errorAccountNumber = languageStrings[LocalizableBankDetail.errorAccountNumber] ?? ""
            }
        }
    }
}

class LocalizableEploreApp {
    static let screenSpecifier = "ExploreApp_Key_"
    static let message = screenSpecifier + "Body"
    static let exploreAppButtonTitle = screenSpecifier + "ExploreApp"
    
    class func setLanguage(viewController: ExploreAppViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableEploreApp.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.detailLabel.text = languageStrings[LocalizableEploreApp.message]
                viewController.exploreAppButton.setTitle(languageStrings[LocalizableEploreApp.exploreAppButtonTitle], for: .normal)
            }
        }
    }
}

// MARK: - Account Section

class LocalizableAccount {
    static let screenSpecifier = "Account_Key_"
    static let title = screenSpecifier + "Title"
    static let myProfile = screenSpecifier + "MyProfile"
    static let earnings = screenSpecifier + "Earnings"
    static let help = screenSpecifier + "Help"
    static let language = screenSpecifier + "Language"
    static let referDriver = screenSpecifier + "ReferADriver"
    static let logout = screenSpecifier + "Logout"
    static let jobsCompleted = screenSpecifier + "JobsCompleted"
    
    class func setLanguage(viewController: AccountViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableAccount.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[LocalizableAccount.title]
                viewController.myProfile = languageStrings[LocalizableAccount.myProfile] ?? ""
                viewController.earnings = languageStrings[LocalizableAccount.earnings] ?? ""
                viewController.help = languageStrings[LocalizableAccount.help] ?? ""
                viewController.language = languageStrings[LocalizableAccount.language] ?? ""
                viewController.referDriver = languageStrings[LocalizableAccount.referDriver] ?? ""
                viewController.logout = languageStrings[LocalizableAccount.logout] ?? ""
                viewController.jobCompletedLabel = languageStrings[LocalizableAccount.jobsCompleted] ?? ""
            }
        }
    }
}

class LocalizableMyProfile {
    static let screenSpecifier = "MyProfile_Key_"
    static let title = screenSpecifier + "Title"
    static let nameTitleLabel = screenSpecifier + "NameTitleLabel"
    static let phoneNumberTitleLabel = screenSpecifier + "PhoneNumberTitleLabel"
    static let emailTitleLabel = screenSpecifier + "EmailTitleLabel"
    static let editButtonTitle = screenSpecifier + "EditButtonTitle"
    static let changePasswordButtonTitle = screenSpecifier + "ChangePasswordButtonTitle"
    static let profileSuccess = screenSpecifier + "ProfileSuccess"
    static let passwordSuccess = screenSpecifier + "PasswordSuccess"
    
    class func setLanguage(viewController: ProfileViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableMyProfile.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[LocalizableMyProfile.title]
                viewController.changePasswordButton.setTitle(languageStrings[LocalizableMyProfile.changePasswordButtonTitle], for: .normal)
                viewController.nameTitleLabel.text = languageStrings[LocalizableMyProfile.nameTitleLabel]
                viewController.phoneNumberTitleLabel.text = languageStrings[LocalizableMyProfile.phoneNumberTitleLabel]
                viewController.emailTitleLabel.text = languageStrings[LocalizableMyProfile.emailTitleLabel]
                viewController.editButton.setTitle(languageStrings[LocalizableMyProfile.editButtonTitle], for: .normal)
                
                viewController.profileSuccess = languageStrings[profileSuccess] ?? ""
                viewController.PasswordSuccess = languageStrings[passwordSuccess] ?? ""
            }
        }
    }
}

class LocalizableEditProfile {
    static let screenSpecifier = "EditProfile_Key_"
    static let title = screenSpecifier + "Title"
    static let firstNamePlaceholder = screenSpecifier + "FirstNamePlaceholder"
    static let lastNamePlaceholder = screenSpecifier + "LastNamePlaceholder"
    static let phoneNumberPlaceholder = screenSpecifier + "PhoneNumberPlaceholder"
    static let saveButtonTitle = screenSpecifier + "SaveButtonTitle"
    
    static let errorEmptyFirstName = screenSpecifier + "ErrorEmptyFirstName"
    static let errorEmptyLastName = screenSpecifier + "ErrorEmptyLastName"
    static let errorEmptyPhoneNumber = screenSpecifier + "ErrorEmptyPhoneNumber"
    static let errorEmptyProfileImage = screenSpecifier + "ErrorEmptyProfileImage"
    
    class func setLanguage(viewController: EditProfileViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableEditProfile.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[LocalizableEditProfile.title]
                viewController.firstNameTextField.placeholder = languageStrings[LocalizableEditProfile.firstNamePlaceholder]
                viewController.lastNameTextField.placeholder = languageStrings[LocalizableEditProfile.lastNamePlaceholder]
                viewController.phoneNumberTextField.placeholder = languageStrings[LocalizableEditProfile.phoneNumberPlaceholder]
                viewController.saveButton.setTitle(languageStrings[LocalizableEditProfile.saveButtonTitle], for: .normal)
                
                viewController.errorFirstName = languageStrings[LocalizableEditProfile.errorEmptyFirstName] ?? ""
                viewController.errorLastName = languageStrings[LocalizableEditProfile.errorEmptyLastName] ?? ""
                viewController.errorPhoneNumber = languageStrings[LocalizableEditProfile.errorEmptyPhoneNumber] ?? ""
                viewController.errorProfileImage = languageStrings[LocalizableEditProfile.errorEmptyProfileImage] ?? ""
            }
        }
    }
}

class LocalizableChangePassword {
    static let screenSpecifier = "ChangePassword_Key_"
    static let title = screenSpecifier + "Title"
    
    static let currentPasswordPlaceholder = screenSpecifier + "CurrentPasswordPlaceholder"
    static let newPasswordPlaceholder = screenSpecifier + "NewPasswordPlaceholder"
    static let confirmPasswordPlaceholder = screenSpecifier + "ConfirmPasswordPlaceholder"
    
    
    static let errorEmptyCurrentPassword = screenSpecifier + "ErrorEmptyCurrentPassword"
    static let errorEmptyNewPassword = screenSpecifier + "ErrorEmptyNewPassword"
    static let errorEmptyConfirmPassword = screenSpecifier + "ErrorEmptyConfirmPassword"
    static let errorPasswordMissMatch = screenSpecifier + "ErrorPasswordMissMatch"
    
    class func setLanguage(viewController: ChangePasswordViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableChangePassword.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[LocalizableChangePassword.title]
                
                viewController.currentPasswordTextField.placeholder = languageStrings[LocalizableChangePassword.currentPasswordPlaceholder]
                viewController.newPasswordTextField.placeholder = languageStrings[LocalizableChangePassword.newPasswordPlaceholder]
                viewController.confirmNewPasswordTextField.placeholder = languageStrings[LocalizableChangePassword.confirmPasswordPlaceholder]
                viewController.errorEmptyCurrentPassword = languageStrings[LocalizableChangePassword.errorEmptyCurrentPassword] ?? ""
                viewController.errorEmptyNewPassword = languageStrings[LocalizableChangePassword.errorEmptyNewPassword] ?? ""
                viewController.errorEmptyConfirmPassword = languageStrings[LocalizableChangePassword.errorEmptyConfirmPassword] ?? ""
                viewController.errorPasswordMissMatch = languageStrings[LocalizableChangePassword.errorPasswordMissMatch] ?? ""
                viewController.changePasswordButton.setTitle(languageStrings[LocalizableChangePassword.title], for: .normal)
            }
        }
    }
}

class LocalizableReferalCode {
    static let screenSpecifier = "ReferADriver_Key_"
    static let title = screenSpecifier + "Title"
    
    static let messageTitle = screenSpecifier + "MessageTitle"
    static let messageDetail = screenSpecifier + "MessageDetail"
    static let referalMessage = screenSpecifier + "ReferalMessage"
    static let copyButtonTitle = screenSpecifier + "CopyButtonTitle"
    
    class func setLanguage(viewController: ShareRaferralViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableReferalCode.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[LocalizableReferalCode.title]
                viewController.messageTitleLabel.text = languageStrings[LocalizableReferalCode.messageTitle]
                viewController.messageDetailLabel.text = languageStrings[LocalizableReferalCode.messageDetail]
               viewController.referalMessage = languageStrings[referalMessage] ?? ""
                viewController.copyButton.setTitle(languageStrings[LocalizableReferalCode.copyButtonTitle], for: .normal)
            }
        }
    }
}

class LocalizableLanguageScreen {
    static let screenSpecifier = "Language_Key_"
    static let title = screenSpecifier + "Title"
    static let applyButtonTitle = screenSpecifier + "ApplyButtonTitle"
    
    class func setLanguage(viewController: ChangeLanguageViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableLanguageScreen.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[LocalizableLanguageScreen.title]
                viewController.applyButton.setTitle(languageStrings[LocalizableLanguageScreen.applyButtonTitle], for: .normal)
            }
        }
    }
}

class LocalizableEarningsScreen {
    static let screenSpecifier = "Earning_Key_"
    static let earningTitle = screenSpecifier + "EarningTitle"
    static let jobsLabel = screenSpecifier + "Jobs"
    static let jobLabel = screenSpecifier + "Job"
    static let viewTransactionsButtonTitle = screenSpecifier + "ViewTransactions"
    
    class func setLanguage(viewController: EarningsViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableEarningsScreen.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[earningTitle]
                viewController.viewTransactionButtonTitle = languageStrings[viewTransactionsButtonTitle] ?? ""
                viewController.jobLabel = languageStrings[jobLabel] ?? ""
                viewController.jobsLabel = languageStrings[jobsLabel] ?? ""
            }
        }
    }
}

class LocalizableWeekListingScreen {
    static let screenSpecifier = "Earning_Key_"
    static let title = screenSpecifier + "PastWeeksTitle"
    static let errorNoWeeks = screenSpecifier + "NoPastWeeks"
    
    class func setLanguage(viewController: WeekListingViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableWeekListingScreen.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[title]
                viewController.errorNoWeeks = languageStrings[errorNoWeeks] ?? ""
            }
        }
    }
}

class LocalizableWeeklyTransactionScreen {
    static let screenSpecifier = "Earning_Key_"
    static let title = screenSpecifier + "WeeklyTransaction"
    
    class func setLanguage(viewController: WeeklyTransactionsViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableWeeklyTransactionScreen.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[title]
            }
        }
    }
}

class LocalizableTransactionDetailScreen {
    static let screenSpecifier = "Earning_Key_"
    static let title = screenSpecifier + "TransactionTitle"
    static let customerLabel = screenSpecifier + "Customer"
    static let yourEarningLabel = screenSpecifier + "YourEarning"
    static let pickupLabel = screenSpecifier + "Pickup"
    static let dropoffLabel = screenSpecifier + "Dropoff"
    static let quantityLabel = screenSpecifier + "Quantity"
    static let itemValLabel = screenSpecifier + "price"
    
    class func setLanguage(viewController: TransactionDetailsViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableTransactionDetailScreen.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[title]
                viewController.customerLabel = languageStrings[customerLabel] ?? ""
                viewController.yourEarningLabel = languageStrings[yourEarningLabel] ?? ""
                viewController.pickupLabel = languageStrings[pickupLabel] ?? ""
                viewController.dropoffLabel = languageStrings[dropoffLabel] ?? ""
                viewController.quantityLabel = languageStrings[quantityLabel] ?? ""
                viewController.itemValLabel = languageStrings[itemValLabel] ?? ""
            }
        }
    }
}

class LocalizableNotificationsScreen {
    static let screenSpecifier = "Notifications_Key_"
    static let title = screenSpecifier + "Title"
    static let emptyScreenMessage = screenSpecifier + "EmptyScreenMessage"
    
    static let chooseAction = screenSpecifier + "ChooseAction"
    static let readAll = screenSpecifier + "ReadAll"
    static let deleteAll = screenSpecifier + "DeleteAll"
    static let deleteConfirmation = screenSpecifier + "DeleteConfirmation"
    static let cancel = screenSpecifier + "Cancel"
    static let updateSuccess = screenSpecifier + "UpdateSuccess"
    static let deleteSuccess = screenSpecifier + "DeleteSuccess"
    static let yes = screenSpecifier + "Yes"
    static let no = screenSpecifier + "No"
    
    
    class func setLanguage(viewController: NotificationsViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableNotificationsScreen.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[title]
                viewController.localizable = languageStrings
            }
        }
    }
}

class LocalizableContactUsViewController {
    static let screenSpecifier = "Contact_Key_"
    static let title = screenSpecifier + "Title"
    static let AVAILABLE_FROM = screenSpecifier + "AvailableFrom" //Available From
    static let TO = screenSpecifier + "To" //to
    static let FOLLOW_US = screenSpecifier + "FollowUs" //Follow Us
    
    class func setLanguage(viewController: ContactUsViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableContactUsViewController.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[title]
                viewController.availableFrom = languageStrings[AVAILABLE_FROM] ?? ""
                viewController.toLable = languageStrings[TO] ?? ""
                viewController.followUsLabel = languageStrings[FOLLOW_US] ?? ""
            }
        }
    }
}

class LocalizableHelpViewController {
    static let screenSpecifier = "Help_Key_"
    static let title = screenSpecifier + "Title"
    
    static let UserGuide = screenSpecifier + "UserGuide"
    static let ContactUs = screenSpecifier + "ContactUs"
    static let FAQ = screenSpecifier + "FAQs"
    static let TermsConditions = screenSpecifier + "TermsConditions"
    static let PrivacyPolicy = screenSpecifier + "PrivacyPolicy"
    
    class func setLanguage(viewController: HelpViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableHelpViewController.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[title]
                viewController.titles = [languageStrings[UserGuide] ?? "User Guide", languageStrings[ContactUs] ?? "Contact Us", languageStrings[FAQ] ?? "FAQs", languageStrings[TermsConditions] ?? "Terms & Conditions", languageStrings[PrivacyPolicy] ?? "Privacy Policy"]
            }
        }
    }
}

// MARK: - Job Flow

class LocalizableAvailableJobsMapScreen {
    static let screenSpecifier = "JobFlow_Key_"
    static let locationPermissionMessage = screenSpecifier + "LocationPermission"
    static let settings = screenSpecifier + "Settings"
    static let expressLabel = screenSpecifier + "Express"
    static let pickupByLabel = screenSpecifier + "PickupByLabel"
    static let pickupLabel = screenSpecifier + "Pickup"
    static let awayLabel = screenSpecifier + "Away"
    
    
    class func setLanguage(viewController: AvailableJobsMapViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableAvailableJobsMapScreen.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.localizable = languageStrings
            }
        }
    }
}

class LocalizableAvailableJobsScreen {
    static let screenSpecifier = "JobFlow_Key_"
    static let emptyScreenMessage = screenSpecifier + "AvailableJobsEmptyScreenMessage"
    static let expressLabel = screenSpecifier + "Express"
    static let pickupByLabel = screenSpecifier + "PickupByLabel"
    static let awayLabel = screenSpecifier + "Away"
    
    class func setLanguage(viewController: AvailableJobsListViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableAvailableJobsScreen.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.emptyScreenMessage = languageStrings[emptyScreenMessage] ?? ""
                viewController.expressLabel = languageStrings[expressLabel] ?? ""
                viewController.pickupByLabel = languageStrings[pickupByLabel] ?? ""
                viewController.awayLabel = languageStrings[awayLabel] ?? ""
            }
        }
    }
}

class LocalizableAvailableJobDetailScreen {
    static let screenSpecifier = "JobFlow_Key_"
    static let title = screenSpecifier + "AvailableJobDetailTitle"
    static let expressLabel = screenSpecifier + "Express"
    static let pickupByLabel = screenSpecifier + "PickupByLabel"
    static let jobPostedByLabel = screenSpecifier + "JobPostedBy"
    static let offerSubmittedLabel = screenSpecifier + "OfferSubmitted"
    static let pickupLabel = screenSpecifier + "Pickup"
    static let dropoffLabel = screenSpecifier + "Dropoff"
    static let quantityLabel = screenSpecifier + "Quantity"
    static let offerToDriveButtonTitle = screenSpecifier + "OfferToDrive"
    static let cancelButtonTitle = screenSpecifier + "Cancel"
    static let itemValLabel = screenSpecifier + "price"
    
    class func setLanguage(viewController: AvailableJobDetailViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableAvailableJobDetailScreen.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[title]
                viewController.expressLabel = languageStrings[expressLabel] ?? ""
                viewController.pickupByLabel = languageStrings[pickupByLabel] ?? ""
                viewController.jobPostedByLabel = languageStrings[jobPostedByLabel] ?? ""
                viewController.offerSubmittedLabel = languageStrings[offerSubmittedLabel] ?? ""
                viewController.pickupLabel = languageStrings[pickupLabel] ?? ""
                viewController.dropoffLabel = languageStrings[dropoffLabel] ?? ""
                viewController.quantityLabel = languageStrings[quantityLabel] ?? ""
                viewController.offerToDriveButtonTitle = languageStrings[offerToDriveButtonTitle] ?? ""
                viewController.cancelButtonTitle = languageStrings[cancelButtonTitle] ?? ""
                viewController.itemValLabel = languageStrings[itemValLabel] ?? ""
            }
        }
    }
}

class LocalizableMyJobsScreen {
    static let screenSpecifier = "JobFlow_Key_"
    static let emptyScreenMessage = screenSpecifier + "MyJobsEmptyScreenMessage"
    static let expressLabel = screenSpecifier + "Express"
    static let pickupByLabel = screenSpecifier + "PickupByLabel"
    static let viewAvailableJobs = screenSpecifier + "ViewAvailableJobs"
    
    class func setLanguage(viewController: MyJobsViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableMyJobsScreen.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.emptyScreenMessage = languageStrings[emptyScreenMessage] ?? ""
                viewController.expressLabel = languageStrings[expressLabel] ?? ""
                viewController.pickupByLabel = languageStrings[pickupByLabel] ?? ""
                viewController.viewAvailableJobs = languageStrings[viewAvailableJobs] ?? ""
            }
        }
    }
}

class LocalizableMyJobDetailScreen {
    static let screenSpecifier = "JobFlow_Key_"
    static let title = screenSpecifier + "MyJobDetailTitle"
    static let expressLabel = screenSpecifier + "Express"
    static let pickupByLabel = screenSpecifier + "PickupByLabel"
    static let yourCustomerLabel = screenSpecifier + "YourCustomer"
    static let messageButtonTitle = screenSpecifier + "Message"
    static let callButtonTitle = screenSpecifier + "Call"
    static let pickupLabel = screenSpecifier + "Pickup"
    static let dropoffLabel = screenSpecifier + "Dropoff"
    static let quantityLabel = screenSpecifier + "Quantity"
    static let emergencyButtonTitle = screenSpecifier + "Emergency"
    static let addPickupCodeButtonTitle = screenSpecifier + "AddPickupCode"
    static let confirmDropoffButtonTitle = screenSpecifier + "ConfirmDropoff"
    static let pickupConfirmedButtonTitle = screenSpecifier + "PickupConfirmed"
    static let dropoffConfirmedButtonTitle = screenSpecifier + "DropoffConfirmed"
    static let startJobButtonTitle = screenSpecifier + "StartJob"
    static let arrivedAtPickupButtonTitle = screenSpecifier + "ArrivedAtPickup"
    static let reachedAtDropOffButtonTitle = screenSpecifier + "ReachedAtDropOff"
    static let readyForNextDropoffButtonTitle = screenSpecifier + "ReadyForNextDropoff"
    static let tapToCompleteButtonTitle = screenSpecifier + "TapToComplete"
    static let cancelButtonTitle = screenSpecifier + "Cancel"
    
    
    static let emergencyDriverLabel = screenSpecifier + "EmergencyDriver"
    static let navigateButtonTitle = screenSpecifier + "Navigate"
    static let emergencyInfoLabel = screenSpecifier + "EmergencyReported"
    static let driverAssignedLabel = screenSpecifier + "DriverAssigned"
    static let arrivedAtEmergencyButton = screenSpecifier + "ArrivedAtEmergency"
    static let confirmEmergencyButton = screenSpecifier + "ConfirmEmergency"
    static let errorRouteUpdate = screenSpecifier + "RouteUpdateError"
    static let adminAssignedJob = screenSpecifier + "AdminAssignedJob"
    
    static let tryLeftLabel = screenSpecifier + "tryLeft"
    static let triesLeftLabel = screenSpecifier + "triesLeft"
    static let locationBlockedMessagePickupLabel = screenSpecifier + "locationBlockedMessagePickup"
    static let locationBlockedMessageDropoffLabel = screenSpecifier + "locationBlockedMessageDropoff"
    static let contactAdminLabel = screenSpecifier + "contactAdmin"
    static let itemValLabel = screenSpecifier + "price"
    
    class func setLanguage(viewController: MyJobDetailViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableMyJobDetailScreen.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[title]
                
                viewController.localizeable.expressLabel = languageStrings[expressLabel] ?? ""
                viewController.localizeable.pickupByLabel = languageStrings[pickupByLabel] ?? ""
                viewController.localizeable.yourCustomerLabel = languageStrings[yourCustomerLabel] ?? ""
                viewController.localizeable.messageButtonTitle = languageStrings[messageButtonTitle] ?? ""
                viewController.localizeable.callButtonTitle = languageStrings[callButtonTitle] ?? ""
                viewController.localizeable.pickupLabel = languageStrings[pickupLabel] ?? ""
                viewController.localizeable.dropoffLabel = languageStrings[dropoffLabel] ?? ""
                viewController.localizeable.quantityLabel = languageStrings[quantityLabel] ?? ""
                viewController.localizeable.emergencyButtonTitle = languageStrings[emergencyButtonTitle] ?? ""
                viewController.localizeable.addPickupCodeButtonTitle = languageStrings[addPickupCodeButtonTitle] ?? ""
                viewController.localizeable.confirmDropoffButtonTitle = languageStrings[confirmDropoffButtonTitle] ?? ""
                viewController.localizeable.pickupConfirmedButtonTitle = languageStrings[pickupConfirmedButtonTitle] ?? ""
                viewController.localizeable.dropoffConfirmedButtonTitle = languageStrings[dropoffConfirmedButtonTitle] ?? ""
                viewController.localizeable.startJobButtonTitle = languageStrings[startJobButtonTitle] ?? ""
                viewController.localizeable.arrivedAtPickupButtonTitle = languageStrings[arrivedAtPickupButtonTitle] ?? ""
                viewController.localizeable.reachedAtDropOffButtonTitle = languageStrings[reachedAtDropOffButtonTitle] ?? ""
                viewController.localizeable.readyForNextDropoffButtonTitle = languageStrings[readyForNextDropoffButtonTitle] ?? ""
                viewController.localizeable.tapToCompleteButtonTitle = languageStrings[tapToCompleteButtonTitle] ?? ""
                viewController.localizeable.cancelButtonTitle = languageStrings[cancelButtonTitle] ?? ""
                
                viewController.localizeable.emergencyDriverLabel = languageStrings[emergencyDriverLabel] ?? ""
                viewController.localizeable.navigateButtonTitle = languageStrings[navigateButtonTitle] ?? ""
                viewController.localizeable.emergencyInfoLabel = languageStrings[emergencyInfoLabel] ?? ""
                viewController.localizeable.driverAssignedLabel = languageStrings[driverAssignedLabel] ?? ""
                viewController.localizeable.arrivedAtEmergencyButton = languageStrings[arrivedAtEmergencyButton] ?? ""
                viewController.localizeable.confirmEmergencyButton = languageStrings[confirmEmergencyButton] ?? ""
                viewController.localizeable.errorRouteUpdate = languageStrings[errorRouteUpdate] ?? ""
                viewController.localizeable.adminAssignedJob = languageStrings[adminAssignedJob] ?? ""
                
                viewController.localizeable.tryLeft = languageStrings[tryLeftLabel] ?? ""
                viewController.localizeable.triesLeft = languageStrings[triesLeftLabel] ?? ""
                viewController.localizeable.locationBlockedMessagePickup = languageStrings[locationBlockedMessagePickupLabel] ?? ""
                
                viewController.localizeable.locationBlockedMessageDropoff = languageStrings[locationBlockedMessageDropoffLabel] ?? ""
                viewController.localizeable.contactAdmin = languageStrings[contactAdminLabel] ?? ""
                viewController.localizeable.itemValLabel = languageStrings[itemValLabel] ?? ""
            }
        }
    }
}

class LocalizableEmergencyBackupDriver {
    static let screenSpecifier = "EmergencyDriver_Key_"
    static let titleLabel = screenSpecifier + "Title"
    static let backupDriverLabel = screenSpecifier + "BackupDriver"
    static let callButtonTitle = screenSpecifier + "Call"
    static let statusOnWay = screenSpecifier + "StatusOnWay"
    static let statusArrived = screenSpecifier + "StatusArrived"
    static let statusTransfered = screenSpecifier + "StatusTransfered"
    
    class func setLanguage(viewController: BackupDriverViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableEmergencyBackupDriver.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[titleLabel]
                viewController.backupDriverLabel.text = languageStrings[backupDriverLabel]
                viewController.callButton.setTitle(languageStrings[callButtonTitle], for: .normal)
                viewController.statusOnWay = languageStrings[statusOnWay] ?? ""
                viewController.statusArrived = languageStrings[statusArrived] ?? ""
                viewController.statusTransfered = languageStrings[statusTransfered] ?? ""
            }
        }
    }
}

class LocalizableCancelJobPopup {
    static let screenSpecifier = "CancelJobPopup_Key_"
    static let titleLabel = screenSpecifier + "Title"
    static let detailLabel = screenSpecifier + "Detail"
    static let yesButton = screenSpecifier + "Yes"
    static let noButton = screenSpecifier + "No"
    
    class func setLanguage(viewController: CancelPopupViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableCancelJobPopup.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.titleLabel.text = languageStrings[titleLabel]
                viewController.detailLabel.text = languageStrings[detailLabel]
                
                viewController.cancelButton.setTitle(languageStrings[noButton], for: .normal)
                viewController.saveButton.setTitle(languageStrings[yesButton], for: .normal)
            }
        }
    }
}

class LocalizableSearchAvailableJobs {
    static let screenSpecifier = "SearchJobs_Key_"
    static let title = screenSpecifier + "Title"
    static let originPlaceholder = screenSpecifier + "OriginPlaceholder"
    static let destinationPlaceholder = screenSpecifier + "DestinationPlaceholder"
    static let searchButtonTitle = screenSpecifier + "SearchButton"
    static let errorEmptyFields = screenSpecifier + "ErrorEmptyFields"
    
    class func setLanguage(viewController: SearchViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableSearchAvailableJobs.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.titleLabel.text = languageStrings[LocalizableSearchAvailableJobs.title]
                viewController.locationTextField.placeholder = languageStrings[LocalizableSearchAvailableJobs.originPlaceholder]
                viewController.destinationLocationTextField.placeholder = languageStrings[LocalizableSearchAvailableJobs.destinationPlaceholder]
                viewController.searchButton.setTitle(languageStrings[LocalizableSearchAvailableJobs.searchButtonTitle], for: .normal)
                viewController.errorEmptyFields = languageStrings[errorEmptyFields] ?? ""
            }
        }
    }
}

class LocalizableSubmittedSuccessfullyPopup {
    static let screenSpecifier = "OfferSubmitted_Key_"
    static let title = screenSpecifier + "Heading"
    static let message = screenSpecifier + "Body"
    static let okButtonTitle = screenSpecifier + "Okay"

    class func setLanguage(viewController: SuccessfullPopupViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableSubmittedSuccessfullyPopup.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.titleLabel.text = languageStrings[LocalizableSubmittedSuccessfullyPopup.title]
                viewController.detailLabel.text = languageStrings[LocalizableSubmittedSuccessfullyPopup.message]
                viewController.continueButton.setTitle(languageStrings[LocalizableSubmittedSuccessfullyPopup.okButtonTitle], for: .normal)
            }
        }
    }
}

class LocalizableSendOfferPopup {
    static let screenSpecifier = "SendOffer_Key_"
    static let titleLabel = screenSpecifier + "TitleLabel"
    static let commentsPlaceholder = screenSpecifier + "CommentsPlaceholder"
    static let submitButtonTitle = screenSpecifier + "submitButton"
    
    class func setLanguage(viewController: SendOfferPopupViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableSendOfferPopup.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.titleLabel.text = languageStrings[LocalizableSendOfferPopup.titleLabel]
                viewController.commentsTextView.placeholder = languageStrings[LocalizableSendOfferPopup.commentsPlaceholder] ?? ""
                viewController.submitButton.setTitle(languageStrings[LocalizableSendOfferPopup.submitButtonTitle], for: .normal)
            }
        }
    }
}

class LocalizableEmergency {
    static let screenSpecifier = "Emergency_Key_"
    static let titleLabel = screenSpecifier + "Title"
    static let message = screenSpecifier + "SubTitle"
    static let reasonPlaceholder = screenSpecifier + "ReasonPlaceholder"
    static let descriptionPlaceholder = screenSpecifier + "DescriptionPlaceholder"
    static let confirmButtonTitle = screenSpecifier + "ConfirmButton"
    
    static let errorEmptyReason = screenSpecifier + "ErrorEmptyReason"
    static let errorEmptyDescription = screenSpecifier + "ErrorEmptyDescription"
    static let errorEmptyPhoto = screenSpecifier + "ErrorEmptyPhoto"
    static let errorUploadPhoto = screenSpecifier + "ErrorUploadPhoto"
    
    class func setLanguage(viewController: EmergencyConfirmationViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableEmergency.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[LocalizableEmergency.titleLabel]
                viewController.detailLabel.text = languageStrings[LocalizableEmergency.message]
                viewController.emergencyReasonTextField.placeholder = languageStrings[LocalizableEmergency.reasonPlaceholder]
                viewController.descriptionTextView.placeholder = languageStrings[LocalizableEmergency.descriptionPlaceholder] ?? ""
                viewController.confirmButton.setTitle(languageStrings[LocalizableEmergency.confirmButtonTitle], for: .normal)
                
                viewController.errorEmptyReason = languageStrings[LocalizableEmergency.errorEmptyReason] ?? ""
                viewController.errorEmptyDescription = languageStrings[LocalizableEmergency.errorEmptyDescription] ?? ""
                viewController.errorEmptyPhoto = languageStrings[LocalizableEmergency.errorEmptyPhoto] ?? ""
                viewController.errorUploadPhoto = languageStrings[errorUploadPhoto] ?? ""
            }
        }
    }
}

class LocalizableCancellationReason {
    static let screenSpecifier = "Cancellation_Key_"
    static let titleLabel = screenSpecifier + "Title"
    static let message = screenSpecifier + "SubTitle"
    static let otherReasonPlaceholder = screenSpecifier + "OtherReasonPlaceholder"
    static let submitButtonTitle = screenSpecifier + "SubmitButton"
    
    static let errorEnterReason = screenSpecifier + "ErrorEnterReason"
    static let errorSelectReason = screenSpecifier + "ErrorSelectReason"
    static let otherLabel = screenSpecifier + "Other"
    
    class func setLanguage(viewController: CancellationReasonsViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableCancellationReason.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.title = languageStrings[LocalizableCancellationReason.titleLabel]
                viewController.detailLabel.text = languageStrings[LocalizableCancellationReason.message]
                viewController.otherTextView.placeholder = languageStrings[LocalizableCancellationReason.otherReasonPlaceholder] ?? ""
                viewController.submitButton.setTitle(languageStrings[LocalizableCancellationReason.submitButtonTitle], for: .normal)
                viewController.errorEnterReason = languageStrings[errorEnterReason] ?? ""
                viewController.errorSelectReason = languageStrings[errorSelectReason] ?? ""
                viewController.otherLabel = languageStrings[otherLabel] ?? ""
            }
        }
    }
}

class LocalizableJobCompleted {
    static let screenSpecifier = "JobCompleted_Key_"
    static let titleLabel = screenSpecifier + "Title"
    static let message = screenSpecifier + "SubTitle"
    static let earning = screenSpecifier + "Earning"
    static let submitButtonTitle = screenSpecifier + "SubmitButton"
    
    
    class func setLanguage(viewController: JobCompletedPopupViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableJobCompleted.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.titleLabel.text = languageStrings[LocalizableJobCompleted.titleLabel]
                viewController.messageLabel.text = languageStrings[LocalizableJobCompleted.message]
                viewController.earningTitleLabel.text = languageStrings[LocalizableJobCompleted.earning]
                viewController.submitButton.setTitle(languageStrings[LocalizableJobCompleted.submitButtonTitle], for: .normal)
            }
        }
    }
}

class LocalizablePickupPopup {
    static let screenSpecifier = "PickupCodePopup_Key_"
    static let titleLabel = screenSpecifier + "Title"
    static let message = screenSpecifier + "SubTitle"
    static let codePlaceholder = screenSpecifier + "AddCodePlaceholder"
    static let confirmButtonTitle = screenSpecifier + "ConfirmButton"
    static let errorEmptyCode = screenSpecifier + "ErrorEmptyCode"
    
    
    class func setLanguage(viewController: ConfirmDropoffPopupViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizablePickupPopup.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.titleLabel.text = languageStrings[LocalizablePickupPopup.titleLabel]
                viewController.detailLabel.text = languageStrings[LocalizablePickupPopup.message]
                viewController.addCodeTextField.placeholder = languageStrings[LocalizablePickupPopup.codePlaceholder]
                viewController.confirmButton.setTitle(languageStrings[LocalizablePickupPopup.confirmButtonTitle], for: .normal)
                viewController.errorEmptyCode = languageStrings[errorEmptyCode] ?? ""
            }
        }
    }
}

class LocalizableDropoffPopup {
    static let screenSpecifier = "DropoffCodePopup_Key_"
    static let titleLabel = screenSpecifier + "Title"
    static let message = screenSpecifier + "SubTitle"
    static let codePlaceholder = screenSpecifier + "AddCodePlaceholder"
    static let confirmButtonTitle = screenSpecifier + "ConfirmButton"
    
    static let errorEmptyPhoto = screenSpecifier + "ErrorEmptyPhoto"
    static let errorUploadPhoto = screenSpecifier + "ErrorUploadPhoto"
    static let errorEmptyCode = screenSpecifier + "ErrorEmptyCode"
    
    
    class func setLanguage(viewController: ConfirmDropoffPopupViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableDropoffPopup.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.titleLabel.text = languageStrings[LocalizableDropoffPopup.titleLabel]
                viewController.detailLabel.text = languageStrings[LocalizableDropoffPopup.message]
                viewController.addCodeTextField.placeholder = languageStrings[LocalizableDropoffPopup.codePlaceholder]
                viewController.confirmButton.setTitle(languageStrings[LocalizableDropoffPopup.confirmButtonTitle], for: .normal)
                viewController.errorEmptyCode = languageStrings[errorEmptyCode] ?? ""
                viewController.errorUploadPhoto = languageStrings[errorUploadPhoto] ?? ""
                viewController.errorEmptyPhoto = languageStrings[errorEmptyPhoto] ?? ""
            }
        }
    }
}

class LocalizableChatScreen {
    static let screenSpecifier = "Chat_Key_"
    static let textViewPlaceholder = screenSpecifier + "TextViewPlaceholder"
    static let message = screenSpecifier + "EmptyScreenMessage"
    
    class func setLanguage(viewController: CustomChatViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableChatScreen.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.inputTextView.placeholder = languageStrings[textViewPlaceholder] ?? ""
                viewController.emptyScreenMessage = languageStrings[message] ?? ""
            }
        }
    }
}

class LocalizableAppVersionPopup {
    static let screenSpecifier = "Main_Key_"
    //new key for force update
    static let FORCE_MESSAGE = screenSpecifier + "ForceMessage" // Hey! Great News. We have Successfully Upgraded. In order to continue enjoying our services, you are requested to Download the most recent Updates.
    static let FORCE_UPDATE = screenSpecifier + "ForceUpdate" // Download Updates
    
    class func setLanguage(viewController: AvailableJobsMapViewController) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableAppVersionPopup.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.localizableAppVersion = languageStrings
            }
        }
    }
}

class LocalizableViewAddressPopup {
    static let screenSpecifier = "ShowAddress_Key_"
    static let pickupTitle = screenSpecifier + "PickupTitle"
    static let dropOffTitle = screenSpecifier + "DropOffTitle"
    static let okButtonTitle = screenSpecifier + "Okay"
    
    class func setLanguage(viewController: ViewAddressViewControllerPopup) {
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: LocalizableViewAddressPopup.screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                viewController.okButton.setTitle(languageStrings[okButtonTitle], for: .normal)
                viewController.localizable = languageStrings
            }
        }
    }
}
