//
//  TransactionPickupTableViewCell.swift
//  Routehive
//
//  Created by Mac on 05/11/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper

class TransactionPickupTableViewCell: UITableViewCell {

    @IBOutlet weak var dotsView: UIView!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressDetailLabel: UILabel!
    @IBOutlet weak var addressDetailTwo: UILabel!
    @IBOutlet weak var namePhoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> TransactionPickupTableViewCell {
        let kTransactionPickupTableViewCellIdentifier = "kTransactionPickupTableViewCellIdentifier"
        tableView.register(UINib(nibName: "TransactionPickupTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kTransactionPickupTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kTransactionPickupTableViewCellIdentifier) as! TransactionPickupTableViewCell
        return cell
    }
    
    func configureCell(data: Package, locationType: Int, indexPath: IndexPath) {
        
        if locationType == 1 {
            
            addressDetailLabel.isHidden = false
            addressDetailTwo.isHidden = false
            
            if data.packageLocations[0].addressLineTwo != "" && data.packageLocations[0].addressLineOne != "" {
                addressTitleLabel.text = data.packageLocations[0].addressLineTwo
                addressDetailLabel.text = data.packageLocations[0].addressLineOne
                addressDetailTwo.text = data.packageLocations[0].primaryAddress
                
            } else if data.packageLocations[0].addressLineTwo != "" {
                addressTitleLabel.text = data.packageLocations[0].addressLineTwo
                addressDetailLabel.text = data.packageLocations[0].primaryAddress
                addressDetailTwo.isHidden = true
                
            } else if data.packageLocations[0].addressLineOne != "" {
                addressTitleLabel.text = data.packageLocations[0].addressLineOne
                addressDetailLabel.text = data.packageLocations[0].primaryAddress
                addressDetailTwo.isHidden = true
                
            } else {
                addressTitleLabel.text = data.packageLocations[0].primaryAddress
                addressDetailLabel.isHidden = true
                addressDetailTwo.isHidden = true
            }
            
            if data.packageLocations[0].personAtLocation == 1 {
                namePhoneLabel.text = data.userData.firstName + " " + data.userData.lastName + " (\(data.userData.phoneNumber))"
                
            } else {
                namePhoneLabel.text = data.packageLocations[0].name + " (\(data.packageLocations[0].phoneNumber))"
            }
            
            dotsView.isHidden = false
            
        } else {
            addressDetailLabel.isHidden = false
            addressDetailTwo.isHidden = false
            
            if data.packageLocations[indexPath.section - 2].addressLineTwo != "" && data.packageLocations[indexPath.section - 2].addressLineOne != "" {
                addressTitleLabel.text = data.packageLocations[indexPath.section - 2].addressLineTwo
                addressDetailLabel.text = data.packageLocations[indexPath.section - 2].addressLineOne
                addressDetailTwo.text = data.packageLocations[indexPath.section - 2].primaryAddress
                
            } else if data.packageLocations[indexPath.section - 2].addressLineTwo != "" {
                addressTitleLabel.text = data.packageLocations[indexPath.section - 2].addressLineTwo
                addressDetailLabel.text = data.packageLocations[indexPath.section - 2].primaryAddress
                addressDetailTwo.isHidden = true
                
            } else if data.packageLocations[indexPath.section - 2].addressLineOne != "" {
                addressTitleLabel.text = data.packageLocations[indexPath.section - 2].addressLineOne
                addressDetailLabel.text = data.packageLocations[indexPath.section - 2].primaryAddress
                addressDetailTwo.isHidden = true
                
            } else {
                addressTitleLabel.text = data.packageLocations[indexPath.section - 2].primaryAddress
                addressDetailLabel.isHidden = true
                addressDetailTwo.isHidden = true
            }
            
            if data.packageLocations[indexPath.section - 2].personAtLocation == 1 {
                namePhoneLabel.text = data.userData.firstName + " " + data.userData.lastName + " (\(data.userData.phoneNumber))"
                
            } else {
                namePhoneLabel.text = data.packageLocations[indexPath.section - 2].name + " (\(data.packageLocations[indexPath.section - 2].phoneNumber))"
            }
            
            if indexPath.section == data.packageLocations.count + 1 {
                dotsView.isHidden = true
                
            } else {
                dotsView.isHidden = false
            }
        }
    }
}
