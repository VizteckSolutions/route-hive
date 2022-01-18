//
//  OfferSubmittedTableViewCell.swift
//  Routehive
//
//  Created by Huzaifa on 9/28/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class OfferSubmittedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var offerSubmittedLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> OfferSubmittedTableViewCell {
        let kOfferSubmittedTableViewCellIdentifier = "kOfferSubmittedTableViewCellIdentifier"
        tableView.register(UINib(nibName: "OfferSubmittedTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kOfferSubmittedTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kOfferSubmittedTableViewCellIdentifier) as! OfferSubmittedTableViewCell
        return cell
    }
}
