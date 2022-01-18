//
//  Route.swift
//  Runnahs
//
//  Created by Zeeshan@Vizteck on 12/06/2018.
//  Copyright © 2018 vizteck. All rights reserved.
//

import Foundation
import ObjectMapper

class Route: Mappable {
    
    var routes = [Routes]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        routes                <- map["routes"]
    }
}

class Routes: Mappable {
    
    var legs = [Legs]()
    var polyline = Mapper<Polyline>().map(JSON: [:])!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        legs                <- map["legs"]
        polyline            <- map["overview_polyline"]
    }
}

class Legs: Mappable {
    
    var text = ""
    var value = 0.0
    var durationText = ""
    var durationValue = 0.0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        text                <- map["distance.text"]
        value               <- map["distance.value"]
        durationText        <- map["duration.text"]
        durationValue       <- map["duration.value"]
    }
}

class Polyline: Mappable {
    
    var points = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        points                <- map["points"]
    }
}

class TimeZoneData: Mappable {
    
    var dstOffset = 0
    var rawOffset = 0
    var status = ""
    var timeZoneId = ""
    var timeZoneName = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        dstOffset           <- map["dstOffset"]
        rawOffset           <- map["rawOffset"]
        status              <- map["status"]
        timeZoneId          <- map["timeZoneId"]
        timeZoneName        <- map["timeZoneName"]
    }
}
