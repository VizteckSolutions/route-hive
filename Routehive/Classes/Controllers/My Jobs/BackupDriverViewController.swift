//
//  BackupDriverViewController.swift
//  Routehive
//
//  Created by Mac on 06/11/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper
import Cosmos
import AlamofireImage

class BackupDriverViewController: UIViewController {

    @IBOutlet weak var driverStatusLabel: UILabel!
    @IBOutlet weak var backupDriverLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var callButton: UIButton!
    
    var statusOnWay = ""
    var statusArrived = ""
    var statusTransfered = ""
    
    var dataSource = Mapper<Package>().map(JSONObject: [:])!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    func setupViewControllerUI() {
        LocalizableEmergencyBackupDriver.setLanguage(viewController: self)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        
        if !dataSource.backupSPArrivedAtEmergency {
            driverStatusLabel.text = statusOnWay
        }
        
        if dataSource.backupSPArrivedAtEmergency {
            driverStatusLabel.text = statusArrived
        }
        
        if dataSource.emergencyPickupConfirmed {
            driverStatusLabel.text = statusTransfered
        }
        
        nameLabel.text = dataSource.backupSPData.name.capitalized
        ratingLabel.text = String(format: "%.1f", dataSource.backupSPData.avgRating)
        ratingView.rating = dataSource.backupSPData.avgRating
        
        if let imageUrl = URL(string: dataSource.backupSPData.profileImage) {
            let filter = AspectScaledToFillSizeFilter(size: profileImageView.frame.size)
            profileImageView.af_setImage(withURL: imageUrl, placeholderImage: nil, filter: filter)
        }
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        Utility.openDialerWith(number: dataSource.backupSPData.phoneNumber)
    }
}

extension BackupDriverViewController: ApplicationMainDelegate {
    
    func didReceiveJobCancelledEvent() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func didReceiveBackupSpArrivedEvent() {
        driverStatusLabel.text = statusArrived
    }
    
    func didReceiveBackupSpConfirmPickupEvent() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
