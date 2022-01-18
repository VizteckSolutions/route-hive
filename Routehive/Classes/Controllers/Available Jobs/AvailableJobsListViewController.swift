//
//  AvailableJobsListViewController.swift
//  Routehive
//
//  Created by Huzaifa on 10/1/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import CoreLocation
import ObjectMapper
import AlamofireImage

class AvailableJobsListViewController: UIViewController {

    // MARK: - Variables & Constants
    
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager = CLLocationManager()
    var dataSource = Mapper<PackageDetails>().map(JSONObject: [:])!
    
    
    var dateFormatter = DateFormatter()
    var offSet = 0
    var isFirstLoad = true
    
    var emptyScreenMessage = ""
    var expressLabel = ""
    var pickupByLabel = ""
    var awayLabel = ""
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData(sourceCoordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), destinationCoordinate: CLLocationCoordinate2D(), offset: 0)
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupViewControllerUI() {
        LocalizableAvailableJobsScreen.setLanguage(viewController: self)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        dateFormatter.dateFormat = "h:mm a, d MMM"
    }
    
    // MARK: - Private Methods
    
    func loadData(sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, offset: Int) {
        
        if offset == 0 {
            self.offSet = 0
        }
        
        if self.offSet == -1 {
            return
        }
        
        dataSource.fetchAvailableJobs(viewController: self, lat: sourceCoordinate.latitude, lng: sourceCoordinate.longitude, destLat: destinationCoordinate.latitude, destLong: destinationCoordinate.longitude, offset: self.offSet) { (result, error) in
            
            if error == nil {
                
                if self.offSet == 0 {
                    self.isFirstLoad = false
                    
                    if result.jobs.count == 0 {
                        Utility.emptyTableViewMessageWithImage(image: #imageLiteral(resourceName: "icon_no_active_package"), message: self.emptyScreenMessage, buttonTitle: "", isButton: false, viewBackgroundColor: .white, viewController: self, tableView: self.tableView)
                        
                    } else {
                        self.tableView.backgroundView = UIView()
                    }
                    
                    self.dataSource = result
                    
                } else {
                    self.dataSource.jobs.append(contentsOf: result.jobs)
                }
                
                if result.jobs.count > 0 {
                    
                    if result.jobs.count < kOffSet {
                        self.offSet = -1
                        
                    } else {
                        self.offSet += kOffSet
                    }
                    
                } else {
                    self.offSet = -1
                }

                self.tableView.reloadData()
            }
        }
    }
}

extension AvailableJobsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFirstLoad {
            return 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JobTableViewCell.cellForTableView(tableView: tableView)
        Utility.animateTableView(animationType: .scaleFromTop, tableView: tableView, cell: cell)
        
        cell.earningLabel.text = dataSource.jobs[indexPath.row].currency + " " + String(format: "%.2f", dataSource.jobs[indexPath.row].spEarnings)
        cell.distanceLabel.text = "(\(dataSource.jobs[indexPath.row].distance) \(dataSource.jobs[indexPath.row].distanceUnit) \(awayLabel))"
        cell.pickupAddressLabel.text = dataSource.jobs[indexPath.row].pickupAddress
        cell.dropoffAddressLabel.text = dataSource.jobs[indexPath.row].dropoffAddress
        cell.itemSizeLabel.text = dataSource.jobs[indexPath.row].packageItemsString
        
        if dataSource.jobs[indexPath.row].deliveryType == 1 {
            cell.pickupTimeLabel.text = expressLabel
            
        } else {
            cell.pickupTimeLabel.text = pickupByLabel + " " + dataSource.jobs[indexPath.row].scheduledTime.timeStringFromUnixTime(dateFormatter: dateFormatter)
        }
        
        dataSource.jobs[indexPath.row].packageImage = dataSource.jobs[indexPath.row].packageImage.replacingOccurrences(of: "1000X1000", with: "300X300")
        
        if let url = URL(string: dataSource.jobs[indexPath.row].packageImage) {
            cell.profileImageView.setImage(inTableCell: cell, withUrl: url, placeholder: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let availableJobDetailViewController = AvailableJobDetailViewController()
        availableJobDetailViewController.addCustomBackButton()
        availableJobDetailViewController.jobId = dataSource.jobs[indexPath.row].packageId
        availableJobDetailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(availableJobDetailViewController, animated: true)
    }
    
    // MARK: - UIScrollView Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            
            if dataSource.jobs.count >= kOffSet {
                loadData(sourceCoordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), destinationCoordinate: CLLocationCoordinate2D(), offset: offSet)
            }
        }
    }
}

extension AvailableJobsListViewController: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if manager.location != nil {
            locationManager = manager
        }
    }
}

extension AvailableJobsListViewController: ApplicationMainDelegate {
    
    func didReceiveNewJobEvent() {
        loadData(sourceCoordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), destinationCoordinate: CLLocationCoordinate2D(), offset: 0)
    }
    
    func didReceiveJobAccecptedEvent() {
        loadData(sourceCoordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), destinationCoordinate: CLLocationCoordinate2D(), offset: 0)
    }
}
