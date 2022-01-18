//
//  LanguageTableViewCell.swift
//  Routehive
//
//  Created by Mac on 19/09/2018.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func cellForTableView(tableView: UITableView) -> LanguageTableViewCell {
        let kLanguageTableViewCellIdentifier = "kLanguageTableViewCell"
        tableView.register(UINib(nibName: "LanguageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kLanguageTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kLanguageTableViewCellIdentifier) as! LanguageTableViewCell
        return cell
    }
}
