//
//  ContactUsInfo.swift
//  Routehive
//
//  Created by Mac on 02/11/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

typealias ContactUsInfoCompletionHandler = (_ result: ContactUsInfo, _ error: NSError?) -> Void
typealias EmergencyCompletionHandler = (_ result: Emergency, _ error: NSError?) -> Void


class ContactUsInfo: Mappable {
    
    var id: Int = 0
    var contactPhoneNumber = ""
    var contactMobileNumber = ""
    var contactEmail = ""
    var contactWebsite = ""
    var facebookLink = ""
    var instaBookLink = ""
    var twitterLink = ""
    var availabilityStartHours = 0
    var availabilityStartMinutes = 0
    var availabilityEndHours = 0
    var availabilityEndMinutes = 0
    var startTime = ""
    var endTime = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                          <- map["contactInfo.id"]
        contactPhoneNumber          <- map["contactInfo.contactPhoneNumber"]
        contactMobileNumber         <- map["contactInfo.contactMobileNumber"]
        contactEmail                <- map["contactInfo.contactEmail"]
        contactWebsite              <- map["contactInfo.contactWebsite"]
        facebookLink                <- map["contactInfo.facebookLink"]
        instaBookLink               <- map["contactInfo.instaBookLink"]
        twitterLink                 <- map["contactInfo.twitterLink"]
        availabilityStartHours      <- map["contactInfo.availabilityStartHours"]
        availabilityStartMinutes    <- map["contactInfo.availabilityStartMinutes"]
        availabilityEndHours        <- map["contactInfo.availabilityEndHours"]
        availabilityEndMinutes      <- map["contactInfo.availabilityEndMinutes"]
        startTime                   <- map["contactInfo.startTime"]
        endTime                     <- map["contactInfo.endTime"]
    }
    
    func getContactUsDetails(viewController: UIViewController, country: String, completionBlock: @escaping ContactUsInfoCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.getContactUsDetails(withCountry: country) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<ContactUsInfo>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}

class Emergency: Mappable {
    
    var reason = [EmergencyReason]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        reason          <- map["emergencyReasons"]
    }
    
    func getEmergencyReasons(viewController: UIViewController, completionBlock: @escaping EmergencyCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.getEmergencyReasons { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<Emergency>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func reportEmergency(viewController: UIViewController, packageId: Int, emergencyReasonId: Int, description: String, image: String, location: CLLocation, address: String, completionBlock: @escaping EmergencyCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.reportEmergency(WithPackageId: packageId, emergencyReasonId: emergencyReasonId, description: description, image: image, location: location, address: address) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<Emergency>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}

class EmergencyReason: Mappable {
    
    var id = 0
    var text = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                          <- map["id"]
        text                        <- map["text"]
    }
}
