//
//  Languages.swift
//  Routehive
//
//  Created by Mac on 12/10/2018.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

typealias LanguagesCompletionHandler = (_ result: Languages, _ error: NSError?) -> Void

class Languages: Mappable {
    
    var languages = [LanguageListing]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        languages           <- map["languages"]
    }
    
    func fetchLanguages(viewController: UIViewController, completionBlock: @escaping LanguagesCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.fetchAvailableLanguages { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<Languages>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}

class LanguageListing: Mappable {
    
    var id: Int = 0
    var code = ""
    var name = ""
    var label = ""
    var isRTL = false
    var status: Int = 0
    var lastUpdatedAt: Double = 0.0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        code            <- map["code"]
        name            <- map["name"]
        label           <- map["label"]
        isRTL           <- map["isRTL"]
        status          <- map["status"]
        lastUpdatedAt   <- map["lastUpdatedAt"]
    }
}
