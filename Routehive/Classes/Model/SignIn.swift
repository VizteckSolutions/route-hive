//
//  SignIn.swift
//  Routehive
//
//  Created by Zeshan on 01/10/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import Foundation
import ObjectMapper

typealias SignInCompletionHandler = (_ result: SignIn, _ error: NSError?) -> Void
typealias ImageCompletionHandler = ( _ success: Bool, _ url: String) -> Void
typealias VehiclesCompletionHandler = (_ result: Vehicles, _ error: NSError?) -> Void
typealias BanksCompletionHandler = (_ result: Banks, _ error: NSError?) -> Void

class SignIn: Mappable {
    
    var token = ""
    var isEmailVerified = false
    var signUpStepCompleted = 0
    var isSignupCompleted = false
    var spData = Mapper<Account>().map(JSON: [:])!
    var code = ""
    var imageUrl = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        token                          <- map["token"]
        isEmailVerified                <- map["isEmailVerified"]
        signUpStepCompleted            <- map["signUpStepCompleted"]
        isSignupCompleted              <- map["isSignupCompleted"]
        spData                         <- map["account"]
        code                           <- map["code"]
        imageUrl                       <- map["data.url"]
    }
    
    // MARK: - Sign In
    
    func signIn(viewController: UIViewController, email: String, passsword: String, completionBlock: @escaping SignInCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.signIn(withEmail: email, password: passsword) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<SignIn>().map(JSONObject: result) {
                    Utility.saveDriverDataInDefaults(data: data.spData)
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    // MARK: - Sign Up
    
    func signUp(viewController: UIViewController, email: String, country: String, completionBlock: @escaping SignInCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.signUp(withEmail: email, country: country) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<SignIn>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func isEmailVerified(viewController: UIViewController, token: String, completionBlock: @escaping SignInCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.isEmailVerified(withToken: token) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<SignIn>().map(JSONObject: result) {
                    
                    if data.isEmailVerified {
                        Utility.saveDriverDataInDefaults(data: data.spData)
                        completionBlock(data, nil)
                        
                    } else {
                        NSError.showErrorWithMessage(message: "Email is not verified yet.", viewController: viewController)
                    }
                }
            }
        }
    }
    
    func updatePersonelInfo(viewController: UIViewController, personalInfo: SignUpData, pickedImage: UIImage, completionBlock: @escaping SignInCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        uploadImage(viewController: viewController, type: .profileImage, pickedImage: pickedImage) { (success, imageUrl) in
            
            if success {
                personalInfo.profileImage = imageUrl
                
                APIClient.shared.updatePersonalInfo(personalInfo: personalInfo){ (result, error) in
                    Utility.hideLoading(viewController: viewController)
                    
                    if error != nil {
                        error?.showErrorBelowNavigation(viewController: viewController)
                        completionBlock(self, error)
                        
                    } else {
                        
                        if let data = Mapper<SignIn>().map(JSONObject: result) {
                            completionBlock(data, nil)
                        }
                    }
                }
                
            } else {
                Utility.hideLoading(viewController: viewController)
                NSError.showErrorWithMessage(message: "Error while uploading image.", viewController: viewController)
            }
        }
    }
    
    func verifyPhoneNumber(viewController: UIViewController, verificationCode: String, completionBlock: @escaping SignInCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.VerifyPhoneNumber(withVerificationCode: verificationCode) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<SignIn>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func resendVerificationCode(viewController: UIViewController, completionBlock: @escaping SignInCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.resendVerificationCode { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<SignIn>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func updateVehicleInfo(viewController: UIViewController, vehicleInfo: VehicleInfoData, completionBlock: @escaping SignInCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.updateVehicleInfo(vehicleInfo: vehicleInfo) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<SignIn>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func uploadMyKad(viewController: UIViewController, myKadUrls: MyKadUrls, completionBlock: @escaping SignInCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.uploadMyKadInfo(myKadUrls: myKadUrls, { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                completionBlock(self, error)
            }
        })
    }
    
    func updateDrivingLicenseInfo(viewController: UIViewController, pickedImage: UIImage, drivingLicenseExpiryDate: Double, completionBlock: @escaping SignInCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        uploadImage(viewController: viewController, type: .identityDocumentsImages, pickedImage: pickedImage) { (success, imageUrl) in
            
            if success {
                APIClient.shared.updateDrivingLicenseInfo(drivingLicenseUrl: imageUrl, drivingLicenseExpiryDate: drivingLicenseExpiryDate,  { (result, error) in
                    Utility.hideLoading(viewController: viewController)
                    
                    if error != nil {
                        error?.showErrorBelowNavigation(viewController: viewController)
                        completionBlock(self, error)
                        
                    } else {
                        completionBlock(self, error)
                    }
                })
                
            } else {
                Utility.hideLoading(viewController: viewController)
                NSError.showErrorWithMessage(message: "Error while uploading image.", viewController: viewController)
            }
        }
    }
    
    func uploadImage(viewController: UIViewController, type: UploadImageType, pickedImage: UIImage, completionBlock: @escaping ImageCompletionHandler) {
        
        APIClient.shared.uploadImage(image: pickedImage, type: type) { (success, imageUrl) in

            
            if success {
                completionBlock(true,imageUrl)
                
            } else {
                completionBlock(false,imageUrl)
            }
        }
    }
    
    // MARK: - Profile
    
    func fetchProfile(viewController: UIViewController, completionBlock: @escaping SignInCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.fetchProfile { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)

            } else {

                if let data = Mapper<SignIn>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func updateProfile(viewController: UIViewController, firstName: String, lastName: String, pickedImage: UIImage, phoneCode: String, phoneNumber: String, completionBlock: @escaping SignInCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        uploadImage(viewController: viewController, type: .profileImage, pickedImage: pickedImage) { (success, imageUrl) in
            
            if success {
                
                APIClient.shared.updateProfile(withFirstName: firstName, lastName: lastName, profileImage: imageUrl, phoneCode: phoneCode, phoneNumber: phoneNumber) { (result, error) in
                    Utility.hideLoading(viewController: viewController)
                    
                    if error != nil {
                        error?.showErrorBelowNavigation(viewController: viewController)
                        completionBlock(self, error)
                        
                    } else {
                        
                        if let data = Mapper<SignIn>().map(JSONObject: result) {
                            completionBlock(data, nil)
                        }
                    }
                }
                
            } else {
                Utility.hideLoading(viewController: viewController)
                NSError.showErrorWithMessage(message: "Error while uploading image.", viewController: viewController)
            }
        }
    }
    
    func changePassword(viewController: UIViewController, currentPassword: String, password: String, completionBlock: @escaping SignInCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.changePassword(withCurrentPassword: currentPassword, password: password) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<SignIn>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func doLogout(viewController: UIViewController, completionBlock: @escaping SignInCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.doLogout { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<SignIn>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}

class Account: Mappable {
    
    var id: Int = 0
    var firstName = ""
    var lastName = ""
    var name = ""
    var profileImage = ""
    var userType = ""
    var isBlocked = false
    var email = ""
    var isEmailUpdate = false
    var phoneCode = ""
    var phoneNumber = ""
    var resetPhoneNumberCode = ""
    var resetPhoneNumber = ""
    var avgRating = 0.0
    var jobsDoneCount = 0
    var referralCode = ""
    var vehicleName = ""
    var vehiclePlateNumber = ""
    var country = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                          <- map["spId"]
        firstName                   <- map["firstName"]
        lastName                    <- map["lastName"]
        name                        <- map["name"]
        profileImage                <- map["profileImage"]
        userType                    <- map["userType"]
        isBlocked                   <- map["isBlocked"]
        email                       <- map["email"]
        isEmailUpdate               <- map["isEmailUpdate"]
        phoneCode                   <- map["phoneNumberPrefix"]
        phoneNumber                 <- map["phoneNumber"]
        resetPhoneNumberCode        <- map["resetPhoneNumberPrefix"]
        resetPhoneNumber            <- map["resetPhoneNumber"]
        avgRating                   <- map["avgRating"]
        jobsDoneCount               <- map["jobsDoneCount"]
        referralCode                <- map["referralCode"]
        vehicleName                 <- map["vehicleName"]
        vehiclePlateNumber          <- map["vehiclePlateNumber"]
        country                     <- map["country"]
    }
}

class Banks: Mappable {
    
    var bank = [Vehicle]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        bank                <- map["banks"]
    }
    
    func fetchBanks(viewController: UIViewController, completionBlock: @escaping BanksCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.fetchBankList { (result, error) in
            Utility.hideLoading(viewController: viewController)

            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)

            } else {

                if let data = Mapper<Banks>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func updateBankInfo(viewController: UIViewController, bankId: Int, accountHolderName: String, accountNumber: String, completionBlock: @escaping BanksCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.updateBankInfo(bankId: bankId, accountHolderName: accountHolderName, accountNumber: accountNumber) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<Banks>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}

class Vehicles: Mappable {
    
    var vehicleTypes = [Vehicle]()
    var vehicleManufacturers = [Vehicle]()
    var ownerShip = [Vehicle]()
    var vehicleModels = [VehicleModels]()

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        ownerShip                   <- map["vehicleOwnershipTypes"]
        vehicleTypes                <- map["vehicleTypes"]
        vehicleManufacturers        <- map["vehicleManufacturers"]
        vehicleModels               <- map["vehicleModels"]
    }
    
    func fetchVehiclesData(viewController: UIViewController, completionBlock: @escaping VehiclesCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.fetchVehicleData { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<Vehicles>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}

class Vehicle: Mappable {
    
    var id = 0
    var name = ""
    var type = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                          <- map["id"]
        name                        <- map["name"]
        type                        <- map["type"]
    }
}

class VehicleModels: Mappable {
    
    var id = 0
    var name = ""
    var vehicleManufacturerId = 0
    var vehicleTypeId = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                          <- map["id"]
        name                        <- map["name"]
        vehicleManufacturerId       <- map["vehicleManufacturerId"]
        vehicleTypeId               <- map["vehicleTypeId"]
    }
}
