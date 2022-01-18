//
//  PickupTableViewCell.swift
//  Routehive
//
//  Created by Huzaifa on 9/27/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

protocol PickupTableViewCellDelegate {
    func didTappedAddCodeButton(cell: PickupTableViewCell)
    func didTappedNavigationButton(cell: PickupTableViewCell)
    func didTappedCallButton(cell: PickupTableViewCell)
}

class PickupTableViewCell: UITableViewCell {

    @IBOutlet weak var dotsView: UIView!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressDetailLabel: UILabel!
    @IBOutlet weak var addressDetailTwo: UILabel!
    @IBOutlet weak var namePhoneLabel: UILabel!
    @IBOutlet weak var addCodeButton: UIButton!
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    
    var delegate: PickupTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> PickupTableViewCell {
        let kPickupTableViewCellIdentifier = "kPickupTableViewCellIdentifier"
        tableView.register(UINib(nibName: "PickupTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kPickupTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kPickupTableViewCellIdentifier) as! PickupTableViewCell
        return cell
    }
    
    func configureCell(data: Package, locationType: Int, indexPath: IndexPath, localizable: LocalizedKeys) {
    
        if locationType == 1 {
            callButton.isHidden = true
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
                namePhoneLabel.text = "\(data.userData.firstName + " " + data.userData.lastName) (\(data.userData.phoneNumber))"
                
            } else {
                namePhoneLabel.text = "\(data.packageLocations[0].name) (\(data.packageLocations[0].phoneNumber))"
            }
            
            if data.packageLocations[0].status == 3 {
                addCodeButton.setTitle("+ \(localizable.addPickupCodeButtonTitle)", for: .normal)
                addCodeButton.isUserInteractionEnabled = true
                navigationButton.isHidden = false
                addCodeButton.setTitleColor(#colorLiteral(red: 0.8549019608, green: 0.1607843137, blue: 0.1333333333, alpha: 1), for: .normal)
                
                if data.packageLocations[0].isLocationBlocked {
                    addCodeButton.setTitle(localizable.contactAdmin, for: .normal)
                    
                } else {
                    addCodeButton.setTitle("+ \(localizable.addPickupCodeButtonTitle)", for: .normal)
                }
                
            } else if data.packageLocations[0].status == 4 {
                addCodeButton.setTitle(localizable.pickupConfirmedButtonTitle, for: .normal)
                addCodeButton.isUserInteractionEnabled = false
                navigationButton.isHidden = true
                addCodeButton.setTitleColor(#colorLiteral(red: 0, green: 0.6745098039, blue: 0.4078431373, alpha: 1), for: .normal)
                
            } else {
                addCodeButton.setTitle("+ \(localizable.addPickupCodeButtonTitle)", for: .normal)
                addCodeButton.isUserInteractionEnabled = false
                navigationButton.isHidden = false
                addCodeButton.setTitleColor(#colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1), for: .normal)
            }
            
            dotsView.isHidden = false
            
        } else {
            callButton.isHidden = false
            navigationButton.isHidden = false
            addressDetailLabel.isHidden = false
            addressDetailTwo.isHidden = false
            
            if data.packageLocations[indexPath.section - 1].addressLineTwo != "" && data.packageLocations[indexPath.section - 1].addressLineOne != "" {
                addressTitleLabel.text = data.packageLocations[indexPath.section - 1].addressLineTwo
                addressDetailLabel.text = data.packageLocations[indexPath.section - 1].addressLineOne
                addressDetailTwo.text = data.packageLocations[indexPath.section - 1].primaryAddress
                
            } else if data.packageLocations[indexPath.section - 1].addressLineTwo != "" {
                addressTitleLabel.text = data.packageLocations[indexPath.section - 1].addressLineTwo
                addressDetailLabel.text = data.packageLocations[indexPath.section - 1].primaryAddress
                addressDetailTwo.isHidden = true
                
            } else if data.packageLocations[indexPath.section - 1].addressLineOne != "" {
                addressTitleLabel.text = data.packageLocations[indexPath.section - 1].addressLineOne
                addressDetailLabel.text = data.packageLocations[indexPath.section - 1].primaryAddress
                addressDetailTwo.isHidden = true
                
            } else {
                addressTitleLabel.text = data.packageLocations[indexPath.section - 1].primaryAddress
                addressDetailLabel.isHidden = true
                addressDetailTwo.isHidden = true
            }
            
            if data.packageLocations[indexPath.section - 1].personAtLocation == 1 {
                namePhoneLabel.text = "\(data.userData.firstName + " " + data.userData.lastName) (\(data.userData.phoneNumber))"
                
            } else {
                namePhoneLabel.text = "\(data.packageLocations[indexPath.section - 1].name) (\(data.packageLocations[indexPath.section - 1].phoneNumber))"
            }
            
            if data.packageLocations[indexPath.section - 1].status == 3 {
                addCodeButton.setTitle(localizable.confirmDropoffButtonTitle, for: .normal)
                addCodeButton.isUserInteractionEnabled = true
                navigationButton.isHidden = false
                callButton.isHidden = false
                addCodeButton.setTitleColor(#colorLiteral(red: 0.8549019608, green: 0.1607843137, blue: 0.1333333333, alpha: 1), for: .normal)
                
                if data.packageLocations[indexPath.section - 1].isLocationBlocked {
                    addCodeButton.setTitle(localizable.contactAdmin, for: .normal)
                    
                } else {
                    addCodeButton.setTitle(localizable.confirmDropoffButtonTitle, for: .normal)
                }
                
            } else if data.packageLocations[indexPath.section - 1].status == 4 {
                addCodeButton.setTitle(localizable.dropoffConfirmedButtonTitle, for: .normal)
                addCodeButton.isUserInteractionEnabled = false
                navigationButton.isHidden = true
                callButton.isHidden = true
                addCodeButton.setTitleColor(#colorLiteral(red: 0, green: 0.6745098039, blue: 0.4078431373, alpha: 1), for: .normal)
                
            } else {
                addCodeButton.setTitle(localizable.confirmDropoffButtonTitle, for: .normal)
                addCodeButton.isUserInteractionEnabled = false
                navigationButton.isHidden = false
                callButton.isHidden = false
                addCodeButton.setTitleColor(#colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1), for: .normal)
            }
            
            if indexPath.section == data.packageLocations.count {
                dotsView.isHidden = true
                
            } else {
                dotsView.isHidden = false
            }
        }
        
        if data.isEmergencyReported && data.isSameSP {
            navigationButton.isUserInteractionEnabled = false
            callButton.isUserInteractionEnabled = false
            addCodeButton.isUserInteractionEnabled = false
        }
        
        if data.isEmergencyReported && !data.isSameSP {
            
            if !data.emergencyPickupConfirmed {
                navigationButton.isUserInteractionEnabled = false
                callButton.isUserInteractionEnabled = false
                addCodeButton.isUserInteractionEnabled = false
                
            } else {
                navigationButton.isUserInteractionEnabled = true
                callButton.isUserInteractionEnabled = true
                addCodeButton.isUserInteractionEnabled = true
                
                if data.packageLocations[indexPath.section - 1].status == 4 {
                    addCodeButton.setTitle(localizable.dropoffConfirmedButtonTitle, for: .normal)
                    addCodeButton.isUserInteractionEnabled = false
                    navigationButton.isHidden = true
                    callButton.isHidden = true
                    addCodeButton.setTitleColor(#colorLiteral(red: 0, green: 0.6745098039, blue: 0.4078431373, alpha: 1), for: .normal)
                    
                }
            }
        }
        
    }
    
    @IBAction func addCodeButtonTapped(_ sender: Any) {
        delegate?.didTappedAddCodeButton(cell: self)
    }
    
    @IBAction func navigationButtonTapped(_ sender: Any) {
        delegate?.didTappedNavigationButton(cell: self)
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        delegate?.didTappedCallButton(cell: self)
    }
}
