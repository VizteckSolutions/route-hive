//
//  JobTableViewCell.swift
//  BoonDesign
//
//  Created by Zeshan on 26/09/2018.
//  Copyright © 2018 vizteck. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var earningLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var dropoffAddressLabel: UILabel!
    
    @IBOutlet weak var pickupTimeImageView: UIImageView!
    @IBOutlet weak var pickupTimeLabel: UILabel!
    @IBOutlet weak var pickupTimeStackView: UIStackView!
    
    @IBOutlet weak var itemSizeImageView: UIImageView!
    @IBOutlet weak var itemSizeLabel: UILabel!
    @IBOutlet weak var itemSizeStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> JobTableViewCell {
        let kJobTableViewCellIdentifier = "kJobTableViewCellIdentifier"
        tableView.register(UINib(nibName: "JobTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kJobTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kJobTableViewCellIdentifier) as! JobTableViewCell
        return cell
    }
}
