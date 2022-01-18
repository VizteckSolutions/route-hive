//
//  AccountTopTableViewCell.swift
//  Duty
//
//  Created by Huzaifa on 9/3/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import Cosmos

class AccountTopTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var totalJosLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var vehicleDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> AccountTopTableViewCell {
        let kAccountTopTableViewCellIdentifier = "kAccountTopTableViewCellIdentifier"
        tableView.register(UINib(nibName: "AccountTopTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kAccountTopTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kAccountTopTableViewCellIdentifier) as! AccountTopTableViewCell
        return cell
    }
}
