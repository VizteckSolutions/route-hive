//
//  CountryList.swift
//  TaxiTaxi
//
//  Created by Umair Afzal on 19/06/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import Foundation
import ObjectMapper

typealias CountryListCompletionHandler = (_ result: CountryList, _ error: NSError?) -> Void

class CountryList: Mappable {

    var countries = [Country]()

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        countries          <- map["countryList"]
    }

    func loadData(viewController: UIViewController, completionBlock: @escaping CountryListCompletionHandler) {
        Utility.showLoading(viewController: viewController)

        APIClient.shared.getCountryCode { (result, error) in
            Utility.hideLoading(viewController: viewController)

            if error != nil {
                error?.showErrorBelowNavigation(viewController: viewController)
                completionBlock(self, error)

            } else {

                if let data = Mapper<CountryList>().map(JSONObject: result) {
                    completionBlock(data, nil)
                }
            }
        }
    }
}

class Country: Mappable {
    
    var code = ""
    var name = ""
    var imageUrl = ""
    var numberLength = 0

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        code            <- map["code"]
        name            <- map["country"]
        imageUrl        <- map["flag"]
        numberLength    <- map["numberLength"]
    }
}
