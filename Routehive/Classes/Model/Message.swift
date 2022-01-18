//
//  Message.swift
//  Labour Choice
//
//  Created by Umair on 10/07/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import Foundation
import ObjectMapper

class Messages: Mappable {

    var messages = [Message]()
    var badgeValue: Int = 0
    var totalParticipant: Int = 0
    var totalMessages: Int = 0

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        messages                <- map["getMessages"]
        badgeValue              <- map["unReadMessagesCount"]
        totalParticipant        <- map["totalParticipant"]
        totalMessages           <- map["messageCount"]
        postMapping()
    }

    func postMapping() {
        // Reverse the array
        // messages = messages.reversed()
    }
}

class Message : NSObject, Mappable {

    var id = 0
    var createdAt: CGFloat = 1518155443
    var isRead = false
    var body = ""
    var title = ""
    var senderId = 0
    var userId = 0
    var formattedDate = ""
    var senderType = 0
    var receiverType = 0
    var packageId = 0
    var packageStatus: Int = 0
    
    var updatedAt = ""
    var createdAtString = ""
    var jobId = 0
    var threadId = ""
    var messageType = ""
    var senderName = ""
    var senderImageUrl = ""
    var profileImage = #imageLiteral(resourceName: "icon_default_image")
    //var helper = Mapper<MMUser>().map(JSON: [:])!

    let dateFormatter = DateFormatter()

    required init?(map: Map) {
        dateFormatter.dateFormat = "MMM d, h:mm a"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
    }

    func mapping(map: Map) {
        id                      <- map["id"]
        senderId                <- map["spAccountId"]
        userId                  <- map["userAccountId"]
        createdAt               <- map["createdAt"]
        body                    <- map["message"]
        isRead                  <- map["isRead"]
        formattedDate           <- map["timePassed"]
        senderType              <- map["senderType"]
        receiverType            <- map["receiverType"]
        packageId               <- map["packageId"]
        packageStatus           <- map["status"]
        title                   <- map["title"]
        
        createdAtString         <- map["createdAtString"]
        updatedAt               <- map["updatedAt"]
        jobId                   <- map["jobId"]
        threadId                <- map["threadId"]
        messageType             <- map["messageType"]
        senderImageUrl          <- map["senderImage"]
        senderName              <- map["senderName"]
        
//        postMapping()
    }

    func postMapping() {

        if let x = Double("\(createdAt)") {
            formattedDate = timeStringFromUnixTime(unixTime: x)
        }
    }

    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)

        // Returns date formatted as 12 hour time.
        return dateFormatter.string(from: date)
    }
}

class SocketMessage: Mappable {

    var message = Mapper<Message>().map(JSON: [:])!

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        message         <- map["resource"]
    }
}

