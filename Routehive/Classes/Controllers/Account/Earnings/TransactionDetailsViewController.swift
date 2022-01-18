//
//  TransactionDetailsViewController.swift
//  Routehive
//
//  Created by Mac on 02/11/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireImage

class TransactionDetailsViewController: UIViewController {

    // MARK: - Variables & Constants
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = Mapper<PackageDetails>().map(JSONObject: [:])!
    
    var dateFormatter = DateFormatter()
    var isFirstLoad = true
    var packageId = 0
    
    var customerLabel = ""
    var yourEarningLabel = ""
    var pickupLabel = ""
    var dropoffLabel = ""
    var quantityLabel = ""
    var itemValLabel = ""
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableTransactionDetailScreen.setLanguage(viewController: self)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        dateFormatter.dateFormat = "h:mm a, dd MMM, yyyy"
        loadData()
    }
    
    func loadData() {
        
        dataSource.fetchPackageDetails(viewController: self, packageId: packageId) { (result, error) in
            
            if error == nil {
                self.dataSource = result
                self.isFirstLoad = false
                self.tableView.reloadData()
            }
        }
    }
    
    func rateUser(rating: Int) {
        
        dataSource.rateUser(packageId: packageId, rating: rating, viewController: self) { (result, error) in
            
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension TransactionDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFirstLoad {
            return 0
        }
        return dataSource.package.packageLocations.count + 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 || section == 1 || section == 2 {
            return 1
        }
        
        return dataSource.package.packageLocations[section-2].items.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = MapViewTableViewCell.cellForTableView(tableView: tableView)
            cell.configureCell(packageData: dataSource.package, pickupLabel: pickupLabel)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = TransactionUserDetailTableViewCell.cellForTableView(tableView: tableView)
            cell.delegate = self
            cell.customerLabel.text = customerLabel
            cell.yourEarningLabel.text = yourEarningLabel
            cell.configureCell(data: dataSource.package)
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = TransactionPickupTableViewCell.cellForTableView(tableView: tableView)
            cell.configureCell(data: dataSource.package, locationType: 1, indexPath: indexPath)
            return cell
        }
        
        if indexPath.row == 0 {
            let cell = TransactionPickupTableViewCell.cellForTableView(tableView: tableView)
            cell.configureCell(data: dataSource.package, locationType: 2, indexPath: indexPath)
            return cell
        }
        
        let cell = ItemsTableViewCell.cellForTableView(tableView: tableView)
        
        cell.itemDetailLabel.text = dataSource.package.packageLocations[indexPath.section - 2].items[indexPath.row - 1].name
        cell.itemQuantityLabel.text = dataSource.package.packageLocations[indexPath.section - 2].items[indexPath.row - 1].packageSize + " - \(quantityLabel): " + String(dataSource.package.packageLocations[indexPath.section - 2].items[indexPath.row - 1].quantity)
        cell.priceLabel.text = "\(itemValLabel)\(dataSource.package.packageLocations[indexPath.section - 2].items[indexPath.row - 1].estimatedPrice)"
//        cell.priceLabel.text = itemValLabel + String(format: "%.2f", dataSource.package.packageLocations[indexPath.section - 2].items[indexPath.row - 1].estimatedPrice)
        
        if let url = URL(string: dataSource.package.packageLocations[indexPath.section - 2].items[indexPath.row - 1].image) {
            let filter = AspectScaledToFillSizeFilter(size: cell.profileImageView.frame.size)
            cell.profileImageView.af_setImage(withURL: url, placeholderImage: nil, filter: filter)
        }
        
        if indexPath.section == dataSource.package.packageLocations.count + 1 {
            cell.dotsView.isHidden = true
            
        } else {
            cell.dotsView.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 || section == 1 {
            return UIView()
        }
        
        if section == 2 {
            let header = PickupSectionTableViewCell.cellForTableView(tableView: tableView)
            header.locationIndexView.isHidden = true
            header.pickupLabel.text = pickupLabel
            
            header.confirmationTimeLabel.isHidden = false
            header.confirmationTimeLabel.text = dataSource.package.packageLocations[0].pickDropTime.timeStringFromUnixTime(dateFormatter: dateFormatter)
            header.tickImageView.isHidden = false
            header.pickupView.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.4039215686, blue: 0.5568627451, alpha: 1)
            return header
        }
        
        let header = PickupSectionTableViewCell.cellForTableView(tableView: tableView)
        header.pickupLabel.text = dropoffLabel
        header.locationIndexLabel.text = points[section - 3]
        header.locationIndexView.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.0862745098, blue: 0.09019607843, alpha: 1)
        header.pickupView.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.0862745098, blue: 0.09019607843, alpha: 1)
        header.locationIndexView.isHidden = false
        header.tickImageView.isHidden = false
        header.confirmationTimeLabel.isHidden = false
        header.confirmationTimeLabel.text = dataSource.package.packageLocations[section - 2].pickDropTime.timeStringFromUnixTime(dateFormatter: dateFormatter)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 || section == 1 {
            return 0
        }
        
        return 31
    }
}

extension TransactionDetailsViewController: TransactionUserDetailTableViewCellDelegate, JobCompletedPopupViewControllerDelegate {
    
    // MARK: - TransactionUserDetailTableViewCellDelegate
    
    func didTappedRateUserButton() {
        let jobCompletedPopupViewController = JobCompletedPopupViewController()
        jobCompletedPopupViewController.modalPresentationStyle = .overCurrentContext
        jobCompletedPopupViewController.delegate = self
        jobCompletedPopupViewController.isFromHome = false
        jobCompletedPopupViewController.dataSource = self.dataSource.package
        self.present(jobCompletedPopupViewController, animated: true, completion: nil)
    }
    
    // MARK: - JobCompletedPopupViewControllerDelegate
    
    func didTappedSubmitButton(rating: Int) {
        rateUser(rating: rating)
    }
}
