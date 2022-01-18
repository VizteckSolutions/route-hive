//
//  WeekListingTableViewCell.swift
//  TT-Driver
//
//  Created by Umair Afzal on 02/08/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class WeekListingTableViewCell: UITableViewCell {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var earningLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> WeekListingTableViewCell {
        let kWeekListingTableViewCellIdentifier = "kWeekListingTableViewCellIdentifier"
        tableView.register(UINib(nibName: "WeekListingTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kWeekListingTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kWeekListingTableViewCellIdentifier, for: indexPath) as! WeekListingTableViewCell
        return cell
    }
}
