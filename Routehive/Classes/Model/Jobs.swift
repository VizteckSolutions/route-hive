//
//  Jobs.swift
//  Routehive
//
//  Created by Mac on 19/10/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper

typealias PackageDetailsCompletionHandler = (_ result: PackageDetails, _ error: NSError?) -> Void
typealias UnRatedPackageCompletionHandler = (_ result: UnRatedPackage, _ error: NSError?) -> Void

class PackageDetails: Mappable {

    var jobs = [Package]()
    var package = Mapper<Package>().map(JSONObject: [:])!
    var myPackages = [Package]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        jobs                    <- map["packagesDetails"] // Available Jobs Listing
        package                 <- map["packageDetails"] // Available Jobs Details and My job details
        myPackages              <- map["packagesDetails"] // My Jobs Listing
    }
    
    func fetchAvailableJobs(viewController: UIViewController, lat: Double, lng: Double, destLat: Double, destLong: Double, offset: Int, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        var countryLat = lat
        var countryLng = lng
        
        if lat == 0.0 {
            countryLat = destLat
            countryLng = destLong
        }
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: countryLat, longitude: countryLng), completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                Utility.hideLoading(viewController: viewController)
                return
                
            } else if let country = placemarks?.first?.country {
                print("current Country: \(country)")
                
                APIClient.shared.fetchAvailableJobs(withLat: lat, lng: lng, destLat: destLat, destLong: destLong, offset: offset, currentCountry: country) { (result, error) in
                    Utility.hideLoading(viewController: viewController)
                    
                    if error != nil {
                        error?.showErrorBelowNavigation(viewController: viewController)
                        completionBlock(self, error)
                        
                    } else {
                        
                        if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                            completionBlock(data, nil)
                        }
                    }
                }
                
            } else {
                Utility.hideLoading(viewController: viewController)
            }
        })
    }
    
    // Available Jobs details
    
    func fetchPackageDetails(viewController: UIViewController, packageId: Int, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.fetchPackageDetails(withPackageId: packageId) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func sendOffer(viewController: UIViewController, packageId: Int, proposal: String, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.sendOffer(withPackageId: packageId, proposal: proposal) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func cancelOffer(packageId: Int, viewController: UIViewController, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.CancelOffer(WithPackageId: packageId) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    // My Job Listing
    
    func fetchMyJobsListing(viewController: UIViewController, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.fetchPackagesListing { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    // My Job Flow
    
    func startJob(packageId: Int, viewController: UIViewController, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.startJob(WithPackageId: packageId) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func arrivedAt(WithType type: PickupDropoffType, packageId: Int, viewController: UIViewController, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.arrivedAt(WithType: type, packageId: packageId) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func confirm(WithType type: ConfirmType, packageId: Int, code: String, dropoffImage: String, viewController: UIViewController, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.confirm(WithType: type, packageId: packageId, code: code, dropoffImage: dropoffImage) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func readyForNextDroppff(packageId: Int, viewController: UIViewController, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.readyForNextDroppff(WithPackageId: packageId) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func completeJob(packageId: Int, viewController: UIViewController, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.completeJob(WithPackageId: packageId) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func rateUser(packageId: Int, rating: Int, viewController: UIViewController, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.rateUser(WithPackageId: packageId, rating: rating) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func cancelJob(packageId: Int, reasonId: Int, reason: String, isOther: Bool, viewController: UIViewController, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.CancelJob(WithPackageId: packageId, reasonId: reasonId, reason: reason, isOther: isOther) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    // MARK: - Emergency Flow
    
    func arrivedAtEmergencyLocation(packageId: Int, viewController: UIViewController, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.ArrivedAtEmergencyLocation(WithPackageId: packageId) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func confirmEmergencyLocation(packageId: Int, viewController: UIViewController, completionBlock: @escaping PackageDetailsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.ConfirmEmergencyLocation(WithPackageId: packageId) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<PackageDetails>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}

class Package: Mappable {
    
    var id: Int = 0 // For Job Details and My Job Listing
    var packageId: Int = 0 // For Available Job Listing
    var status: Int = 0
    var userId: Int = 0
    var userType: Int = 0
    var distance: Int = 0
    var deliveryCost: Double = 0.0
    var deliveryDistance = 0
    var deliveryType = 0
    var scheduledTime: Double = 0
    var pickupAddress = ""
    var dropoffAddress = ""
    var packageItemsString = ""
    var currency = ""
    var packageImage = ""
    var packageItems = [String]()
    var packageLocations = [PackageLocation]()
    var isOfferSent = false
    var offerProposal = ""
    var offerTimePassed = ""
    var estimatedTime = 0
    var estimatedDistance: Double = 0
    var distanceUnit = ""
    var messageCount = 0
    var userData = Mapper<UserData>().map(JSONObject: [:])! // User data
    var backupSPData = Mapper<UserData>().map(JSONObject: [:])! // backup driver data
    var spData = Mapper<UserData>().map(JSONObject: [:])! // Emergency reporter driver data
    var isEmergencyReported = false
    var isBackupSPAssigned = false
    var backupSPArrivedAtEmergency = false
    var emergencyPickupConfirmed = false
    var isSameSP = false
    var spEarnings: Double = 0.0
    
    var emergencyLat: Double = 0.0
    var emergencyLong: Double = 0.0
    var emergencyPrimaryAddress = ""
    
    var isRatingReminderSentToSP = false
    var isRatedBySP = false
    var contactMobileNumber = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                          <- map["id"]
        packageId                   <- map["packageId"]
        status                      <- map["status"]
        userId                      <- map["userId"]
        userType                    <- map["userType"]
        distance                    <- map["distance"]
        deliveryCost                <- map["deliveryCost"]
        deliveryDistance            <- map["deliveryDistance"]
        scheduledTime               <- map["scheduledTime"]
        pickupAddress               <- map["pickupAddress"]
        dropoffAddress              <- map["dropoffAddress"]
        currency                    <- map["currency"]
        packageImage                <- map["packageImage"]
        packageItems                <- map["packageItems"]
        packageLocations            <- map["packageLocations"]
        isOfferSent                 <- map["isOfferSent"]
        offerProposal               <- map["offerProposal"]
        offerTimePassed             <- map["offerTimePassed"]
        estimatedTime               <- map["estimatedTime"]
        estimatedDistance           <- map["estimatedDistance"]
        distanceUnit                <- map["distanceUnit"]
        userData                    <- map["userData"]
        backupSPData                <- map["backupSPData"]
        spData                      <- map["spData"]
        deliveryType                <- map["deliveryType"]
        messageCount                <- map["messageCount"]
        isEmergencyReported         <- map["isEmergencyReported"]
        isBackupSPAssigned          <- map["isBackupSPAssigned"]
        isSameSP                    <- map["isSameSP"]
        backupSPArrivedAtEmergency  <- map["backupSPArrivedAtEmergency"]
        emergencyPickupConfirmed    <- map["emergencyPickupConfirmed"]
        spEarnings                  <- map["spEarnings"]
        emergencyLat                <- map["emergencyLocationData.latitude"]
        emergencyLong               <- map["emergencyLocationData.longitude"]
        emergencyPrimaryAddress     <- map["emergencyLocationData.primaryAddress"]
        isRatingReminderSentToSP    <- map["isRatingReminderSentToSP"]
        isRatedBySP                 <- map["isRatedBySP"]
        contactMobileNumber         <- map["contactMobileNumber"]
        
        postMapping()
    }
    
    func postMapping() {
        
        if packageItems.count > 0 {
            packageItemsString = packageItems.joined(separator: ", ")
        }
    }
}

class PackageLocation: Mappable {
    
    var id: Int = 0
    var status: Int = 0
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var sequenceNumber: Int = 0
    var locationType: Int = 0
    var packageId: Int = 0
    var primaryAddress = ""
    var addressLineOne = ""
    var addressLineTwo = ""
    var personAtLocation: Int = 0
    var pickDropTime: Double = 0
    var name = ""
    var phoneNumber = ""
    var dropoffNumber: Int = 0
    var isLocationBlocked = false
    var codeVerificationTriesLeft: Int = 0
    var items = [Items]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                          <- map["id"]
        status                      <- map["status"]
        latitude                    <- map["latitude"]
        longitude                   <- map["longitude"]
        sequenceNumber              <- map["sequenceNumber"]
        locationType                <- map["locationType"]
        packageId                   <- map["packageId"]
        primaryAddress              <- map["primaryAddress"]
        addressLineOne              <- map["addressLine1"]
        addressLineTwo              <- map["addressLine2"]
        name                        <- map["name"]
        phoneNumber                 <- map["phoneNumber"]
        personAtLocation            <- map["personAtLocation"]
        pickDropTime                <- map["pickDropTime"]
        dropoffNumber               <- map["dropoffNumber"]
        isLocationBlocked           <- map["isLocationBlocked"]
        codeVerificationTriesLeft   <- map["codeVerificationTriesLeft"]
        items                       <- map["items"]
    }
}

class Items: Mappable {
    
    var id: Int = 0
    var name = ""
    var quantity: Int = 0
    var packageSizeId: Int = 0
    var packageLocationId: Int = 0
    var packageId: Int = 0
    var image = ""
    var packageSize = ""
    var estimatedPrice = 0.0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                      <- map["id"]
        name                    <- map["name"]
        quantity                <- map["quantity"]
        packageSizeId           <- map["packageSizeId"]
        packageLocationId       <- map["packageLocationId"]
        packageId               <- map["packageId"]
        image                   <- map["image"]
        packageSize             <- map["packageSize"]
        estimatedPrice          <- map["estimatedPrice"]
    }
}

class UserData: Mappable {
    
    var firstName = ""
    var lastName = ""
    var name = ""
    var userName = ""
    var code = ""
    var number = ""
    var phoneNumber = ""
    var profileImage = ""
    var avgRating: Double = 0.0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        firstName               <- map["firstName"]
        lastName                <- map["lastName"]
        name                    <- map["name"]
        userName                <- map["userName"] // for unrated package
        profileImage            <- map["profileImage"]
        avgRating               <- map["avgRating"]
        code                    <- map["phoneNumberPrefix"]
        number                  <- map["phoneNumber"]
        
        postMapping()
    }
    
    func postMapping() {
        phoneNumber = code+number
    }
}

class UnRatedPackage: Mappable {
    
    var isUnratedPackageExist = false
    var packageId: Int = 0
    var currency = ""
    var spEarnings: Double = 0
    var userData = Mapper<UserData>().map(JSON: [:])!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        isUnratedPackageExist   <- map["isUnratedPackageExist"]
        packageId               <- map["packageId"]
        currency                <- map["currency"]
        spEarnings              <- map["spEarnings"]
        userData                <- map["userData"]
    }
    
    func fetchUnRatedJob(viewController: UIViewController, completionBlock: @escaping UnRatedPackageCompletionHandler) {
        
        APIClient.shared.getUnratedJob() { (result, error) in
            
            if error != nil {
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<UnRatedPackage>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}


class AppVersion: Mappable {
    
    var version = 0
    var androidRiderAppUrl = ""
    var iosRiderAppUrl = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        version                     <- map["version"]
        androidRiderAppUrl          <- map["url.androidRiderAppUrl"]
        iosRiderAppUrl              <- map["url.iosRiderAppUrl"]
    }
}
