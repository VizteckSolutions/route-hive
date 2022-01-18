//
//  Earnings.swift
//  Routehive
//
//  Created by Mac on 05/11/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import Foundation
import ObjectMapper

typealias WeeklyEarningsCompletionHandler = (_ result: WeeklyEarnings, _ error: NSError?) -> Void
typealias WeeksCompletionHandler = (_ result: Weeks, _ error: NSError?) -> Void
typealias WeeklyTransactionsCompletionHandler = (_ result: WeeklyTransactions, _ error: NSError?) -> Void



class WeeklyEarnings: Mappable {
    
    var weekDayEarnings = [WeekDaysEarning]()
    var spEarnedAmount: Double = 0.0
    var currency = ""
    var totalJobCount: Int = 0
    var weekTitle = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        weekDayEarnings     <- map["weekDaysEarning"]
        spEarnedAmount      <- map["totalEarnings"]
        currency            <- map["currency"]
        totalJobCount       <- map["totalJobs"]
        weekTitle           <- map["weekTitle"]
    }
    
    func getEarnings(viewController: UIViewController, weekNumber: Int, year: Int, completionBlock: @escaping WeeklyEarningsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.getEarnings(weekNumber: weekNumber, weekYear: year) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<WeeklyEarnings>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}

class WeekDaysEarning: Mappable {
    
    var day: Int = 0
    var spEarning: Double = 0.0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        day             <- map["day"]
        spEarning       <- map["spDailyEarning"]
    }
}

class Weeks: Mappable {
    
    var weeks = [Week]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        weeks           <- map["weeksList"]
    }
    
    func getWeeksListing(viewController: UIViewController, completionBlock: @escaping WeeksCompletionHandler) {
        Utility.showLoading(viewController: viewController)

        APIClient.shared.getWeekList { (result, error) in
            Utility.hideLoading(viewController: viewController)

            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)

            } else {

                if let data = Mapper<Weeks>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}

class Week: Mappable {
    
    var title = ""
    var weekNumber: Int = 0
    var weekYear: Int = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        title           <- map["title"]
        weekNumber      <- map["weekNumber"]
        weekYear        <- map["weekYear"]
    }
}

class WeeklyTransactions: Mappable {
    
    var weeklyTransactions = [WeekTransaction]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        weeklyTransactions       <- map["spJobsFound"]
    }
    
    func getEarnings(viewController: UIViewController, weekNumber: Int, year: Int, completionBlock: @escaping WeeklyTransactionsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.getWeeklyTransactions(weekNumber: weekNumber, weekYear: year) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<WeeklyTransactions>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}

class WeekTransaction: Mappable {
    
    var spEarnings: Double = 0.0
    var packageId: Int = 0
    var endTime: Double = 0
    var currency = ""
    var distanceUnit = ""
    var estimatedDistance: Int = 0
    var pickupAddress = ""
    var dropoffAddress = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        spEarnings          <- map["spEarnings"]
        packageId           <- map["packageId"]
        endTime             <- map["endTime"]
        currency            <- map["currency"]
        estimatedDistance   <- map["estimatedDistance"]
        distanceUnit        <- map["distanceUnit"]
        pickupAddress       <- map["pickupAddress"]
        dropoffAddress      <- map["dropoffAddress"]
    }
}
