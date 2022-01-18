//
//  CancelJob.swift
// Routehive
//
//  Created by Mac on 25/10/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import Foundation
import ObjectMapper

typealias CancellationReasonsCompletionHandler = (_ result: CancellationReasons, _ error: NSError?) -> Void

class CancellationReasons: Mappable {
    
    var reasons = [Reasons]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        reasons           <- map["reasonsList"]
    }
    
    func fetchCancellationReasons(viewController: UIViewController, completionBlock: @escaping CancellationReasonsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.fetchCancellationReasons { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<CancellationReasons>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
    
    func CancelJob(viewController: UIViewController, packageId: Int, reasonId: Int, reason: String, isOther: Bool, completionBlock: @escaping CancellationReasonsCompletionHandler) {
        Utility.showLoading(viewController: viewController)
        
        APIClient.shared.CancelJob(WithPackageId: packageId, reasonId: reasonId, reason: reason, isOther: isOther) { (result, error) in
            Utility.hideLoading(viewController: viewController)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)
                
            } else {
                
                if let data = Mapper<CancellationReasons>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}

class Reasons: Mappable {
    
    var id: Int = 0
    var text = ""
    var isSelected = false
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        text            <- map["text"]
    }
}
