//
//  MyJobsViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/24/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireImage

class MyJobsViewController: UIViewController {

    // MARK: - Variables & Constants
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource = Mapper<PackageDetails>().map(JSONObject: [:])!
    
    var isFirstLoad = true
    var dateFormatter = DateFormatter()
    
    var emptyScreenMessage = ""
    var expressLabel = ""
    var pickupByLabel = ""
    var viewAvailableJobs = ""
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        title = tabBarController?.tabBar.items![TabBarModules.myJobs.rawValue].title
        LocalizableMyJobsScreen.setLanguage(viewController: self)
        dateFormatter.dateFormat = "h:mm a, d MMM"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Driver.shared.shouldOpenMyJobs = false
        loadData()
    }
    
    // MARK: - Private Methods
    
    func loadData() {
        
        dataSource.fetchMyJobsListing(viewController: self) { (result, error) in
            
            if error == nil {
                self.dataSource = result
                self.isFirstLoad = false
                
                if result.myPackages.count == 0 {
                    Utility.emptyTableViewMessageWithImage(image: #imageLiteral(resourceName: "icon_no_active_package"), message: self.emptyScreenMessage, buttonTitle: self.viewAvailableJobs, isButton: true, viewBackgroundColor: .white, viewController: self, tableView: self.tableView)
                    
                } else {
                    self.tableView.backgroundView = UIView()
                }
                
                self.tableView.reloadData()
            }
        }
    }
}

extension MyJobsViewController: UITableViewDelegate, UITableViewDataSource, NoJobsViewsDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFirstLoad {
            return 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.myPackages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JobTableViewCell.cellForTableView(tableView: tableView)
        Utility.animateTableView(animationType: .scaleFromTop, tableView: tableView, cell: cell)
        cell.earningLabel.text = dataSource.myPackages[indexPath.row].currency + " " + String(format: "%.2f", dataSource.myPackages[indexPath.row].spEarnings)
        cell.distanceLabel.text = "(\(dataSource.myPackages[indexPath.row].distance) \(dataSource.myPackages[indexPath.row].distanceUnit))"
        cell.pickupAddressLabel.text = dataSource.myPackages[indexPath.row].pickupAddress
        cell.dropoffAddressLabel.text = dataSource.myPackages[indexPath.row].dropoffAddress
        cell.itemSizeLabel.text = dataSource.myPackages[indexPath.row].packageItemsString
        
        if dataSource.myPackages[indexPath.row].deliveryType == 1 {
            cell.pickupTimeLabel.text = expressLabel
            
        } else {
            cell.pickupTimeLabel.text = pickupByLabel + " " + dataSource.myPackages[indexPath.row].scheduledTime.timeStringFromUnixTime(dateFormatter: dateFormatter)
        }
        
        dataSource.myPackages[indexPath.row].packageImage = dataSource.myPackages[indexPath.row].packageImage.replacingOccurrences(of: "1000X1000", with: "300X300")
        
        if let url = URL(string: dataSource.myPackages[indexPath.row].packageImage) {
            cell.profileImageView.setImage(inTableCell: cell, withUrl: url, placeholder: nil)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myJobDetailViewController = MyJobDetailViewController()
        myJobDetailViewController.addCustomBackButton()
        myJobDetailViewController.jobId = dataSource.myPackages[indexPath.row].id
        myJobDetailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(myJobDetailViewController, animated: true)
    }
    
    // MARK: - NoJobsViewsDelegate
    
    func didTapViewButton() {
        self.tabBarController?.selectedIndex = 0
    }
}

extension MyJobsViewController: ApplicationMainDelegate {
    
    func didReceiveJobCancelledEvent() {
        loadData()
    }
    
    func didReceiveJobAccecptedEvent() {
        loadData()
    }
    
    func didReceiveSpSwappedEvent() {
        loadData()
    }
    
    func didReceiveBackupSpConfirmPickupEvent() {
        loadData()
    }
    
    func didReceiveAdminAssignedDriver() {
        loadData()
    }
    
    func didReceiveOfferAssignToAnotherEvent(packageId: Int) {
        loadData()
    }
}
