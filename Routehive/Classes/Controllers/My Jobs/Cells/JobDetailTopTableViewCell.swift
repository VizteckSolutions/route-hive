//
//  JobDetailTopTableViewCell.swift
//  Routehive
//
//  Created by Huzaifa on 9/27/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import Cosmos
import AlamofireImage

protocol JobDetailTopTableViewCellDelegate {
    func didTappedCallButton()
    func didTappedMessageButton()
    func didTappedEmergencyDetailButton()
    func didTappedJobStateButton(cell: JobDetailTopTableViewCell)
}

class JobDetailTopTableViewCell: UITableViewCell {

    
    @IBOutlet weak var yourCustomerLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRatingView: CosmosView!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var jobStateButtonView: UIView!
    @IBOutlet weak var jobStateButton: RoutehiveButton!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pickupTimeStackView: UIStackView!
    @IBOutlet weak var pickupTimeLabel: UILabel!
    @IBOutlet weak var pickupTimeImageView: UIImageView!
    @IBOutlet weak var itemSizeLabel: UILabel!
    @IBOutlet weak var itemSizeImageView: UIImageView!
    @IBOutlet weak var itemSizeStackView: UIStackView!
    @IBOutlet weak var emergencyInfoLabel: UILabel!
    
    @IBOutlet weak var emergencyDetailButton: UIButton!
    
    @IBOutlet weak var messageCallView: UIView!
    
    @IBOutlet weak var rateView: UIView!
    
    @IBOutlet weak var adminAssignLabel: UILabel!
    var delegate: JobDetailTopTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> JobDetailTopTableViewCell {
        let kJobDetailTopTableViewCellIdentifier = "kJobDetailTopTableViewCellIdentifier"
        tableView.register(UINib(nibName: "JobDetailTopTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kJobDetailTopTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kJobDetailTopTableViewCellIdentifier) as! JobDetailTopTableViewCell
        return cell
    }
    
    func configureCell(data: Package, indexPath: IndexPath, localizable: LocalizedKeys) {
        emergencyInfoLabel.isHidden = true
        emergencyDetailButton.isHidden = true
        
        yourCustomerLabel.text = localizable.yourCustomerLabel
        userNameLabel.text = data.userData.firstName.capitalized + " " + data.userData.lastName.capitalized
        userRatingLabel.text = String(format: "%.1f", data.userData.avgRating)
        userRatingView.rating = data.userData.avgRating
        
        messageButton.setTitle(localizable.messageButtonTitle, for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "btn_chat_icon"), for: .normal)
        
        if let imageUrl = URL(string: data.userData.profileImage) {
            
            if profileImageView.frame.size.width != 0 && profileImageView.frame.size.height != 0 {
                
                let filter = AspectScaledToFillSizeFilter(size: profileImageView.frame.size)
                profileImageView.af_setImage(withURL: imageUrl, placeholderImage: nil, filter: filter)
                
            } else {
                profileImageView.af_setImage(withURL: imageUrl, placeholderImage: nil, filter: nil)
            }
            
        }
        
        if data.isEmergencyReported && !data.isSameSP {
            
            if !data.emergencyPickupConfirmed {
                yourCustomerLabel.text = localizable.emergencyDriverLabel
                userNameLabel.text = data.spData.name.capitalized
                userRatingLabel.text = String(format: "%.1f", data.spData.avgRating)
                userRatingView.rating = data.spData.avgRating
                
                messageButton.setTitle(localizable.navigateButtonTitle, for: .normal)
                messageButton.setImage(#imageLiteral(resourceName: "icon_navigate"), for: .normal)
                
                if let imageUrl = URL(string: data.spData.profileImage) {
                    let filter = AspectScaledToFillSizeFilter(size: profileImageView.frame.size)
                    profileImageView.af_setImage(withURL: imageUrl, placeholderImage: nil, filter: filter)
                }
            }
        }
        
        amountLabel.text = data.currency + " " + String(format: "%.2f", data.spEarnings)
        distanceLabel.text = String(format: "(%.0f %@)", data.estimatedDistance, data.distanceUnit)
        itemSizeLabel.text = data.packageItemsString
        
        if data.deliveryType == 1 {
            pickupTimeLabel.text = localizable.expressLabel
            
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a, d MMM"
            pickupTimeLabel.text = localizable.pickupByLabel + " " + data.scheduledTime.timeStringFromUnixTime(dateFormatter: dateFormatter)
        }
        
        if data.status == JobStatus.accepted.rawValue {
            jobStateButtonView.isHidden = false
            jobStateButton.setTitle(localizable.startJobButtonTitle, for: .normal)
            jobStateButton.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.1411764706, blue: 0.168627451, alpha: 1)
            
        } else if data.status == JobStatus.arriving.rawValue {
            jobStateButtonView.isHidden = false
            jobStateButton.setTitle(localizable.arrivedAtPickupButtonTitle, for: .normal)
            jobStateButton.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.1411764706, blue: 0.168627451, alpha: 1)
            
            if data.packageLocations[0].status == 3 {
                jobStateButtonView.isHidden = true
            }
            
        } else if data.status == JobStatus.inProgress.rawValue {
            jobStateButtonView.isHidden = false
            
            for location in data.packageLocations {
                
                if location.locationType != 1 {
                    
                    if location.status == 1 {
                        jobStateButton.setTitle(localizable.readyForNextDropoffButtonTitle, for: .normal)
                        jobStateButton.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.1411764706, blue: 0.168627451, alpha: 1)
                        break
                        
                    } else if location.status == 2 {
                        
                        if location.dropoffNumber > 0 {
                            jobStateButton.setTitle("\(localizable.reachedAtDropOffButtonTitle) (\(points[location.dropoffNumber - 1]))", for: .normal)
                            
                        } else {
                            jobStateButton.setTitle("\(localizable.reachedAtDropOffButtonTitle) ()", for: .normal)
                        }
                        
                        jobStateButton.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.1411764706, blue: 0.168627451, alpha: 1)
                        break
                        
                    } else if location.status == 3 {
                        jobStateButtonView.isHidden = true
                        break
                        
                    } else {
                        jobStateButton.setTitle(localizable.tapToCompleteButtonTitle, for: .normal)
                        jobStateButton.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6941176471, blue: 0.462745098, alpha: 1)
                    }
                }
            }
        }
        
        if data.isEmergencyReported {
            
            if data.isSameSP {
                messageButton.isUserInteractionEnabled = false
                callButton.isUserInteractionEnabled = false
                jobStateButton.isHidden = true
                emergencyDetailButton.isHidden = true
                jobStateButtonView.isHidden = false
                emergencyInfoLabel.isHidden = true
                emergencyInfoLabel.text = localizable.emergencyInfoLabel
                
//                if data.isBackupSPAssigned {
//                    emergencyInfoLabel.text = localizable.driverAssignedLabel
//                    emergencyDetailButton.isHidden = false
//                }
                
            } else {
                
                if !data.backupSPArrivedAtEmergency {
                    jobStateButtonView.isHidden = false
                    jobStateButton.setTitle(localizable.arrivedAtEmergencyButton, for: .normal)
                    
                } else if !data.emergencyPickupConfirmed {
                    jobStateButtonView.isHidden = false
                    jobStateButton.setTitle(localizable.confirmEmergencyButton, for: .normal)
                }
            }
        }
        
        if data.userType != 1 {
            messageCallView.isHidden = true
            adminAssignLabel.isHidden = false
            adminAssignLabel.text = localizable.adminAssignedJob
            rateView.isHidden = true
        }
    }
    
    @IBAction func messageButtonTapped(_ sender: Any) {
        delegate?.didTappedMessageButton()
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        delegate?.didTappedCallButton()
    }
    
    @IBAction func jobStateButtonTapped(_ sender: Any) {
        delegate?.didTappedJobStateButton(cell: self)
    }
    
    @IBAction func emergencyDetailButtonTapped(_ sender: Any) {
        delegate?.didTappedEmergencyDetailButton()
    }
}
