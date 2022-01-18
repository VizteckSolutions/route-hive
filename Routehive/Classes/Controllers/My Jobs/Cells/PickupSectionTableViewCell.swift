//
//  PickupSectionTableViewCell.swift
//  Routehive
//
//  Created by Huzaifa on 9/27/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

protocol PickupSectionTableViewCellDelegate {
    func didTappedViewAddressButton(cell: PickupSectionTableViewCell)
}

class PickupSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var pickupView: UIView!
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var sourceIconImageView: UIImageView!
    @IBOutlet weak var locationIndexView: UIView!
    @IBOutlet weak var locationIndexLabel: UILabel!
    @IBOutlet weak var confirmationTimeLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    
    @IBOutlet weak var viewAddressButton: UIButton!
    
    var delegate: PickupSectionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> PickupSectionTableViewCell {
        let kPickupSectionTableViewCellIdentifier = "kPickupSectionTableViewCellIdentifier"
        tableView.register(UINib(nibName: "PickupSectionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kPickupSectionTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kPickupSectionTableViewCellIdentifier) as! PickupSectionTableViewCell
        return cell
    }
    
    @IBAction func viewAddressButtonTapped(_ sender: Any) {
        delegate?.didTappedViewAddressButton(cell: self)
    }
}
