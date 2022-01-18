//
//  ChangeLanguageTableViewCell.swift
//  Routehive
//
//  Created by Huzaifa on 9/26/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class ChangeLanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> ChangeLanguageTableViewCell {
        let kChangeLanguageTableViewCellIdentifier = "kChangeLanguageTableViewCellIdentifier"
        tableView.register(UINib(nibName: "ChangeLanguageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kChangeLanguageTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kChangeLanguageTableViewCellIdentifier) as! ChangeLanguageTableViewCell
        return cell
    }
}
