//
//  VTConstants.swift
//  passManager
//
//  Created by Umair on 6/19/17.
//  Copyright © 2017 Umair. All rights reserved.
//

import Foundation
import UIKit

enum TabBarModules: Int {
    case availableJobs = 0
    case myJobs
    case notifications
    case account
}

enum TabBarModuleName: String {
    case AvailableJobs
    case MyJobs
    case Notifications
    case Account
}

enum UploadImageType: String {
    case profileImage
    case vehicleDocumentsImages
    case identityDocumentsImages
    case dropOffCode
}

enum EarningTimeInterval: Int  {
    case weekly = 0
    case monthly
    case yearly
}

enum MainServicesType: Int {
    case massage = 0
    case facial
    case hair
    case makeup
}

enum VTMessageType: Int {
    case error = 0
    case success
    case info
}

enum Genders: String {
    case MALE = "MALE"
    case FEMALE = "FEMALE"
    case male = "male"
    case female = "female"
}

enum BadgePosition: String {
    case topRight
    case topLeft
    case right
    case left
    case top
    case bottom
    case bottomRight
    case bottomLeft
}

enum JobStatus: Int {
    case accepted = 2
    case arriving = 3
    case inProgress = 4
    case completed = 5
    case cancelled = 6
}

enum FontTypeface : String{
    case bold
    case semiBold
    case medium
    case regular
    case seventSegment
    case systemRegular
}

enum ShortcutItems: String {
    case myPackages
    case notifications
    case earnings
    case changeLanguage
}

enum LeftMenu: Int {
    case profile = 0
    case sendItems
    case myPacakges
    case notifications
    case myProfile
    case help
    case language
    case share
    case logout
}

enum TableViewAnimationType: String {
    case fromLeft
    case fromRight
    case fromBottom
    case fromTop
    case scaleFromTop
}

enum PickupDropoffType: String {
    case pickup = "arrive"
    case dropoff = "reach"
}

enum ConfirmType: String {
    case pickup = "pickup"
    case dropoff = "dropoff"
}

enum WebViewType: String {
    case userGuide = "userGuide"
    case faqs = "faqs"
    case termsConditions = "termsConditions"
    case privacyPolicy = "privacyPolicy"
}

enum SenderType: Int {
    case sp = 1
    case user = 2
}

enum CountryType: String {
    case Indonesia = "Indonesia"
    case Malaysia = "Malaysia"
}


let kSocketUrl = "Paste your url here"
var kBaseUrl = "Paste your url here"

let kGoogleMapsKey = "Paste your google key here"
let kUserGuideUrl = "Paste your url here"
let kFaqsUrl = "Paste your url here"
let kTermsAndConditionsUrl = "Paste your google url here"
let kPrivacyPolicy = "Paste your google url here"


let kpersistentContainor = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
let kManagedContext = kpersistentContainor.viewContext
let kWindow = (UIApplication.shared.delegate as! AppDelegate).window
let kIsUserLoggedIn = "kIsUserLoggedIn"

let kLocationUpdate = "updateLocation"
let kJobAddress = "kJobAddress"
let kShouldLoadRejectJobData = "kShouldLoadRejectJobData"
let kLat = "KLat"
let KLong = "KLong"
let kDuration = "KDuration"
let kDescription = "kDescription"
let kStartTime = "kStartTime"
let kUserFirstName = "kUserFirstName"
let kUserLastName = "kUserLastName"
let kUserEmail = "kUserEmail"
let kUserId = "kUserId"
let kUserMobile = "kUserMobile"
let kUserProfileImageUrl = "kUserProfileImageUrl"
let kIsCardInfoAdded = "kIsCardInfoAdded"

let kSPName = "kSPName"
let kSPFirstName = "kSPFirstName"
let kSPLastName = "kSPLastName"
let kSPEmail = "kSPEmail"
let kSPId = "kSPId"
let kSPMobile = "kSPMobile"
let kSPMobilecode = "kSMobilecode"
let kSPProfileImageUrl = "kSPProfileImageUrl"
let kSPIsBlocked = "kSPIsBlocked"
let kSPIsEmailUpdate = "kSPIsEmailUpdate"
let kIsDriverOnline = "kIsDriverOnline"
let kAvgRating = "kAvgRating"
let kJobsDoneCount = "kJobsDoneCount"
let kReferralCode = "kReferralCode"
let kVehicleName = "kVehicleName"
let kVehiclePlateNumber = "kVehiclePlateNumber"
let kCountryName = "kCountryName"

let kLanguageCode = "kLanguageCode"
let kLastLanguageUpdatedTime = "kLastLanguageUpdatedTime"

// NSNotification

enum NotificationType: String {
    case newPackagePosted = "newPackagePosted"
    case userAcceptedOffer = "userAcceptedOffer"
    case userCancelledPackage = "userCancelledPackage"
    case packageOfferCancelled = "packageOfferCancelled"
    case newMessage = "messageSendingToReceiverKey"
    case generalNotifications = "generalNotifications"
    case messageSendingKey = "messageSendingKey"
    case messageDeliveredKey = "messageDeliveredKey"
    case spSwappedKey = "spSwapped"
    case emergencyPackageAssignedKey = "emergencyPackageAssigned"
    case backupSpArrivedKey = "backupSPArrived"
    case backupSpConfirmedPickupKey = "backupSPConfirmedPickup"
    case readNotificationKey = "readNotification"
    case ratingReminderReceivedKey = "ratingReminderReceived"
    
    case accountApproved = "accountApproved"
    case accountRejected = "accountRejected"
    case accountBlocked = "accountBlocked"
    case accountUnBlocked = "accountUnBlocked"
    case driversExpiredLicense = "driversExpiredLicense"
    case driversInspectionNoteExpired = "driversInspectionNoteExpired"
    case driversExpireInsurance = "driversExpireInsurance"
    case customNotification = "customNotification"
    case adminAssignedDriver = "adminAssignedDriver"
    case documentsSetFOrExpiry = "documentsSetFOrExpiry"
    case offerAssignToOther = "offerAssignToOther"
    case unblockPackage = "unblockPackage"
}

let kNewMessagePush = "Your received a message on "
let kErrorSessionExpired = "User is not authenticated."

let kNoMessageImage = "no_msg"
let kSocketKey = "socket"

let kCornerRadius : CGFloat = 2.0
var kOffSet = 10
let kLocation = "location"
let kSavedCookies = "savedCookies"

let points = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ"]
