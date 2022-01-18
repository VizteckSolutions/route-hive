//
//  LocationCellTableViewCell.swift
//  Roadroo
//
//  Created by zaid on 11/09/2017.
//  Copyright © 2017 Vizteck. All rights reserved.
//

import UIKit

class LocationCellTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var secondaryAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        addressLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //addressLabel.font = UIFont.appThemeSemiBoldFontWithSize(15.0)
        addressLabel.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> LocationCellTableViewCell {
        let kLocationCellTableViewCell = "kLocationCellTableViewCellIdentifier"
        tableView.register(UINib(nibName:"LocationCellTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kLocationCellTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kLocationCellTableViewCell, for: indexPath) as! LocationCellTableViewCell
        return cell
    }
}
