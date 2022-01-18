//
//  NotificationTableViewCell.swift
//  Routehive
//
//  Created by Huzaifa on 9/19/18.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var notificationDetailLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> NotificationTableViewCell {
        let kNotificationTableViewCellIdentifier = "kNotificationTableViewCellIdentifier"
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kNotificationTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kNotificationTableViewCellIdentifier) as! NotificationTableViewCell
        return cell
    }
}
