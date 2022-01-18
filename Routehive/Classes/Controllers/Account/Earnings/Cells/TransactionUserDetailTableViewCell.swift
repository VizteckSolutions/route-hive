//
//  TransactionUserDetailTableViewCell.swift
//  Routehive
//
//  Created by Mac on 05/11/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import Cosmos
import AlamofireImage

protocol TransactionUserDetailTableViewCellDelegate {
    func didTappedRateUserButton()
}

class TransactionUserDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRatingView: CosmosView!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var yourEarningLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var rateUserButton: UIButton!
    
    var delegate: TransactionUserDetailTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> TransactionUserDetailTableViewCell {
        let kTransactionUserDetailTableViewCellIdentifier = "kTransactionUserDetailTableViewCellIdentifier"
        tableView.register(UINib(nibName: "TransactionUserDetailTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kTransactionUserDetailTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kTransactionUserDetailTableViewCellIdentifier) as! TransactionUserDetailTableViewCell
        return cell
    }
    
    func configureCell(data: Package) {
        userNameLabel.text = data.userData.firstName.capitalized + " " + data.userData.lastName.capitalized
        userRatingLabel.text = String(format: "%.1f", data.userData.avgRating)
        userRatingView.rating = data.userData.avgRating
        
        if let imageUrl = URL(string: data.userData.profileImage) {
            let filter = AspectScaledToFillSizeFilter(size: profileImageView.frame.size)
            profileImageView.af_setImage(withURL: imageUrl, placeholderImage: nil, filter: filter)
        }
        
        amountLabel.text = data.currency + " " + String(format: "%.2f", data.spEarnings)
        
        if data.isRatedBySP {
            rateUserButton.isHidden = true
            
        } else {
            rateUserButton.isHidden = true
        }
//        distanceLabel.text = String(format: "(%.1f %@)",
    }
    
    @IBAction func rateUserButtonTapped(_ sender: Any) {
        delegate?.didTappedRateUserButton()
    }
}
