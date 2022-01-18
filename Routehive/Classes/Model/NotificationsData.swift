//
//  SocketData.swift
//  Routehive
//
//  Created by Mac on 25/10/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import Foundation
import ObjectMapper

typealias NotificationsListCompletionHandler = (_ result: NotificationsList, _ error: NSError?) -> Void

class NotificationsData: Mappable {
    
    var alert = ""
    var packageId = 0
    var packageStatus: Int = 0
    var type = ""
    var message = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        alert           <- map["alert"]
        packageId       <- map["resource.packageId"]
        message         <- map["resource.message"]
        packageStatus   <- map["resource.status"]
        type            <- map["type"]
    }
}

class NotificationsList: Mappable {
    
    var notificationsList = [Lists]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        notificationsList       <- map["formattedNotifications"]
    }
    
    func getNotificationsList(viewController: UIViewController, offset: Int, completionBlock: @escaping NotificationsListCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.getNotificationsList(WithOffset: offset) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<NotificationsList>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func actionOnNotification(viewController: UIViewController, type: Int, completionBlock: @escaping NotificationsListCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.actionOnNotification(WithType: type) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<NotificationsList>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}

class Lists: Mappable {
    
    var notificationId = 0
    var packageId = 0
    var isRead = false
    var message = ""
    var timePassed = ""
    var image = ""
    var status = 0
    var shouldNavigate = false
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        notificationId          <- map["notificationId"]
        packageId               <- map["packageId"]
        message                 <- map["message"]
        isRead                  <- map["isRead"]
        timePassed              <- map["timePassed"]
        image                   <- map["image"]
        status                  <- map["status"]
        shouldNavigate          <- map["shouldNavigate"]
        
        postMapping()
    }
    
    func postMapping() {
        message = "<html><body><span style=\"font-family:'Ubuntu'; font-size: 12pt;\">" + message + "</span></body></html>"
    }
}
