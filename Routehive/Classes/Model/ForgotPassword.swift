//
//  ForgotPassword.swift
//  Routehive
//
//  Created by Huzaifa on 10/1/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import Foundation
import ObjectMapper

typealias ForgotPasswordCompletionHandler = (_ result: ForgotPassword, _ error: NSError?) -> Void

class ForgotPassword: Mappable {
    
    var verificatioCode = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        verificatioCode                <- map["code"]
    }
    
    func forgotPassword(viewController: UIViewController, phoneCode: String, phoneNumber: String, completionBlock: @escaping ForgotPasswordCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.forgotPassword(withPhoneCode: phoneCode, phoneNumber: phoneNumber) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<ForgotPassword>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func verifyResetPassword(viewController: UIViewController, phoneCode: String, phoneNumber: String, verificationCode: String, completionBlock: @escaping ForgotPasswordCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.verifyResetPassword(withPhoneCode: phoneCode, phoneNumber: phoneNumber, verificationCode: verificationCode) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<ForgotPassword>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func resetPassword(viewController: UIViewController, password: String, phoneCode: String, phoneNumber: String, verificationCode: String, completionBlock: @escaping ForgotPasswordCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.resetPassword(withPassword: password, phoneCode: phoneCode, phoneNumber: phoneNumber, verificationCode: verificationCode) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<ForgotPassword>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}
