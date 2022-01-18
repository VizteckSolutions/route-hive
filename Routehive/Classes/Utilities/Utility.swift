//
//  Utility.swift
//  passManager
//
//  Created by Umair on 6/19/17.
//  Copyright © 2017 Umair. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Alamofire
import SocketIO
import ObjectMapper
import GoogleMaps
import UserNotifications
import NVActivityIndicatorView
import SlideMenuControllerSwift
import SafariServices

class Utility : NSObject {

    static let locationManager = CLLocationManager()

    class func deviceUUID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    class func getCurrentDeviceLanguage() -> String {

        if let language = Locale.current.languageCode {
            return language
        }

        return ""
    }

//    class func setAppLanguageAsDeviceLanguage() {
//
//        switch self.getCurrentDeviceLanguage() {
//
//        case "en":
//            Language.language = .english
//
//        case "fr":
//            Language.language = .french
//
//        default:
//            break
//        }
//
//        kBaseUrl = "http://54.191.103.99:3500/api/v1/\(Language.language.rawValue)/"
//        APIClient.shared.resetApiClient()
//    }

    class func saveStringToUserDefaults(_ value: String?, Key: String) {

        if value != nil {
            UserDefaults.standard.set(value, forKey: Key)
            UserDefaults.standard.synchronize()
        }
    }

    class func presentAlertOnViewController(_ title:String, message:String, viewController:UIViewController){

        let alertViewController = VTAlertViewController(title: title, message: message, style: .alert)
        let okAction = VTAlertAction(title: "Ok", style: .default) { (action) in
        }

        alertViewController.addAction(okAction)
        viewController.present(alertViewController, animated: true, completion: nil)
    }

    class func emptyTableViewMessage(message:String, viewController: UIViewController, tableView:UITableView) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = #colorLiteral(red: 0.5843137255, green: 0.5764705882, blue: 0.5843137255, alpha: 1)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.appThemeFontWithSize(15.0)
        messageLabel.sizeToFit()

        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }

    class func emptyTableViewMessageWithImage(image: UIImage, message: String, buttonTitle: String, isButton: Bool, viewBackgroundColor: UIColor = UIColor.white, viewController: UIViewController, tableView: UITableView) {
        let noJobsView = NoJobsViews.instanceFromNib()
        noJobsView.imageView.image = image
        noJobsView.messageLabel.numberOfLines = 0
        noJobsView.imageView.contentMode = .scaleAspectFit
        noJobsView.messageLabel.text = message
        noJobsView.messageLabel.font = UIFont.appThemeFontWithSize(15.0)
        
        if isButton {
            noJobsView.delegate = (viewController as! NoJobsViewsDelegate)
            noJobsView.viewButton.setTitle(buttonTitle, for: .normal)
            noJobsView.viewButton.titleLabel?.font = UIFont.appThemeFontWithSize(16.0)
            
        } else {
            noJobsView.viewButton.isHidden = true
        }
        
        noJobsView.backgroundColor = viewBackgroundColor

        tableView.backgroundView = noJobsView
        tableView.separatorStyle = .none
    }

    class func emptyTableViewMessageWithButton(message:String, viewController: UIViewController, tableView: UITableView) {
        let noJobsView = NoHelpMateView.instanceFromNib()
        noJobsView.delegate = (viewController as! NoHelpMateViewDelegate)
        noJobsView.requestButton.layer.cornerRadius = noJobsView.requestButton.frame.height/2
//        noJobsView.messageLabel.font = UIFont.appThemeFontWithSize(15.0)

        tableView.backgroundView = noJobsView
        tableView.separatorStyle = .none
    }

    class func requestForLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /**
     A method that will show options for opening your desired map application if installed, currently there is three options (google map, waze, apple map). Make sure you have added comgooglemaps and waze key under LSApplicationQueriesSchemes in your plist files.
     - parameter viewController: viewcontroller value for show action sheet on visible view controller
     - parameter desitenationLat: Latitutde value for the desitination in string
     - parameter desitenationLong: Longtitude value for the desitination in string
     */

    class func openMapApplication(viewController: UIViewController, desitenationLat: String, desitenationLong: String) {

        if CLLocationManager.locationServicesEnabled() {

            switch CLLocationManager.authorizationStatus() {

            case .notDetermined, .restricted, .denied:
                Driver.shared.locationManager.requestAlwaysAuthorization()
                break

            case .authorizedAlways, .authorizedWhenInUse:

                let screenSpecifier = "NavigationApp_Key_"
                let title = screenSpecifier + "Title"
                let cancelButton = screenSpecifier + "Cancel"
                
                CoreDataHelper.fetchLanguage(withKeyPrefix: screenSpecifier) { (data, error) in
                    
                    if error == nil, let languageStrings = data {
                        let alert = UIAlertController.init(title:languageStrings[title], message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
                        
                        let openWaze = UIAlertAction(title:"Waze", style: UIAlertActionStyle.default) { (action) in
                            
                            if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
                                // Waze is installed. Launch Waze and start navigation
                                let urlStr: String = "waze://?ll=\(desitenationLat),\(desitenationLong)&navigate=yes"
                                UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
                            }
                            else {
                                // Waze is not installed. Launch AppStore to install Waze app
                                UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id323229106")!, options: [:], completionHandler: nil)
                            }
                        }
                        
                        let openGoogleMap = UIAlertAction(title:"Google Maps", style: UIAlertActionStyle.default) { (action) in
                            
                            if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                                // Google maps is installed. Launch Google maps and start navigation
                                let urlSrs = "\(Driver.shared.locationManager.location?.coordinate.latitude ?? 0),\(Driver.shared.locationManager.location?.coordinate.longitude ?? 0)"
                                let urlDest = "\(desitenationLat),\(desitenationLong)"
                                let url1: NSURL = NSURL(string:"comgooglemaps://?saddr=\(urlSrs)&daddr=\(urlDest)&directionsmode=driving")!
                                UIApplication.shared.open(url1 as URL, options: [:], completionHandler: nil)
                                
                            } else {
                                // Google map is not installed. Launch AppStore to install Google maps app
                                UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id585027354")!, options: [:], completionHandler: nil)
                            }
                        }
                        
                        let openAppleMap = UIAlertAction(title:"Apple Maps", style: UIAlertActionStyle.default) { (action) in
                            let latitude: CLLocationDegrees = Double(desitenationLat)!
                            let longitude: CLLocationDegrees = Double(desitenationLong)!
                            let regionDistance:CLLocationDistance = 10000
                            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
                            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                                           MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
                            
                            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                            let mapItem = MKMapItem(placemark: placemark)
                            mapItem.name = "Place Name"
                            mapItem.openInMaps(launchOptions: options)
                        }
                        
                        let cancelAction = UIAlertAction(title:languageStrings[cancelButton], style: UIAlertActionStyle.cancel)
                        
                        alert.addAction(openWaze)
                        alert.addAction(openGoogleMap)
                        alert.addAction(openAppleMap)
                        alert.addAction(cancelAction)
                        
                        viewController.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    /**
     A method that displays in app notifications like push notifications.
     - parameter title: The title for the notification
     - parameter message: The message for the notification
     - parameter identifier: An identifier to uniquely indentify the notification in AppDelegate
     - parameter userInfo: A dictionary containing the payload of notification

     */

    class func openMailApp(mailTo: String, cc: String = "") {

        if cc == "" {

            if let url = URL(string: "mailto:\(mailTo)") {
                UIApplication.shared.open(url)
            }

        } else {

            if let url = URL(string: "mailto:\(mailTo)?cc=\(cc)") {
                UIApplication.shared.open(url)
            }
        }
    }

    class func showInAppNotification(title: String, message: String, identifier: String, userInfo: [AnyHashable: Any] = [:]) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default()
        content.userInfo = userInfo
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    class func emptycollectionViewMessageWithImage(message:String, collectionView: UICollectionView) {
        let noJobsView = NoJobsViews.instanceFromNib()
        noJobsView.imageView.image = #imageLiteral(resourceName: "no_msg")
        noJobsView.messageLabel.text = message
        noJobsView.messageLabel.font = UIFont.appThemeFontWithSize(15.0)

        collectionView.backgroundView = noJobsView
    }

    class func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }

    class func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }

    class func isiphone5() -> Bool {

        if self.getScreenHeight() == 568 { // Iphone 5

            return true
        }
        return false
    }

    class func isiphone6() -> Bool {

        if self.getScreenHeight() == 667 { // Iphone 6/7
            return true
        }
        return false
    }

    class func isiphone6Plus() -> Bool {

        if self.getScreenHeight() == 736 { // Iphone 6+/ 7+
            return true
        }
        
        return false
    }

    class func isIphoneX() -> Bool {

        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            return true
        }

        return false
    }

    class func removeCookies() {
        let cstorage = HTTPCookieStorage.shared
        guard URL(string: kBaseUrl) != nil else {return}
        if let cookies = cstorage.cookies(for: URL(string: kBaseUrl)!) {
            for cookie in cookies {
                cstorage.deleteCookie(cookie)
            }
        }
    }

    class func openDialerWith(number phoneNumber: String) {

        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {

            if #available(iOS 10, *) {
                UIApplication.shared.open(url)

            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    class func openSafariWith(Url url: String, viewController:UIViewController) {
        
        if let url = URL(string: url) {
            
            if #available(iOS 11.0, *) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let vc = SFSafariViewController(url: url, configuration: config)
                viewController.present(vc, animated: true)
                
            } else {
                // Fallback on earlier version
                UIApplication.shared.open(url, options: [:])
            }
            
        }
    }
    
    class func saveDriverDataInDefaults(data: Account) {
        Driver.shared.id = data.id
        Driver.shared.firstName = data.firstName
        Driver.shared.lastName = data.lastName
        Driver.shared.name = data.name
        Driver.shared.email = data.email
        Driver.shared.phoneNumber = data.phoneNumber
        Driver.shared.phoneCode = data.phoneCode
        Driver.shared.profileImage = data.profileImage
        Driver.shared.isBlocked = data.isBlocked
        Driver.shared.isEmailUpdate = data.isEmailUpdate
        Driver.shared.avgRating = data.avgRating
        Driver.shared.jobsDoneCount = data.jobsDoneCount
        Driver.shared.referralCode = data.referralCode
        Driver.shared.vehicleName = data.vehicleName
        Driver.shared.vehiclePlateNumber = data.vehiclePlateNumber
        Driver.shared.country = data.country

        UserDefaults.standard.set(data.name, forKey: kSPName)
        UserDefaults.standard.set(data.firstName, forKey: kSPFirstName)
        UserDefaults.standard.set(data.lastName, forKey: kSPLastName)
        UserDefaults.standard.set(data.email, forKey: kSPEmail)
        UserDefaults.standard.set(data.phoneNumber, forKey: kSPMobile)
        UserDefaults.standard.set(data.phoneCode, forKey: kSPMobilecode)
        UserDefaults.standard.set(data.isBlocked, forKey: kSPIsBlocked)
        UserDefaults.standard.set(data.isEmailUpdate, forKey: kSPIsEmailUpdate)
        UserDefaults.standard.set(data.id, forKey: kSPId)
        UserDefaults.standard.set(data.profileImage, forKey: kSPProfileImageUrl)
        UserDefaults.standard.set(data.avgRating, forKey: kAvgRating)
        UserDefaults.standard.set(data.jobsDoneCount, forKey: kJobsDoneCount)
        UserDefaults.standard.set(data.referralCode, forKey: kReferralCode)
        UserDefaults.standard.set(data.vehicleName, forKey: kVehicleName)
        UserDefaults.standard.set(data.vehiclePlateNumber, forKey: kVehiclePlateNumber)
        UserDefaults.standard.set(data.country, forKey: kCountryName)
    }

    class func getDriverDataFromDefaults() {

        if let name = UserDefaults.standard.value(forKey: kSPName) as? String {
            Driver.shared.name = name
        }
        
        if let firstName = UserDefaults.standard.value(forKey: kSPFirstName) as? String {
            Driver.shared.firstName = firstName
        }

        if let lastName = UserDefaults.standard.value(forKey: kSPLastName) as? String {
            Driver.shared.lastName = lastName
        }
        
        if let email = UserDefaults.standard.value(forKey: kSPEmail) as? String {
            Driver.shared.email = email
        }

        if let mobileNumber = UserDefaults.standard.value(forKey: kSPMobile) as? String {
            Driver.shared.phoneNumber = mobileNumber
        }
        
        if let mobileNumberCode = UserDefaults.standard.value(forKey: kSPMobilecode) as? String {
            Driver.shared.phoneCode = mobileNumberCode
        }

        if let id = UserDefaults.standard.value(forKey: kSPId) as? Int {
            Driver.shared.id = id
        }

        if let imageUrl = UserDefaults.standard.value(forKey: kSPProfileImageUrl) as? String {
            Driver.shared.profileImage = imageUrl
        }
        
        if let isBlocked = UserDefaults.standard.value(forKey: kSPIsBlocked) as? Bool {
            Driver.shared.isBlocked = isBlocked
        }
        
        if let isEmailUpdate = UserDefaults.standard.value(forKey: kSPIsEmailUpdate) as? Bool {
            Driver.shared.isEmailUpdate = isEmailUpdate
        }
        
        if let avgRating = UserDefaults.standard.value(forKey: kAvgRating) as? Double {
            Driver.shared.avgRating = avgRating
        }
        
        if let jobsDoneCount = UserDefaults.standard.value(forKey: kJobsDoneCount) as? Int {
            Driver.shared.jobsDoneCount = jobsDoneCount
        }
        
        if let referralCode = UserDefaults.standard.value(forKey: kReferralCode) as? String {
            Driver.shared.referralCode = referralCode
        }

        if let vehicleName = UserDefaults.standard.value(forKey: kVehicleName) as? String {
            Driver.shared.vehicleName = vehicleName
        }
        
        if let vehiclePlateNumber = UserDefaults.standard.value(forKey: kVehiclePlateNumber) as? String {
            Driver.shared.vehiclePlateNumber = vehiclePlateNumber
        }
        
        if let country = UserDefaults.standard.value(forKey: kCountryName) as? String {
            Driver.shared.country = country
        }
    }

    class func saveLanguageCodeInDefaults(languageCode: String) {
        Driver.shared.languageCode = languageCode
        Driver.shared.lastLanguageUpdatedTime = Int(Date().timeIntervalSince1970)
        UserDefaults.standard.set(languageCode, forKey: kLanguageCode)
        UserDefaults.standard.set(Driver.shared.lastLanguageUpdatedTime, forKey: kLastLanguageUpdatedTime)
    }
    
    class func getLanguageCodeDefaults() {
        
        if let languageCode = UserDefaults.standard.value(forKey: kLanguageCode) as? String {
            Driver.shared.languageCode = languageCode
            
        } else {
            Driver.shared.languageCode = "en/"
        }
        
        if let lastLanguageUpdatedTime = UserDefaults.standard.value(forKey: kLastLanguageUpdatedTime) as? Int {
            Driver.shared.lastLanguageUpdatedTime = lastLanguageUpdatedTime
        }
    }
    
    class func displayMessageInDeviceConsole(message: String) {
        NSLog(message)
    }

    class func formattedDateForMessage() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, hh:mm a"
        return dateFormatter.string(from: Date())

    }

    class func showLoading(viewController: UIViewController, offSet: CGFloat = 0) {
        let superView = UIView(frame: CGRect(x: 0, y: 0 - offSet, width: Utility.getScreenWidth(), height: Utility.getScreenHeight()))
        
        //        if let navController = viewController.navigationController, !navController.navigationBar.isTranslucent {
        //            superView.frame =  CGRect(x: 0, y: -64 - offSet, width: Utility.getScreenWidth(), height: Utility.getScreenHeight())
        //        }
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: superView.frame.width/2 - 32.5, y: superView.frame.height/2 - 32.5, width: 65, height: 65))
        let iconImageView = UIImageView(frame: CGRect(x: superView.frame.width/2 - 32.5, y: superView.frame.height/2 - 32.5, width: 65, height: 65))
        
        iconImageView.image =  #imageLiteral(resourceName: "loader")
        superView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = iconImageView.frame.height/2
        superView.tag = 9000
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        activityIndicator.startAnimating()
        superView.addSubview(iconImageView)
        superView.addSubview(activityIndicator)
        superView.bringSubview(toFront: activityIndicator)
        superView.bringSubview(toFront: iconImageView)
        kWindow?.addSubview(superView)
        //        viewController.view.addSubview(superView)
        //        viewController.view.bringSubview(toFront: superView)
        //        viewController.view.isUserInteractionEnabled = false
        //        viewController.view.setNeedsLayout()
        //        viewController.view.setNeedsDisplay()
    }

    class func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        var rootVC = rootViewController

        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }

        if rootVC?.presentedViewController == nil {
            return rootVC
        }

        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }

            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }

            return getVisibleViewController(presented)
        }
        return nil
    }

    class func clearUser() {
        Driver.shared.stopEmmitingLocation()
        
        Driver.shared.id = 0
        Driver.shared.firstName = ""
        Driver.shared.lastName = ""
        Driver.shared.name = ""
        Driver.shared.email = ""
        Driver.shared.phoneNumber = ""
        Driver.shared.phoneCode = ""
        Driver.shared.profileImage = ""
        Driver.shared.isBlocked = false
        Driver.shared.isEmailUpdate = false
        Driver.shared.avgRating = 0.0
        Driver.shared.jobsDoneCount = 0
        Driver.shared.referralCode = ""
        Driver.shared.vehicleName = ""
        Driver.shared.country = ""
        
        UserDefaults.standard.removeObject(forKey: kShouldLoadRejectJobData)
        UserDefaults.standard.removeObject(forKey: kIsUserLoggedIn)
        
        UserDefaults.standard.removeObject(forKey: kSPName)
        UserDefaults.standard.removeObject(forKey: kSPFirstName)
        UserDefaults.standard.removeObject(forKey: kSPLastName)
        UserDefaults.standard.removeObject(forKey: kSPEmail)
        UserDefaults.standard.removeObject(forKey: kSPMobile)
        UserDefaults.standard.removeObject(forKey: kSPMobilecode)
        UserDefaults.standard.removeObject(forKey: kSPIsBlocked)
        UserDefaults.standard.removeObject(forKey: kSPIsEmailUpdate)
        UserDefaults.standard.removeObject(forKey: kSPId)
        UserDefaults.standard.removeObject(forKey: kSPProfileImageUrl)
        UserDefaults.standard.removeObject(forKey: kAvgRating)
        UserDefaults.standard.removeObject(forKey: kJobsDoneCount)
        UserDefaults.standard.removeObject(forKey: kReferralCode)
        UserDefaults.standard.removeObject(forKey: kVehicleName)
        UserDefaults.standard.removeObject(forKey: kCountryName)

        SocketIOManager.sharedInstance.resetSocket()
        Utility.removeCookies()
    }

    class func presentImagePicker(viewController: UIViewController) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .camera
        viewController.present(imagePicker, animated: true, completion: nil)
        
//        let screenSpecifier = "ImagePicker_Key_"
//        let title = screenSpecifier + "Title"
//        let optionGallery = screenSpecifier + "OptionGallery"
//        let optionCamera = screenSpecifier + "OptionCamera"
//        let optionCancel = screenSpecifier + "OptionCancel"
        
//        CoreDataHelper.fetchLanguage(withKeyPrefix: screenSpecifier) { (data, error) in
//
//            if error == nil, let languageStrings = data {
//                let imagePicker = UIImagePickerController()
//                imagePicker.allowsEditing = false
//                imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
//
//                let alert = UIAlertController.init(title: languageStrings[title] ?? "Select media for image", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
//
//                let galleryAction = UIAlertAction(title: languageStrings[optionGallery] ?? "Gallery", style: UIAlertActionStyle.default) { (action) in
//                    imagePicker.sourceType = .photoLibrary
//                    viewController.present(imagePicker, animated: true, completion: nil)
//                }
//
//                let cameraAction = UIAlertAction(title: languageStrings[optionCamera] ?? "Camera", style: UIAlertActionStyle.default) { (action) in
//                    imagePicker.sourceType = .camera
//                    viewController.present(imagePicker, animated: true, completion: nil)
//                }
//
//                let cancelAction = UIAlertAction(title: languageStrings[optionCancel] ?? "Cancel", style: UIAlertActionStyle.cancel)
//
////                alert.addAction(galleryAction)
//                alert.addAction(cameraAction)
//                alert.addAction(cancelAction)
//
//                viewController.present(alert, animated: true, completion: nil)
//            }
//        }
    }

    class func hideLoading(viewController: UIViewController?) {

        if let activityView = kWindow?.viewWithTag(9000) {
//            viewController?.view.isUserInteractionEnabled = true
            activityView.removeFromSuperview()
        }
    }

    class func setupHomeViewController() {
        let screenSpecifier = "TabBar_Key_"
        let availableJobs = screenSpecifier + "AvailableJobs"
        let myJobs = screenSpecifier + "MyJobs"
        let notifications = screenSpecifier + "Notifications"
        let account = screenSpecifier + "Account"
        
        CoreDataHelper.fetchLanguage(withKeyPrefix: screenSpecifier) { (data, error) in
            
            if error == nil, let languageStrings = data {
                UserDefaults.standard.set(true, forKey: kIsUserLoggedIn)
                Utility.getDriverDataFromDefaults()
                
                if UserDefaults.standard.bool(forKey: kIsUserLoggedIn) && SocketIOManager.sharedInstance.socket?.status != SocketIOStatus.connected {
                    SocketIOManager.sharedInstance.establishConnection()
                }
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                let tabbarController = UITabBarController()
                tabbarController.delegate = appDelegate as? UITabBarControllerDelegate
                
                // view Controllers which will be used in tabs
                let availableJobsMapViewController = AvailableJobContainerViewController()
                let myJobsViewController = MyJobsViewController()
                let notificationsViewController = NotificationsViewController()
                let accountViewController = AccountViewController()
                
                // Creating navigation Controller and putting them in tabBarController because without it we will not be able to push viewController
                let availableJobsNavigationController = UINavigationController()
                let myJobsNavigationController = UINavigationController()
                let notificationsNavigationController = UINavigationController()
                let accountNavigationController = UINavigationController()

                availableJobsNavigationController.setupAppThemeNavigationBar()
                myJobsNavigationController.setupAppThemeNavigationBar()
                notificationsNavigationController.setupAppThemeNavigationBar()
                accountNavigationController.setupAppThemeNavigationBar()
                
                availableJobsNavigationController.viewControllers = [availableJobsMapViewController]
                myJobsNavigationController.viewControllers = [myJobsViewController]
                notificationsNavigationController.viewControllers = [notificationsViewController]
                accountNavigationController.viewControllers = [accountViewController]
                
                tabbarController.tabBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                tabbarController.tabBar.backgroundImage = UIImage(color: #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 1))
                tabbarController.viewControllers = []
                tabbarController.viewControllers = [availableJobsNavigationController, myJobsNavigationController, notificationsNavigationController, accountNavigationController]
                tabbarController.selectedIndex = 0
                
                tabbarController.tabBar.items![TabBarModules.availableJobs.rawValue].title =  languageStrings[availableJobs]
                tabbarController.tabBar.items![TabBarModules.myJobs.rawValue].title = languageStrings[myJobs]
                tabbarController.tabBar.items![TabBarModules.notifications.rawValue].title = languageStrings[notifications]
                tabbarController.tabBar.items![TabBarModules.account.rawValue].title = languageStrings[account]
                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont.appThemeFontWithSize(11.0)], for: .normal)
                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont.appThemeFontWithSize(11.0)], for: .selected)
                tabbarController.tabBar.items![TabBarModules.availableJobs.rawValue].image = #imageLiteral(resourceName: "tab_available_jobs")
                tabbarController.tabBar.items![TabBarModules.myJobs.rawValue].image = #imageLiteral(resourceName: "tab_my_jobs")
                tabbarController.tabBar.items![TabBarModules.notifications.rawValue].image = #imageLiteral(resourceName: "tab_notification")
                tabbarController.tabBar.items![TabBarModules.account.rawValue].image = #imageLiteral(resourceName: "tab_account")
                
                //        Driver.shared.tabBarController = tabbarController
                
                if UIApplication.shared.keyWindow != nil {
                    UIApplication.shared.keyWindow!.replaceRootViewControllerWith(tabbarController, animated: true, completion: nil)
                    
                } else {
                    appDelegate?.window?.rootViewController = tabbarController
                    appDelegate?.window?.makeKeyAndVisible()
                }
                Driver.shared.isHomeOnceTapped = true
            }
        }
    }

    class func setupLoginAsRootViewController() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        let loginViewController = SignInViewController()
        navigationController.viewControllers = [loginViewController]

        if UIApplication.shared.keyWindow != nil {
            UIApplication.shared.keyWindow!.replaceRootViewControllerWith(navigationController, animated: true, completion: nil)

        } else {
            appDelegate?.window?.rootViewController = navigationController
            appDelegate?.window?.makeKeyAndVisible()
        }
    }

    class func setupSignUpAsRootViewController() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        let signUpViewController = SignUpViewController()
        navigationController.viewControllers = [signUpViewController]
        
        if UIApplication.shared.keyWindow != nil {
            UIApplication.shared.keyWindow!.replaceRootViewControllerWith(navigationController, animated: true, completion: nil)
            
        } else {
            appDelegate?.window?.rootViewController = navigationController
            appDelegate?.window?.makeKeyAndVisible()
        }
    }
    
    class func showSuccess(viewController: UIViewController, labelText: String, completion: @escaping () -> ()) {
        let superView = UIView(frame: CGRect(x: viewController.view.frame.width/2 , y: viewController.view.frame.height/2 , width: 180, height: 150))
        let imageView = UIImageView(frame: CGRect(x: superView.frame.width/2 - 35, y: superView.frame.height/2 - 35 , width: 70, height: 70))

        let label = UILabel(frame: CGRect(x: 0, y: imageView.frame.height + 35 , width: 180, height: 45))

        label.text = labelText
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 2
        imageView.image = #imageLiteral(resourceName: "icon_set_location")

        superView.center = CGPoint(x: viewController.view.bounds.width/2 , y: viewController.view.bounds.height/2)
        superView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        superView.layer.cornerRadius = 10
        superView.tag = 8000

        superView.addSubview(imageView)
        superView.bringSubview(toFront: imageView)

        superView.addSubview(label)
        superView.bringSubview(toFront: label)

        viewController.view.addSubview(superView)
        viewController.view.bringSubview(toFront: superView)

        // remove from super view after durations
        let delay = DispatchTime.now() + Double(Int64(3.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {

            if let activityView = viewController.view.viewWithTag(8000) {
                activityView.removeFromSuperview()
                completion()
            }
        }
    }

    /**
     A method that will add shortcut items of 3D Touch.
     you must have 3D Touch supported device
     */
    
    class func addShortcutItems() {

        if UserDefaults.standard.bool(forKey: kIsUserLoggedIn) {
            
            let screenSpecifier = "ThreeDTouch_Key_"
            let myJobsTitle = screenSpecifier + "MyJobsTitle"
            let notificationsTitle = screenSpecifier + "NotificationsTitle"
            let earningsTitle = screenSpecifier + "EarningsTitle"
            let changeLanguageTitle = screenSpecifier + "ChangeLanguageTitle"
            
            let myJobsDetail = screenSpecifier + "MyJobsDetail"
            let notificationsDetail = screenSpecifier + "NotificationsDetail"
            let earningsDetail = screenSpecifier + "EarningsDetail"
            let changeLanguageDetail = screenSpecifier + "ChangeLanguageDetail"
            
            
            CoreDataHelper.fetchLanguage(withKeyPrefix: screenSpecifier) { (data, error) in
                
                if error == nil, let languageStrings = data {
                    let myPackages = UIApplicationShortcutItem(type: "\(Bundle.main.bundleIdentifier ?? "").\(ShortcutItems.myPackages.rawValue)", localizedTitle: languageStrings[myJobsTitle] ?? "", localizedSubtitle: languageStrings[myJobsDetail] ?? "", icon: UIApplicationShortcutIcon(type: .favorite), userInfo: nil)
                    
                    let notifications = UIApplicationShortcutItem(type: "\(Bundle.main.bundleIdentifier ?? "").\(ShortcutItems.notifications.rawValue)", localizedTitle: languageStrings[notificationsTitle] ?? "", localizedSubtitle: languageStrings[notificationsDetail] ?? "", icon: UIApplicationShortcutIcon(type: .task), userInfo: nil)
                    
                    let earnings = UIApplicationShortcutItem(type: "\(Bundle.main.bundleIdentifier ?? "").\(ShortcutItems.earnings.rawValue)", localizedTitle: languageStrings[earningsTitle] ?? "", localizedSubtitle: languageStrings[earningsDetail] ?? "", icon: UIApplicationShortcutIcon(type: .taskCompleted), userInfo: nil)
                    
                    let changeLanguage = UIApplicationShortcutItem(type: "\(Bundle.main.bundleIdentifier ?? "").\(ShortcutItems.changeLanguage.rawValue)", localizedTitle: languageStrings[changeLanguageTitle] ?? "", localizedSubtitle: languageStrings[changeLanguageDetail] ?? "", icon: UIApplicationShortcutIcon(type: .shuffle), userInfo: nil)
                    
                    UIApplication.shared.shortcutItems = [myPackages, notifications, changeLanguage, earnings]
                }
            }

        } else {
            UIApplication.shared.shortcutItems = []
        }
    }

    class func animateTableView(tableView: UITableView) {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height

        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }

        var delayCounter = 0

        for cell in cells {

            UIView.animate(withDuration: 1.20, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }

    class func animateTableView(animationType: TableViewAnimationType, tableView: UITableView, cell: UITableViewCell) {

        switch animationType {

        case .fromLeft:
            let transform = CATransform3DTranslate(CATransform3DIdentity, -tableView.bounds.size.width, 30, 0)
            cell.layer.transform = transform
            break

        case .fromRight:
            let transform = CATransform3DTranslate(CATransform3DIdentity, tableView.bounds.size.width, 30, 0)
            cell.layer.transform = transform
            break

        case .fromBottom:
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, tableView.bounds.size.height, 0)
            cell.layer.transform = transform
            break
            
        case .fromTop:
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -tableView.bounds.size.height, 0)
            cell.layer.transform = transform
            break
            
        case .scaleFromTop:
            
            let transform = CATransform3DScale(CATransform3DIdentity, 0, 0, 0)
            cell.layer.transform = transform
            break
        }

        // Animating to final stage
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }

    class func getDistantceBetween(pointA: CLLocationCoordinate2D, pointB: CLLocationCoordinate2D) -> Double {
        let coordinateA = CLLocation(latitude: pointA.latitude, longitude: pointA.longitude)
        let coordinateB = CLLocation(latitude: pointB.latitude, longitude: pointB.longitude)
        return coordinateA.distance(from: coordinateB) // result is in meters
    }

    class func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    class func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    class func findBearingAngle(pointA: CLLocationCoordinate2D, pointB: CLLocationCoordinate2D) -> Double {
        let point1 = CLLocation(latitude: pointA.latitude, longitude: pointA.longitude)
        let point2 = CLLocation(latitude: pointB.latitude, longitude: pointB.longitude)

        let lat1 = Utility.degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = Utility.degreesToRadians(degrees: point1.coordinate.longitude)

        let lat2 = Utility.degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = Utility.degreesToRadians(degrees: point2.coordinate.longitude)

        let diffBetweenPoints = lon2 - lon1

        let y = sin(diffBetweenPoints) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(diffBetweenPoints)
        let radiansBearing = atan2(y, x)
        let degree = radiansToDegrees(radians: radiansBearing)
        return degree
    }

    /**
     A method that displays in app notifications like push notifications.
     - parameter marker: The marker which we want to animate from one place to other
     - parameter coordinates: The new location to which we want to display our marker on
     */

    class func updateMarker(mapView: GMSMapView, marker:GMSMarker, coordinates: CLLocationCoordinate2D, degree: CLLocationDegrees) {
        // Keep Rotation Short
        print("degree: \(degree)")
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        marker.rotation = degree
        CATransaction.commit()

        // Movement
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        marker.position = coordinates

        // Center Map View
        let camera = GMSCameraUpdate.setTarget(coordinates)
        mapView.animate(with: camera)
        CATransaction.commit()
    }
    
    class func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
     A method that will daraw text in image
     - parameter text: text that we want to write in image
     - inImage: image on we want to write text
    */
    class func drawText(text:NSString, inImage:UIImage) -> UIImage? {
        
        let font = UIFont.appThemeFontWithSize(14)
        let size = inImage.size
        
//        UIGraphicsBeginImageContext(size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        inImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let style : NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.alignment = .center
        let attributes:NSDictionary = [ NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle : style, NSAttributedStringKey.foregroundColor : UIColor.white ]
        
        let textSize = text.size(withAttributes: attributes as? [NSAttributedStringKey : Any])
        let rect = CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height)
        let textRect = CGRect(x: (rect.size.width - textSize.width)/2, y: (rect.size.height - textSize.height)/2 - 4, width: textSize.width, height: textSize.height)
        text.draw(in: textRect.integral, withAttributes: attributes as? [NSAttributedStringKey : Any])
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    class func getDefaultLanguage() {
        
        CoreDataHelper.localDbEmpty { (isEmpty, error) in
            
            if error == nil && !isEmpty {} else {
                
                if let path = Bundle.main.path(forResource: "English", ofType: "json") {
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                        if let jsonResult = jsonResult as? Dictionary<String, String> {
                            self.saveInCoreData(json: jsonResult)
                        }
                    } catch {
                        // handle error
                        print("error in saving default language")
                    }
                }
            }
        }
    }
    
    class func saveInCoreData(json: [String: String]) {
        
        CoreDataHelper.clearLocalDB(completion: { (success, error) in
            
            if error == nil {
                
                CoreDataHelper.insertLanguage(usingDictionary: json, completion: { (success, error) in
                    
                    if error == nil {
                        print("saved default language successfully.")
                        
                    } else {
                        print("error in saving default language.")
                    }
                })
            }
        })
    }
}
