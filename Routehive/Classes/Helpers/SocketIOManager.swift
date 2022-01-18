//
//  SocketIOManager.swift
//  Help Connect
//
//  Created by Umair Afzal on 09/01/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import Foundation
import SocketIO
import ObjectMapper
import CoreLocation

protocol SocketIOManagerDelegate {
    func didReceiveNewJobEvent()
    func didReceiveJobAccecptedEvent()
    func didReceiveJobCancelledEvent()
    func didReceiveOfferCancelledEvent(packageId: Int)
    func didReceiveNewMessage(message: Message)
    
    func didReceiveSpSwappedEvent()
    func didReceiveEmergencyPackageAssignedEvent()
    func didReceiveBackupSpArrivedEvent()
    func didReceiveBackupSpConfirmPickupEvent()
    func didReceiveAdminAssignedDriverEvent()
    func didReceiveDocumentsSetForExpiryEvent()
    func didReceiveOfferAssignToAnotherEvent(packageId: Int)
    func didReceiveUnblockPackageEvent()
}

class SocketIOManager: NSObject {
    
    static let sharedInstance = SocketIOManager()
    var delegate: SocketIOManagerDelegate?
    var dateFormatter = DateFormatter()
    var socketManager: SocketManager?
    var socket: SocketIOClient?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var isConnectingSocket = false
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd-MM-yyyy, hh:mm a"
        initializeSocket()
    }
    
    func initializeSocket() {
        print("Initializing Socket.....................")
        if let socketUrl = URL(string: kSocketUrl) {
            socketManager = SocketManager(socketURL: socketUrl, config: [.log(false), .compress, .forceNew(true)])
            socket = socketManager?.defaultSocket
            socket?.manager?.reconnects = true
            observeSocketClientEvents()
            establishConnection()
        }
        
    }
    
    func establishConnection() {
        print("establish Socket Connection .....................")
        
        if socket == nil {
            initializeSocket()
            
        } else if socket?.status != .connected && !isConnectingSocket && UserDefaults.standard.bool(forKey: kIsUserLoggedIn) {
            isConnectingSocket = true
            print("Connecting Socket.....................")
            socket?.connect()
        }
    }

    func resetSocket() {
        print("resetSocket")
        socket?.disconnect()
        removeSocketClientEvents()
        socket = nil
    }

    func removeAllEvents() {
        print("removeAllSocketEvents")
        socket?.off(NotificationType.newPackagePosted.rawValue)
        socket?.off(NotificationType.userAcceptedOffer.rawValue)
        socket?.off(NotificationType.userCancelledPackage.rawValue)
        socket?.off(NotificationType.newMessage.rawValue)
        socket?.off(NotificationType.packageOfferCancelled.rawValue)
        socket?.off(NotificationType.spSwappedKey.rawValue)
        socket?.off(NotificationType.backupSpArrivedKey.rawValue)
        socket?.off(NotificationType.backupSpConfirmedPickupKey.rawValue)
        socket?.off(NotificationType.emergencyPackageAssignedKey.rawValue)
        
        socket?.off(NotificationType.accountApproved.rawValue)
        socket?.off(NotificationType.accountRejected.rawValue)
        socket?.off(NotificationType.accountBlocked.rawValue)
        socket?.off(NotificationType.accountUnBlocked.rawValue)
        socket?.off(NotificationType.driversExpiredLicense.rawValue)
        socket?.off(NotificationType.driversInspectionNoteExpired.rawValue)
        socket?.off(NotificationType.driversExpireInsurance.rawValue)
        socket?.off(NotificationType.customNotification.rawValue)
        socket?.off(NotificationType.adminAssignedDriver.rawValue)
        socket?.off(NotificationType.unblockPackage.rawValue)
        socket?.off(NotificationType.documentsSetFOrExpiry.rawValue)
        socket?.off(NotificationType.offerAssignToOther.rawValue)
    }
    
    func observeAllEvents() {
        print("observeAllSocketEvents")
        observeNewJobEvent()
        observeJobAccecptedEvent()
        observeJobCancelledEvent()
        observeNewMessageEvent()
        observeOfferCancelledEvent()
        observeSpSwappedEvent()
        observeBackupSpArrivedEvent()
        observeBackupSpConfirmPickupEvent()
        observeEmergencyPackageAssignedEvent()
        
        observeAccountApprovedEvent()
        observeAccountRejectedEvent()
        observeAccountBlockedEvent()
        observeAccountUnBlockedEvent()
        observeDriversExpiredLicenseEvent()
        observeDriversInspectionNoteExpiredEvent()
        observeDriversExpireInsuranceEvent()
        observeCustomNotificationEvent()
        observeAdminAssignedDriverEvent()
        observeOfferAssignToOtherEvent()
        observeDocumentsSetForExpiryEvent()
        observeUnblockPackageEvent()
    }

    func removeSocketClientEvents(){
        print("removeAllSocketClientEvents")
        socket?.off(clientEvent: .connect)
        socket?.off(clientEvent: .error)
        socket?.off(clientEvent: .disconnect)
        socket?.off(clientEvent: SocketClientEvent.reconnect)
    }
    
    func observeSocketClientEvents() {

        socket?.on(clientEvent: .connect) {data, ack in
            self.isConnectingSocket = false
            self.observeAllEvents()
            print(data)
            print("socket connected")
            self.showConnectionMessage(message: "socket connected")
            Driver.shared.startEmittingLocation()
        }
        
        socket?.on(clientEvent: .error) { [weak self] (data, eck) in
            print(data)
            print("socket error")
            self?.isConnectingSocket = false
            self?.removeAllEvents()
        }
        
        socket?.on(clientEvent: .disconnect) { (data, eck) in
            print(data)
            print("socket disconnect")
            self.isConnectingSocket = false
            self.removeAllEvents()
            self.showConnectionMessage(message: "Socket Disconnected")
        }
        
        socket?.on(clientEvent: SocketClientEvent.reconnect) { (data, eck) in
            print(data)
            print("socket reconnect")
        }
    }
    
    func observeNewJobEvent() {
        
        socket?.on(NotificationType.newPackagePosted.rawValue) { (dataArray, ack) in
            print("Socket Event: New Packages Available \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {

                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    self.delegate?.didReceiveNewJobEvent()
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }

    func observeJobCancelledEvent() {
        
        socket?.on(NotificationType.userCancelledPackage.rawValue) { (dataArray, ack) in
            print("Socket Event: Job Cancelled Event \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    self.delegate?.didReceiveJobCancelledEvent()
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeOfferCancelledEvent() {
        
        socket?.on(NotificationType.packageOfferCancelled.rawValue) { (dataArray, ack) in
            print("Socket Event: Job Cancelled Event \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    self.delegate?.didReceiveOfferCancelledEvent(packageId: data.packageId)
                    Utility.showInAppNotification(title: "", message: "Offer rejected by user", identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeJobAccecptedEvent() {
        
        socket?.on(NotificationType.userAcceptedOffer.rawValue) { (dataArray, ack) in
            print("Socket Event: Packages Accepted \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    self.delegate?.didReceiveJobAccecptedEvent()
                    
                    let resource = ["resource":["packageId": data.packageId, "message": data.message], "type": NotificationType.userAcceptedOffer.rawValue] as [String : Any]
                    let userInfo = ["aps":resource]
                    
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.userAcceptedOffer.rawValue, userInfo: userInfo)
                }
            }
        }
    }
    
    func observeSpSwappedEvent() {
        
        socket?.on(NotificationType.spSwappedKey.rawValue) { (dataArray, ack) in
            print("Socket Event: SP Swapped \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    self.delegate?.didReceiveSpSwappedEvent()
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }

    func observeEmergencyPackageAssignedEvent() {
        
        socket?.on(NotificationType.emergencyPackageAssignedKey.rawValue) { (dataArray, ack) in
            print("Socket Event: Emergency Package Assigned \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    self.delegate?.didReceiveEmergencyPackageAssignedEvent()
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeBackupSpArrivedEvent() {
        
        socket?.on(NotificationType.backupSpArrivedKey.rawValue) { (dataArray, ack) in
            print("Socket Event: Backup SP Arrived Event \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    self.delegate?.didReceiveBackupSpArrivedEvent()
                    let resource = ["resource":["packageId": data.packageId, "message": data.message], "type": NotificationType.backupSpArrivedKey.rawValue] as [String : Any]
                    let userInfo = ["aps":resource]
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.backupSpArrivedKey.rawValue, userInfo: userInfo)
                }
            }
        }
    }

    func observeBackupSpConfirmPickupEvent() {
        
        socket?.on(NotificationType.backupSpConfirmedPickupKey.rawValue) { (dataArray, ack) in
            print("Socket Event:  Backup SP Confirm Pickup \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    self.delegate?.didReceiveBackupSpConfirmPickupEvent()
                    let resource = ["resource":["packageId": data.packageId, "message": data.message], "type": NotificationType.backupSpConfirmedPickupKey.rawValue] as [String : Any]
                    let userInfo = ["aps":resource]
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.backupSpConfirmedPickupKey.rawValue, userInfo: userInfo)
                }
            }
        }
    }
    
    func observeNewMessageEvent() {
        
        socket?.on(NotificationType.newMessage.rawValue) { (dataArray, ack) in
            print("Socket Event: New Message \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<SocketMessage>().map(JSONObject: socketData) {
                    self.delegate?.didReceiveNewMessage(message: data.message)
                    
                    if data.message.senderType == SenderType.user.rawValue {
                        let resource = ["resource":["packageId": data.message.packageId, "status": data.message.packageStatus, "message": data.message.body], "type": NotificationType.newMessage.rawValue] as [String : Any]
                        let userInfo = ["aps":resource]
                        
                        Utility.showInAppNotification(title:"", message: data.message.title, identifier: NotificationType.newMessage.rawValue, userInfo: userInfo)
                    }
                }
            }
        }
    }
    
    func sendMessage(message: String, jobId: Int, reciverId: Int) {
        
        let data = ["messageText": message, "packageId": jobId, "senderUserType": "sp", "receiverUserType": "user", "senderUserId": Driver.shared.id, "receiverUserId": reciverId] as [String : AnyObject]
        
        socket?.emitWithAck(NotificationType.messageSendingKey.rawValue, data).timingOut(after: 1) {ack in
            print("Chat Message Sent")
            
            if ack.count > 0 {
                
                if let ackn = ack[0] as? NSDictionary {
                    
                    if let data = Mapper<SocketMessage>().map(JSONObject: ackn) {
                        print(data)
                        self.delegate?.didReceiveNewMessage(message: data.message)
                        if data.message.senderType == SenderType.user.rawValue {
                            Utility.showInAppNotification(title: "", message: data.message.title, identifier: NotificationType.generalNotifications.rawValue)
                        }
                    }
                }
            }
        }
    }
    
    func markMessageAsRead(messageId: Int) {
        socket?.emit(NotificationType.messageDeliveredKey.rawValue,  ["id": messageId])
    }
    
    func markNotificationAsRead(notificationId: Int) {
        socket?.emit(NotificationType.readNotificationKey.rawValue,  ["notificationId": notificationId])
    }
    
    func markUnretdPackageAsRated(packageId: Int) {
        socket?.emit(NotificationType.ratingReminderReceivedKey.rawValue,  ["packageId": packageId])
    }
    
    func observeAccountApprovedEvent() {
        
        socket?.on(NotificationType.accountApproved.rawValue) { (dataArray, ack) in
            print("Socket Event: Account Approved \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeAccountRejectedEvent() {
        
        socket?.on(NotificationType.accountRejected.rawValue) { (dataArray, ack) in
            print("Socket Event: Account Rejected \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeAccountBlockedEvent() {
        
        socket?.on(NotificationType.accountBlocked.rawValue) { (dataArray, ack) in
            print("Socket Event: Account Blocked \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeAccountUnBlockedEvent() {
        
        socket?.on(NotificationType.accountUnBlocked.rawValue) { (dataArray, ack) in
            print("Socket Event: Account Un Blocked \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeDriversExpiredLicenseEvent() {
        
        socket?.on(NotificationType.driversExpiredLicense.rawValue) { (dataArray, ack) in
            print("Socket Event: Drivers Expired License \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeDriversInspectionNoteExpiredEvent() {
        
        socket?.on(NotificationType.driversInspectionNoteExpired.rawValue) { (dataArray, ack) in
            print("Socket Event: Drivers InspectionNote Expired \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeDriversExpireInsuranceEvent() {
        
        socket?.on(NotificationType.driversExpireInsurance.rawValue) { (dataArray, ack) in
            print("Socket Event: Drivers Expire Insurance \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeCustomNotificationEvent() {
        
        socket?.on(NotificationType.customNotification.rawValue) { (dataArray, ack) in
            print("Socket Event: Custom Notification \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeAdminAssignedDriverEvent() {
        
        socket?.on(NotificationType.adminAssignedDriver.rawValue) { (dataArray, ack) in
            print("Socket Event: Admin Assigned Driver \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                self.delegate?.didReceiveAdminAssignedDriverEvent()
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeDocumentsSetForExpiryEvent() {
        
        socket?.on(NotificationType.documentsSetFOrExpiry.rawValue) { (dataArray, ack) in
            print("Socket Event: documentsSetFOrExpiry \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                self.delegate?.didReceiveDocumentsSetForExpiryEvent()
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeOfferAssignToOtherEvent() {
        
        socket?.on(NotificationType.offerAssignToOther.rawValue) { (dataArray, ack) in
            print("Socket Event: offerAssignToOther \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    self.delegate?.didReceiveOfferAssignToAnotherEvent(packageId: data.packageId)
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.generalNotifications.rawValue)
                }
            }
        }
    }
    
    func observeUnblockPackageEvent() {
        
        socket?.on(NotificationType.unblockPackage.rawValue) { (dataArray, ack) in
            print("Socket Event: unblockPackage \(dataArray[0])")
            
            if let event = dataArray[0] as? NSDictionary, let socketData = event[kSocketKey] as? NSDictionary {
                
                if let data = Mapper<NotificationsData>().map(JSONObject: socketData) {
                    self.delegate?.didReceiveUnblockPackageEvent()
                    Utility.showInAppNotification(title: "", message: data.message, identifier: NotificationType.unblockPackage.rawValue)
                }
            }
        }
    }
    
    
    func updateLocation(currentLocation: CLLocationCoordinate2D) {
        
        if currentLocation.latitude == 0 || currentLocation.longitude == 0 {
            return
        }
        
        var bearing = 0.0
        
        bearing = Utility.findBearingAngle(pointA: Driver.shared.lastLocation, pointB: currentLocation)
        Driver.shared.lastLocation = currentLocation
        
        let coordinatesDict = ["latitude": currentLocation.latitude, "longitude": currentLocation.longitude, "bearing": bearing]
        
        if !APIClient.shared.isConnectedToInternet { // if internet is not connected then store coordinates locally
            Driver.shared.coordinatesArray.append(coordinatesDict)
            
            if socket?.status == .connected || socket?.status == .connecting {
                self.resetSocket()
            }
            
            return
        }
        
        if socket?.status != .connected && !isConnectingSocket {
            self.establishConnection()
        }
        
        if socket?.status != .connected {
            return
        }
        
        Driver.shared.coordinatesArray.append(coordinatesDict)
        let data = ["coordinates": Driver.shared.coordinatesArray]
        print(data)
        socket?.emitWithAck(kLocationUpdate, data).timingOut(after: 1) {ack in
            print("Location Sent to server")
            self.showConnectionMessage(message: "Location Sent to server")
            
            if ack.count > 0 {
                
                if let ackn = ack[0] as? NSDictionary {
                    
                    if let socketData = ackn[kSocketKey] as? NSDictionary {
                        
                        if let _ = Mapper<SocketMessage>().map(JSONObject: socketData) {
                            Driver.shared.coordinatesArray = []
                            print(socketData)
                        }
                    }
                }
            }
        }
    }
    
    func sendLocationToServer() {
        
        if Driver.shared.coordinatesArray.count == 0 {
            return
        }
        
        let data = ["coordinates": Driver.shared.coordinatesArray]
        print(data)
        socket?.emitWithAck(kLocationUpdate, data).timingOut(after: 1) {ack in
            print("Location Sent to server")
            self.showConnectionMessage(message: "Location Sent to server from controller")
            
            if ack.count > 0 {
                
                if let ackn = ack[0] as? NSDictionary {
                    
                    if let socketData = ackn[kSocketKey] as? NSDictionary {
                        
                        if let _ = Mapper<SocketMessage>().map(JSONObject: socketData) {
                            Driver.shared.coordinatesArray = []
                            print(socketData)
                        }
                    }
                }
            }
        }
    }
    
    func showConnectionMessage(message: String) {
//        let visibleNavController = Utility.getVisibleViewController(appDelegate?.window?.rootViewController)
//        let topController = (visibleNavController?.topMostViewController())!
//        NSError.showErrorWithMessage(message: message, viewController: topController)
    }
}
