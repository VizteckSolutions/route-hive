//
//  AvailableJobsDetailAddressTableViewCell.swift
//  Routehive
//
//  Created by Huzaifa on 9/28/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class AvailableJobsDetailAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dotsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> AvailableJobsDetailAddressTableViewCell {
        let kAvailableJobsDetailAddressTableViewCellIdentifier = "kAvailableJobsDetailAddressTableViewCellIdentifier"
        tableView.register(UINib(nibName: "AvailableJobsDetailAddressTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kAvailableJobsDetailAddressTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kAvailableJobsDetailAddressTableViewCellIdentifier) as! AvailableJobsDetailAddressTableViewCell
        return cell
    }
}
