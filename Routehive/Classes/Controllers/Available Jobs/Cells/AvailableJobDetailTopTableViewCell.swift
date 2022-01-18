//
//  AvailableJobDetailTopTableViewCell.swift
//  Routehive
//
//  Created by Huzaifa on 9/28/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import Cosmos
import AlamofireImage

protocol AvailableJobDetailTopTableViewCellDelegate {
    func didTappedMessageButton()
}

class AvailableJobDetailTopTableViewCell: UITableViewCell {

    @IBOutlet weak var jobPostedByLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRatingView: CosmosView!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pickupTimeStackView: UIStackView!
    @IBOutlet weak var pickupTimeLabel: UILabel!
    @IBOutlet weak var pickupTimeImageView: UIImageView!
    @IBOutlet weak var itemSizeLabel: UILabel!
    @IBOutlet weak var itemSizeImageView: UIImageView!
    @IBOutlet weak var itemSizeStackView: UIStackView!
    
    @IBOutlet weak var messageCountLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    
    var delegate: AvailableJobDetailTopTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> AvailableJobDetailTopTableViewCell {
        let kAvailableJobDetailTopTableViewCellIdentifier = "kAvailableJobDetailTopTableViewCellIdentifier"
        tableView.register(UINib(nibName: "AvailableJobDetailTopTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kAvailableJobDetailTopTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kAvailableJobDetailTopTableViewCellIdentifier) as! AvailableJobDetailTopTableViewCell
        return cell
    }
    
    func configureCell(data: Package) {
        amountLabel.text = data.currency + " " + String(format: "%.2f", data.spEarnings)
        distanceLabel.text = String(format: "%.0f", data.estimatedDistance) + " " + data.distanceUnit
        itemSizeLabel.text = data.packageItemsString
        userNameLabel.text = data.userData.firstName.capitalized + " " + data.userData.lastName.capitalized
        userRatingLabel.text = String(format: "%.1f", data.userData.avgRating)
        userRatingView.rating = Double(data.userData.avgRating)
        
        if let url = URL(string: data.userData.profileImage) {
            let filter = AspectScaledToFillSizeFilter(size: profileImageView.frame.size)
            profileImageView.af_setImage(withURL: url, placeholderImage: nil, filter: filter)
        }
        messageButton.isHidden = true
        messageCountLabel.isHidden = true
//        if data.isOfferSent {
//            messageButton.isHidden = false
//            messageCountLabel.text = String(data.messageCount)
//
//        } else {
//            messageCountLabel.text = ""
//            messageButton.isHidden = true
//        }
    }
    
    @IBAction func messageButtonTapped(_ sender: Any) {
        delegate?.didTappedMessageButton()
    }
}
