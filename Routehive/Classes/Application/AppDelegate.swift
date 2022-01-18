//
//  AppDelegate.swift
//  Routehive
//
//  Created by Huzaifa on 9/24/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import UserNotifications
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import CoreData
import ObjectMapper
import Fabric
import Crashlytics

@objc protocol ApplicationMainDelegate {
    @objc optional func applicationDidBecomeActiveSignup()
    @objc optional func applicationDidBecomeActive()
    @objc optional func didReceiveNewJobEvent()
    @objc optional func didReceiveJobCancelledEvent()
    @objc optional func didReceiveOfferCancelledEvent(packageId: Int)
    @objc optional func didReceiveJobAccecptedEvent()
    @objc optional func didReceiveNewMessage(message: Message)
    @objc optional func reloadChat(packageId: Int)
    
    @objc optional func didReceiveSpSwappedEvent()
    @objc optional func didReceiveEmergencyPackageAssignedEvent()
    @objc optional func didReceiveBackupSpArrivedEvent()
    @objc optional func didReceiveBackupSpConfirmPickupEvent()
    @objc optional func didReceiveAdminAssignedDriverEvent()
    @objc optional func didReceiveOfferAssignToAnotherEvent(packageId: Int)
    @objc optional func didReceiveUnblockPackage()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var delegate: ApplicationMainDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.setupApp(application: application)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //        SocketIOManager.sharedInstance.closeConnection()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        if UserDefaults.standard.bool(forKey: kIsUserLoggedIn) {
            delegate?.applicationDidBecomeActive?()
            
        } else {
            delegate?.applicationDidBecomeActiveSignup?()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        if shortcutItem.type == "\(Bundle.main.bundleIdentifier ?? "").\(ShortcutItems.myPackages.rawValue)" {
            Driver.shared.shouldOpenMyJobs = true
            
        } else if shortcutItem.type == "\(Bundle.main.bundleIdentifier ?? "").\(ShortcutItems.earnings.rawValue)" {
            Driver.shared.shouldOpenEarnings = true
            
        } else if shortcutItem.type == "\(Bundle.main.bundleIdentifier ?? "").\(ShortcutItems.changeLanguage.rawValue)" {
            Driver.shared.shouldChangeLanguage = true
            
        } else if shortcutItem.type == "\(Bundle.main.bundleIdentifier ?? "").\(ShortcutItems.notifications.rawValue)" {
            Driver.shared.shouldOpenNotifications = true
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "routehive")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Private Methods
    
    func setupApp(application: UIApplication) {
        Utility.getDefaultLanguage()
        window?.backgroundColor = .white
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        SocketIOManager.sharedInstance.delegate = self
        
        if UserDefaults.standard.bool(forKey: kIsUserLoggedIn) {
            SocketIOManager.sharedInstance.establishConnection()
        }
        setupLibraries()
        setupPushNotification(application: application)
        Utility.getLanguageCodeDefaults()
//        Localization.getTranslations { (error) in}
        self.setupRootViewController()
    }
    
    func setupPushNotification(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
    }
    
    func setupLibraries() {
        // Crashlytics
        Fabric.with([Crashlytics.self])
        // IQKeyBoard
        IQKeyboardManager.sharedManager().enable = true
        GMSPlacesClient.provideAPIKey(kGoogleMapsKey)
        GMSServices.provideAPIKey(kGoogleMapsKey)
    }
    
    func setupRootViewController() {
        
        if UserDefaults.standard.bool(forKey: kIsUserLoggedIn) {
            Utility.setupHomeViewController()
            Utility.addShortcutItems()
            
        } else {
            Utility.clearUser()
            let signSignUpOptionsViewController = SignSignUpOptionsViewController()
            
            if UIApplication.shared.keyWindow != nil {
                UIApplication.shared.keyWindow!.replaceRootViewControllerWith(signSignUpOptionsViewController, animated: true, completion: nil)
                
            } else {
                self.window?.rootViewController = signSignUpOptionsViewController
                self.window?.makeKeyAndVisible()
            }
        }
    }
    
    func openJobDetails(packageId:Int, topController:UIViewController) {
        
        if Driver.shared.isHomeOnceTapped {
            let navigationController = UINavigationController()
            navigationController.setupAppThemeNavigationBar()
            
            let packageDetailViewController = MyJobDetailViewController()
            packageDetailViewController.jobId = packageId
            
            navigationController.viewControllers = [packageDetailViewController]
            packageDetailViewController.addCustomCrossButton()
            
            topController.present(navigationController, animated: true, completion: nil)
            
        } else {
            Driver.shared.isFromPush = true
            Driver.shared.selectedPackageId = packageId
            Driver.shared.selectedPackageStatus = 4
        }
    }
    
    func openAvailableJobDetails(packageId:Int, packageStatus: Int, topController:UIViewController) {
        
        if Driver.shared.isHomeOnceTapped {
            let navigationController = UINavigationController()
            navigationController.setupAppThemeNavigationBar()
            //navigationController.addCustomCrossButton()
            
            let packageDetailViewController = AvailableJobDetailViewController()
            packageDetailViewController.jobId = packageId
            
            navigationController.viewControllers = [packageDetailViewController]
            packageDetailViewController.addCustomCrossButton()
            
            topController.present(navigationController, animated: true, completion: nil)
            
        } else {
            Driver.shared.isFromPush = true
            Driver.shared.selectedPackageId = packageId
            Driver.shared.selectedPackageStatus = packageStatus
        }
    }
    
    // MARK: - Push Notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        Driver.shared.deviceToken = deviceTokenString
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register push notification \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Did Recive push notification:  \(response.notification.request.content.userInfo)")
        
        if let notification = response.notification.request.content.userInfo["aps"] as? NSDictionary {
            
            print("Notification: \(notification)")
            
            if let data = Mapper<NotificationsData>().map(JSONObject: notification) {
                
                print("Data: \(data)")
                
                if data.type == NotificationType.newMessage.rawValue {
                    delegate?.reloadChat?(packageId: data.packageId)
                    let visibleNavController = Utility.getVisibleViewController(self.window?.rootViewController)
                    let topController = (visibleNavController?.topMostViewController())!
                    
                    if data.packageStatus == 1 {
                        
                        if !topController.isKind(of: AvailableJobDetailViewController.self) && !topController.isKind(of: CustomChatViewController.self) {
                            openAvailableJobDetails(packageId: data.packageId, packageStatus: data.packageStatus, topController: topController)
                        }
                        
                    } else {
                        
                        if !topController.isKind(of: MyJobDetailViewController.self) && !topController.isKind(of: CustomChatViewController.self) {
                            openJobDetails(packageId: data.packageId, topController: topController)
                        }
                    }
                    
                } else if data.type == NotificationType.newPackagePosted.rawValue {
                    delegate?.didReceiveNewJobEvent?()
                    
                } else if data.type == NotificationType.userAcceptedOffer.rawValue {
                    delegate?.didReceiveJobAccecptedEvent?()
                    let visibleNavController = Utility.getVisibleViewController(self.window?.rootViewController)
                    let topController = (visibleNavController?.topMostViewController())!
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        
                        if (visibleNavController?.isModal)! {
                            visibleNavController?.dismiss(animated: true, completion: nil)
                        }
                    }
                    
                    if !topController.isKind(of: MyJobDetailViewController.self) {
                        
                        //                        if (visibleNavController?.isKind(of: AvailableJobDetailViewController.self))! {
                        //                            visibleNavController?.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        //                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            let visibleNavController2 = Utility.getVisibleViewController(self.window?.rootViewController)
                            let topController2 = (visibleNavController2?.topMostViewController())!
                            self.openJobDetails(packageId: data.packageId, topController: topController2)
                        }
                    }
                    
                } else if data.type == NotificationType.userCancelledPackage.rawValue {
                    delegate?.didReceiveJobCancelledEvent?()
                    
                    let visibleNavController = Utility.getVisibleViewController(self.window?.rootViewController)
                    let topController = (visibleNavController?.topMostViewController())!
                    
                    if topController.isKind(of: MyJobDetailViewController.self) {
                        
                        if (visibleNavController?.isModal)! {
                            visibleNavController?.dismiss(animated: true, completion: nil)
                        }
                    }
                    
                } else if data.type == NotificationType.spSwappedKey.rawValue {
                    delegate?.didReceiveSpSwappedEvent?()
                    
                } else if data.type == NotificationType.backupSpArrivedKey.rawValue {
                    let visibleNavController = Utility.getVisibleViewController(self.window?.rootViewController)
                    let topController = (visibleNavController?.topMostViewController())!
                    if !topController.isKind(of: MyJobDetailViewController.self) {
                        openJobDetails(packageId: data.packageId, topController: topController)
                        
                    } else {
                        delegate?.didReceiveBackupSpArrivedEvent?()
                    }
                    
                } else if data.type == NotificationType.backupSpConfirmedPickupKey.rawValue {
                    let visibleNavController = Utility.getVisibleViewController(self.window?.rootViewController)
                    let topController = (visibleNavController?.topMostViewController())!
                    if !topController.isKind(of: MyJobDetailViewController.self) {
                        openJobDetails(packageId: data.packageId, topController: topController)
                        
                    } else {
                        delegate?.didReceiveBackupSpConfirmPickupEvent?()
                    }
                    
                } else if data.type == NotificationType.adminAssignedDriver.rawValue {
                    let visibleNavController = Utility.getVisibleViewController(self.window?.rootViewController)
                    let topController = (visibleNavController?.topMostViewController())!
                    if !topController.isKind(of: MyJobDetailViewController.self) {
                        openJobDetails(packageId: data.packageId, topController: topController)
                        
                    } else {
                        delegate?.didReceiveAdminAssignedDriverEvent?()
                    }
                    
                } else if data.type == NotificationType.documentsSetFOrExpiry.rawValue {
                    
                } else if data.type == NotificationType.offerAssignToOther.rawValue {
                    delegate?.didReceiveOfferAssignToAnotherEvent?(packageId:data.packageId)
                }
            }
        }
        
        center.removeAllDeliveredNotifications()
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

extension AppDelegate: SocketIOManagerDelegate {
    
    func didReceiveUnblockPackageEvent() {
        delegate?.didReceiveUnblockPackage?()
    }
    
    func didReceiveDocumentsSetForExpiryEvent() {
    }
    
    func didReceiveOfferAssignToAnotherEvent(packageId: Int) {
        delegate?.didReceiveOfferAssignToAnotherEvent?(packageId: packageId)
    }
    
    
    func didReceiveAdminAssignedDriverEvent() {
        delegate?.didReceiveAdminAssignedDriverEvent?()
    }
    
    func didReceiveEmergencyPackageAssignedEvent() {
        delegate?.didReceiveEmergencyPackageAssignedEvent?()
    }
    
    func didReceiveOfferCancelledEvent(packageId: Int) {
        delegate?.didReceiveOfferCancelledEvent?(packageId: packageId)
        
        let visibleNavController = Utility.getVisibleViewController(self.window?.rootViewController)
        let topController = (visibleNavController?.topMostViewController())!
        
        if topController.isKind(of: AvailableJobDetailViewController.self) {
            
            if (visibleNavController?.isModal)! {
                visibleNavController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func didReceiveSpSwappedEvent() {
        delegate?.didReceiveSpSwappedEvent?()
    }
    
    func didReceiveBackupSpArrivedEvent() {
        delegate?.didReceiveBackupSpArrivedEvent?()
    }
    
    func didReceiveBackupSpConfirmPickupEvent() {
        delegate?.didReceiveBackupSpConfirmPickupEvent?()
    }
    
    func didReceiveJobCancelledEvent() {
        delegate?.didReceiveJobCancelledEvent?()
        
        let visibleNavController = Utility.getVisibleViewController(self.window?.rootViewController)
        let topController = (visibleNavController?.topMostViewController())!
        
        if topController.isKind(of: MyJobDetailViewController.self) {
            
            if (visibleNavController?.isModal)! {
                visibleNavController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func didReceiveNewMessage(message: Message) {
        delegate?.didReceiveNewMessage?(message: message)
    }
    
    func didReceiveNewJobEvent() {
        delegate?.didReceiveNewJobEvent?()
    }
    
    func didReceiveJobAccecptedEvent() {
        delegate?.didReceiveJobAccecptedEvent?()
        
        let visibleNavController = Utility.getVisibleViewController(self.window?.rootViewController)
        
        let topController = (visibleNavController?.topMostViewController())!
        
        if topController.isKind(of: AvailableJobDetailViewController.self) {
            
            if (visibleNavController?.isModal)! {
                visibleNavController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
