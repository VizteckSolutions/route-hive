//
//  ItemsTableViewCell.swift
//  Routehive
//
//  Created by Huzaifa on 9/27/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import AlamofireImage

class ItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var dotsView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var itemDetailLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> ItemsTableViewCell {
        let kItemsTableViewCellIdentifier = "kItemsTableViewCellIdentifier"
        tableView.register(UINib(nibName: "ItemsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kItemsTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kItemsTableViewCellIdentifier) as! ItemsTableViewCell
        return cell
    }
    
    func configureCell(data: Package, indexPath: IndexPath, localizable: LocalizedKeys) {
        itemDetailLabel.text = data.packageLocations[indexPath.section - 1].items[indexPath.row - 1].name
        itemQuantityLabel.text = data.packageLocations[indexPath.section - 1].items[indexPath.row - 1].packageSize + " - \(localizable.quantityLabel): " + String(data.packageLocations[indexPath.section - 1].items[indexPath.row - 1].quantity)
        
//        priceLabel.text = "\(localizable.itemValLabel)\(data.packageLocations[indexPath.section - 1].items[indexPath.row - 1].estimatedPrice)"
        
//        priceLabel.text = localizable.itemValLabel + "\(data.currency) " + String(format: "%.2f", data.packageLocations[indexPath.section - 1].items[indexPath.row - 1].estimatedPrice)
        
        data.packageLocations[indexPath.section - 1].items[indexPath.row - 1].image = data.packageLocations[indexPath.section - 1].items[indexPath.row - 1].image.replacingOccurrences(of: "1000X1000", with: "300X300")
        
        if let url = URL(string: data.packageLocations[indexPath.section - 1].items[indexPath.row - 1].image) {
            profileImageView.setImage(inTableCell: self, withUrl: url, placeholder: nil)
        }
        
        if indexPath.section == data.packageLocations.count {
            dotsView.isHidden = true
            
        } else {
            dotsView.isHidden = false
        }
    }
}
