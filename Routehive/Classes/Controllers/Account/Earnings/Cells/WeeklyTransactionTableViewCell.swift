//
//  WeeklyTransactionTableViewCell.swift
//  Routehive
//
//  Created by Huzaifa on 10/12/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class WeeklyTransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var earningLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var dropoffAddressLabel: UILabel!
    
    @IBOutlet weak var pickupTimeImageView: UIImageView!
    @IBOutlet weak var pickupTimeLabel: UILabel!
    @IBOutlet weak var pickupTimeStackView: UIStackView!
    
    var dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormatter.dateFormat = "h:mm a, d MMM"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> WeeklyTransactionTableViewCell {
        let kWeeklyTransactionTableViewCellIdentifier = "kWeeklyTransactionTableViewCellIdentifier"
        tableView.register(UINib(nibName: "WeeklyTransactionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kWeeklyTransactionTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kWeeklyTransactionTableViewCellIdentifier) as! WeeklyTransactionTableViewCell
        return cell
    }
    
    func configureCell(data: WeekTransaction) {
        earningLabel.text = data.currency + String(format: " %.2f", data.spEarnings)
        distanceLabel.text = "(\(data.estimatedDistance) \(data.distanceUnit))"
        pickupAddressLabel.text = data.pickupAddress
        dropoffAddressLabel.text = data.dropoffAddress
        pickupTimeLabel.text = data.endTime.timeStringFromUnixTime(dateFormatter: dateFormatter)
    }
}
