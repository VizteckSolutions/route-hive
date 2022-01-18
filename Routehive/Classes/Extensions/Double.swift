//
//  Double.swift
//  PamperMoi
//
//  Created by Umair Afzal on 22/03/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import Foundation

extension Double {

    func timeStringFromUnixTime(dateFormatter: DateFormatter, deviderValue: Double = 1) -> String {
//        dateFormatter.locale = NSLocale.current
        let date = Date(timeIntervalSince1970: self/deviderValue)
        return dateFormatter.string(from: date)
    }

    func toString() -> String {
        return String(self)
    }
    
    func cleanFloatingPoints() -> Double {
        let val = self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
        return Double(val) ?? 0
    }
}
