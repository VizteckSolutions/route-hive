//
//  APIClient.swift
//  Vizteck
//
//  Created by Umair Afzal on 19/06/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import ObjectMapper

class Connectivity {

    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

let APIClientDefaultTimeOut = 40.0
let APIClientBaseURL = kBaseUrl

class APIClient: APIClientHandler {

    fileprivate var clientDateFormatter: DateFormatter
    var isConnectedToNetwork: Bool?

    static var shared: APIClient = {
        let baseURL = URL(string: APIClientBaseURL + Driver.shared.languageCode)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIClientDefaultTimeOut
       
        let instance = APIClient(baseURL: baseURL!, configuration: configuration)

        return instance
    }()

    // MARK: - init methods

    override init(baseURL: URL, configuration: URLSessionConfiguration, delegate: SessionDelegate = SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager? = nil) {
        clientDateFormatter = DateFormatter()

        super.init(baseURL: baseURL, configuration: configuration, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager)

        //        clientDateFormatter.timeZone = NSTimeZone(name: "UTC")
        clientDateFormatter.dateFormat = "yyyy-MM-dd" // Change it to desired date format to be used in All Apis
    }

    func resetApiClient() {
        let baseURL = URL(string: kBaseUrl + Driver.shared.languageCode)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIClientDefaultTimeOut
        APIClient.shared = APIClient(baseURL: baseURL!, configuration: configuration)
    }

    // MARK: Helper methods

    func apiClientDateFormatter() -> DateFormatter {
        return clientDateFormatter.copy() as! DateFormatter
    }

    fileprivate func normalizeString(_ value: AnyObject?) -> String {
        return value == nil ? "" : value as! String
    }

    fileprivate func normalizeDate(_ date: Date?) -> String {
        return date == nil ? "" : clientDateFormatter.string(from: date!)
    }

    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }

    // MARK: - SignIn / SignUp

    @discardableResult
    func getCountryCode(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "fetch/country/codes?offset=0&limit=10"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }

    @discardableResult
    func signUp(withEmail email: String, country: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "signup"
        let params = ["email": email, "country": country, "userType": "sp", "deviceToken": Driver.shared.deviceToken, "deviceType": "ios"] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func isEmailVerified(withToken token: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "is-email-verified"
        let params = ["token": token, "userType": "sp", "deviceToken": Driver.shared.deviceToken, "deviceType": "ios"] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func updatePersonalInfo(personalInfo: SignUpData, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/update/personal/info"
        let params = ["firstName": personalInfo.firstName, "lastName": personalInfo.lastName, "phoneCode": personalInfo.phoneCode, "phoneNumber": personalInfo.phoneNumber, "password": personalInfo.password, "profileImage": personalInfo.profileImage, "acceptedTerms": personalInfo.acceptedTerms, "referralCode": personalInfo.referralCode] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .put, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func fetchVehicleData(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/fetch/signup/vehicles/data"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func updateVehicleInfo(vehicleInfo: VehicleInfoData, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/update/vehicle/info"
        
        let params = ["vehicleOwnershipTypeId": vehicleInfo.vehicleOwnershipType, "vehicleTypeId": vehicleInfo.vehicleTypeId, "vehicleManufacturerId": vehicleInfo.vehicleManufacturerId, "vehicleModelId": vehicleInfo.vehicleModelId, "vehiclePlateNumber": vehicleInfo.vehiclePlateNumber, "vehicleColor": vehicleInfo.vehicleColor, "companyName": vehicleInfo.companyName, "companyRegistrationNumber": vehicleInfo.companyRegistrationNumber, "vehicleRegistrationCardUrl": vehicleInfo.registrationUrl, "vehicleInsuranceCoverUrl": vehicleInfo.insuranceUrl, "vehicleInspectionCoverUrl": vehicleInfo.inspectionUrl, "vehicleInsuranceExpiry": vehicleInfo.insuranceExpiryDate, "vehicleInspectionExpiryDate": vehicleInfo.inspectionExpiryDate, "type": vehicleInfo.isBackupDriver] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func VerifyPhoneNumber(withVerificationCode verificationCode: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/verify/phone"
        let params = ["verificationCode": verificationCode] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func resendVerificationCode(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/resend/phone/verification/code"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func signIn(withEmail email: String, password: String,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "login"
        let params = ["email": email, "password": password, "userType": "sp", "deviceToken": Driver.shared.deviceToken, "deviceType": "ios"] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func forgotPassword(withPhoneCode phoneCode: String, phoneNumber: String,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "send/reset/password/code"
        let params = ["phoneCode": phoneCode, "phoneNumber": phoneNumber, "userType": "sp"] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func verifyResetPassword(withPhoneCode phoneCode: String, phoneNumber: String, verificationCode: String,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "verify/reset/password/code"
        let params = ["phoneCode": phoneCode, "phoneNumber": phoneNumber, "verificationCode": verificationCode, "userType": "sp", "deviceType": "ios"] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func resetPassword(withPassword password: String, phoneCode: String, phoneNumber: String, verificationCode: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "reset/password"
        let params = ["password": password, "phoneCode": phoneCode, "phoneNumber": phoneNumber, "verificationCode": verificationCode, "userType": "sp"] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func uploadMyKadInfo(myKadUrls: MyKadUrls, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/update/mykad/info"
        let params = ["myKadUrl": myKadUrls.mykadFronUrl, "myKadUrlBack": myKadUrls.mykadBackUrl, "policeCertificate": myKadUrls.skckUrl] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func updateDrivingLicenseInfo(drivingLicenseUrl: String, drivingLicenseExpiryDate: Double, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/update/driving/license/info"
        let params = ["drivingLicenseUrl": drivingLicenseUrl, "drivingLicenseExpiryDate": drivingLicenseExpiryDate] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func fetchBankList(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/fetch/banks"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func updateBankInfo(bankId: Int, accountHolderName: String, accountNumber: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/update/bank/info"
        let params = ["bankId": bankId, "accountHolderName": accountHolderName, "accountNumber": accountNumber] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    // MARK: - Profile
    
    @discardableResult
    func fetchProfile(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "fetch/profile"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func updateProfile(withFirstName firstName: String, lastName: String, profileImage: String, phoneCode: String, phoneNumber: String,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "update/profile"
        let params = ["firstName": firstName, "lastName": lastName, "profileImage": profileImage, "phoneCode": phoneCode, "phoneNumber": phoneNumber] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .put, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func changePassword(withCurrentPassword currentPassword: String, password: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "change/password"
        let params = ["currentPassword": currentPassword, "password": password] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .put, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getContactUsDetails(withCountry country: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "fetch/contact/info"
        let params = ["country": country] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func doLogout(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "logout"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    // MARK: - Available Jobs
    
    @discardableResult
    func fetchAvailableJobs(withLat lat: Double, lng: Double, destLat: Double, destLong: Double, offset: Int, currentCountry: String ,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "sp/fetch/available/jobs?country=\(currentCountry)"
        let params = ["pickupLat": lat, "pickupLong": lng, "destLat": destLat, "destLong": destLong, "offset": offset, "limit": kOffSet] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func fetchPackageDetails(withPackageId packageId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/fetch/package/\(packageId)"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func sendOffer(withPackageId packageId: Int, proposal: String,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/package/\(packageId)/offer"
        let params = ["proposal": proposal] as [String: AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    // MARK: - My Jobs
    
    @discardableResult
    func fetchPackagesListing(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/fetch/packages"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func startJob(WithPackageId packageId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/package/\(packageId)/start"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func arrivedAt(WithType type: PickupDropoffType, packageId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "sp/package/\(packageId)/\(type.rawValue)"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func confirm(WithType type: ConfirmType, packageId: Int, code: String, dropoffImage: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/package/\(packageId)/confirm/\(type.rawValue)"
        var params = [String:AnyObject]()
        
        if type == ConfirmType.dropoff {
            params = ["code": code, "image": dropoffImage, "lat": Driver.shared.locationManager.location?.coordinate.latitude ?? 0.0, "long": Driver.shared.locationManager.location?.coordinate.longitude ?? 0.0] as [String:AnyObject]
            
        } else {
            params = ["code": code, "lat": Driver.shared.locationManager.location?.coordinate.latitude ?? 0.0, "long": Driver.shared.locationManager.location?.coordinate.longitude ?? 0.0] as [String:AnyObject]
        }
        
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func readyForNextDroppff(WithPackageId packageId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/package/\(packageId)/ready/next-dropoff"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func completeJob(WithPackageId packageId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/package/\(packageId)/complete?lat=\(Driver.shared.locationManager.location?.coordinate.latitude ?? 0.0)&long=\(Driver.shared.locationManager.location?.coordinate.longitude ?? 0.0)"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func rateUser(WithPackageId packageId: Int, rating: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/package/\(packageId)/rate"
        let params = ["rating": rating] as [String:AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    // MARK: - Emergency
    
    @discardableResult
    func getEmergencyReasons(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/package/emergency/reasons"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func reportEmergency(WithPackageId packageId: Int, emergencyReasonId: Int, description: String, image: String, location: CLLocation, address: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/package/\(packageId)/report/emergency"
        let params = ["lat": location.coordinate.latitude,"long": location.coordinate.longitude, "emergencyReasonId": emergencyReasonId, "description": description, "image": image, "primaryAddress": address] as [String:AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .put, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func ArrivedAtEmergencyLocation(WithPackageId packageId: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/package/\(packageId)/arrive/emergency"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func ConfirmEmergencyLocation(WithPackageId packageId: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/package/\(packageId)/confirm/emergency/pickup"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    // MARK: - Cancel Job
    
    @discardableResult
    func fetchCancellationReasons(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/package/reasons"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func CancelJob(WithPackageId packageId: Int, reasonId: Int, reason: String, isOther: Bool, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/package/\(packageId)/cancel"
        var params = [String: AnyObject]()
        
        if isOther {
            params = ["cancellationReason": reason] as [String: AnyObject]
            
        } else {
            params = ["cancellationId": reasonId, "cancellationReason": reason] as [String: AnyObject]
        }
        
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func CancelOffer(WithPackageId packagId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/package/\(packagId)/offer/cancel"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getUnratedJob(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/fetch/unrated/package"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    // MARK: - Notifications List
    
    @discardableResult
    func getNotificationsList(WithOffset offset: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/fetch/notifications?limit=\(kOffSet)&offset=\(offset)"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func actionOnNotification(WithType type: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/action/notifications"
        let params = ["type": type] as [String: AnyObject]
        
        return sendRequest(serviceName, parameters: params, httpMethod: .post, headers: nil, completionBlock: completionBlock)
    }
    
    // MARK: - Localization
    
    @discardableResult
    func fetchAvailableLanguages(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "fetch/available-languages"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func fetchTranslations(lastUpdatedTime: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/fetch/translations?lastUpdatedTime=\(lastUpdatedTime)"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    // MARK: - Chat
    
    @discardableResult
    func getPreviousChat(withPackageId packageId: Int, offset: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/fetch/package/\(packageId)/messages?offset=\(offset)&limit=\(kOffSet)"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func updateTimeZone(withTimeZoneOffset timeZoneOffset: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "update/timezone/offset"
        let params = ["timeZoneOffset": timeZoneOffset] as [String:AnyObject]
        return sendRequest(serviceName, parameters: params, httpMethod: .put, headers: nil, completionBlock: completionBlock)
    }
    
    // MARK: - Earnings
    
    @discardableResult
    func getEarnings(weekNumber: Int, weekYear: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/weekly/earning?weekNumber=\(weekNumber)&weekYear=\(weekYear)"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getWeeklyTransactions(weekNumber: Int, weekYear: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/weekly/transactions?weekNumber=\(weekNumber)&weekYear=\(weekYear)"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getWeekList(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "sp/weeks"
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    // MARK: - App Version
    
    @discardableResult
    func getAppVersion(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "application/version?applicationType=2" // 2 for IOS Rider
        return sendRequest(serviceName, parameters: nil, httpMethod: .get, headers: nil, completionBlock: completionBlock)
    }
    
    // MARK: - Rout Calculation
    
    func getdistanceFromGoogleMap(data: [PackageLocation], _ completionBlock: @escaping APIClientCompletionHandler) {
        
        //https://maps.googleapis.com/maps/api/directions/json?origin=Boston,MA&destination=Concord,MA&waypoints=via:Charlestown,MA|via:Lexington,MA&departure_time=now&key=YOUR_API_KEY
        //&mode=driving&sensor=false&key=AIzaSyB3oIJlf7xs1TumYREL9QsuMozE7CAzInw
        var mode = "&mode=driving&sensor=false&alternatives=true&key=AIzaSyB3oIJlf7xs1TumYREL9QsuMozE7CAzInw"
        
        if data.count > 2 {
            mode = "&mode=driving&sensor=false&waypoints="
            
            for index in 1..<data.count - 1 {
                //via:
                mode.append("via:\(data[index].latitude),\(data[index].longitude)|")
            }
            
            mode.removeLast()
            mode.append("&alternatives=true&key=AIzaSyB3oIJlf7xs1TumYREL9QsuMozE7CAzInw")
        }
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(data.first?.latitude ?? 0.0),\(data.first?.longitude ?? 0.0)&destination=\((data.last?.latitude)!),\((data.last?.longitude)!)\(mode)"
        
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!, method: .get).responseJSON { response in
            let result = response.result
            switch result {
            case .success:
                
                if let responseData : Data = response.data {
                    //                    if response.error != nil {
                    _ = String(data: responseData, encoding: String.Encoding.utf8)
//                    print("\n=========   Response Body   ========== \n" + responseString!)
                    //                    } else {
                    //                        completionBlock(nil,  response.error! as NSError)
                    //                    }
                    
                } else {
                    print("\n=========   Response Body   ========== \n" + "Found Response Body Nil")
                }
                
                completionBlock(response.result.value as AnyObject?, nil)
                
            case .failure(let error):
                completionBlock(nil, error as NSError)
            }
        }
    }
    
    func getTimeZoneFromGoogle(location: CLLocation, _ completionBlock: @escaping APIClientCompletionHandler) {
        
        //https://maps.googleapis.com/maps/api/directions/json?origin=Boston,MA&destination=Concord,MA&waypoints=via:Charlestown,MA|via:Lexington,MA&departure_time=now&key=YOUR_API_KEY
        //&mode=driving&sensor=false&key=AIzaSyB3oIJlf7xs1TumYREL9QsuMozE7CAzInw
        
        let url = "https://maps.googleapis.com/maps/api/timezone/json?location=\(location.coordinate.latitude),\(location.coordinate.longitude)&timestamp=\(Int(location.timestamp.timeIntervalSince1970))&key=AIzaSyB3oIJlf7xs1TumYREL9QsuMozE7CAzInw"
        
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!, method: .get).responseJSON { response in
            let result = response.result
            switch result {
            case .success:
                
                if let responseData : Data = response.data {
                    //                    if response.error != nil {
                    let responseString = String(data: responseData, encoding: String.Encoding.utf8)
                    print("\n=========   Response Body   ========== \n" + responseString!)
                    //                    } else {
                    //                        completionBlock(nil,  response.error! as NSError)
                    //                    }
                    
                } else {
                    print("\n=========   Response Body   ========== \n" + "Found Response Body Nil")
                }
                
                completionBlock(response.result.value as AnyObject?, nil)
                
            case .failure(let error):
                completionBlock(nil, error as NSError)
            }
        }
    }
    
//    https://maps.googleapis.com/maps/api/timezone/json?location=39.6034810,-119.6822510&timestamp=1331766000&key=YOUR_API_KEY
    // MARK: - Image Uploading

    func uploadImage(image: UIImage, type: UploadImageType, _ completionBlock: @escaping (_ success: Bool, _ imageUrl: String) -> Void ) {

        let rotatedImage = image.rotateImage()
        var imageUrl = ""

        if type == UploadImageType.identityDocumentsImages {
            imageUrl = "sp/upload/documents/image"

        } else if type == UploadImageType.vehicleDocumentsImages {
            imageUrl = "driver/upload/vehicle/documents"

        } else if type == UploadImageType.dropOffCode {
            imageUrl = "sp/upload/package/delivery/image"
            
        } else {
            imageUrl = "upload/image"
        }

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(rotatedImage.jpeg(.lowest)!, withName: "image", fileName: "file.jpeg", mimeType: "image/jpeg")

        }, to: URL(string: "\(kBaseUrl + Driver.shared.languageCode)\(imageUrl)")!) { (result) in

            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })

                upload.responseJSON { response in

                    if let json = response.result.value as? [String:Any] {

                        if let data = Mapper<SignIn>().map(JSONObject: json) {
                            print(data.imageUrl)
                            completionBlock(true, data.imageUrl)
                        }

                    } else {
                        completionBlock(false, "")
                    }
                }

            case .failure( _):
                completionBlock(false, "")
                //print encodingError.description
            }
        }
    }
}
