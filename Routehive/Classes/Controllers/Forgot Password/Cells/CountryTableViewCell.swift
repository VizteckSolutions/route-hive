//
//  CountryTableViewCell.swift
//  Routehive
//
//  Created by Huzaifa on 10/12/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var flageImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> CountryTableViewCell {
        let kCountryTableViewCellIdentifier = "kCountryTableViewCellIdentifier"
        tableView.register(UINib(nibName: "CountryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kCountryTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kCountryTableViewCellIdentifier) as! CountryTableViewCell
        return cell
    }
}
