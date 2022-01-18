//
//  ContactUsTopTableViewCell.swift
//  Routehive
//
//  Created by Mac on 02/11/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class ContactUsTopTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> ContactUsTopTableViewCell {
        let kContactUsTopTableViewCellIdentifier = "kContactUsTopTableViewCellIdentifier"
        tableView.register(UINib(nibName: "ContactUsTopTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kContactUsTopTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kContactUsTopTableViewCellIdentifier) as! ContactUsTopTableViewCell
        return cell
    }
}
