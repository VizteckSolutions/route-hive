//
//  AccountTableViewCell.swift
//  Duty
//
//  Created by Huzaifa on 9/3/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var accountImageView: UIImageView!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var accountTitleLable: UILabel!
    
    @IBOutlet weak var accountViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountViewBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> AccountTableViewCell {
        let kAccountTableViewCellIdentifier = "kAccountTableViewCellIdentifier"
        tableView.register(UINib(nibName: "AccountTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kAccountTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kAccountTableViewCellIdentifier) as! AccountTableViewCell
        return cell
    }
}
