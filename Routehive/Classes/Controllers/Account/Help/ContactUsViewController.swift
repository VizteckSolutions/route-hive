//
//  ContactUsViewController.swift
//  Routehive
//
//  Created by Mac on 02/11/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation

class ContactUsViewController: UIViewController {
    
    // MARK: - Variables & Constants
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSourse = Mapper<ContactUsInfo>().map(JSONObject: [:])!
    var country = ""
    var isFirstLoad = true
    
    var availableFrom = ""
    var toLable = ""
    var followUsLabel = ""
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableContactUsViewController.setLanguage(viewController: self)
        CLGeocoder().reverseGeocodeLocation(Driver.shared.locationManager.location!, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil { return } else if let country = placemarks?.first?.country {
                print(country)
                self.country = country
                self.loadData()
            }
        })
    }
    
    // MARK: - Private Methods
    
    func loadData() {
        
        dataSourse.getContactUsDetails(viewController: self, country: country) { (result, error) in
            
            if error == nil {
                self.dataSourse = result
                self.isFirstLoad = false
                self.tableView.reloadData()
            }
        }
    }
}

extension ContactUsViewController: UITableViewDelegate, UITableViewDataSource, ContactUsBottomTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFirstLoad {
            return 0
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            let cell = ContactUsTopTableViewCell.cellForTableView(tableView: tableView)
            return cell
            
        case 1:
            let cell = ContactUsTableViewCell.cellForTableView(tableView: tableView)
            cell.leftImageView.image = #imageLiteral(resourceName: "icon_contact_phone")
            cell.detailLabel.text = dataSourse.contactMobileNumber
            return cell
        case 2:
            let cell = ContactUsTableViewCell.cellForTableView(tableView: tableView)
            cell.leftImageView.image = #imageLiteral(resourceName: "icon_contact_telephone")
            cell.detailLabel.text = dataSourse.contactPhoneNumber
            return cell
        case 3:
            let cell = ContactUsTableViewCell.cellForTableView(tableView: tableView)
            cell.leftImageView.image = #imageLiteral(resourceName: "icon_contact_email")
            cell.detailLabel.text = dataSourse.contactEmail
            return cell
        case 4:
            let cell = ContactUsTableViewCell.cellForTableView(tableView: tableView)
            cell.leftImageView.image = #imageLiteral(resourceName: "icon_contact_link")
            cell.detailLabel.text = dataSourse.contactWebsite
            return cell
        default:
            let cell = ContactUsBottomTableViewCell.cellForTableView(tableView: tableView)
            cell.delegate = self
            cell.availableLabel.text = availableFrom + " \((dataSourse.startTime)) \(toLable) \((dataSourse.endTime))"
            cell.followUsLabel.text = followUsLabel
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 1:
            Utility.openDialerWith(number: dataSourse.contactMobileNumber)
            
        case 2:
            Utility.openDialerWith(number: dataSourse.contactPhoneNumber)
            
        case 3:
            Utility.openMailApp(mailTo: dataSourse.contactEmail)
            
        case 4:
            Utility.openSafariWith(Url: dataSourse.contactWebsite, viewController: self)
            
        default:
            break
        }
    }
    
    // MARK: - ContactUsBottomTableViewCellDelegate
    
    func didTappedFacebookButton() {
        Utility.openSafariWith(Url: dataSourse.facebookLink, viewController: self)
    }
    
    func didTappedTwitterButton() {
        Utility.openSafariWith(Url: dataSourse.twitterLink, viewController: self)
    }
    
    func didTappedInstaButton() {
        Utility.openSafariWith(Url: dataSourse.instaBookLink, viewController: self)
    }
}
