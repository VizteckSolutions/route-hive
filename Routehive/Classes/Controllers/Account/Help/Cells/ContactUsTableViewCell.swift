//
//  ContactUsTableViewCell.swift
//  Routehive
//
//  Created by Mac on 02/11/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class ContactUsTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> ContactUsTableViewCell {
        let kContactUsTableViewCellIdentifier = "kContactUsTableViewCellIdentifier"
        tableView.register(UINib(nibName: "ContactUsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kContactUsTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kContactUsTableViewCellIdentifier) as! ContactUsTableViewCell
        return cell
    }
}
