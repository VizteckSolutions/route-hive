//
//  JobCompletedPopupViewController.swift
//  BoonDesign
//
//  Created by Zeshan on 26/09/2018.
//  Copyright © 2018 vizteck. All rights reserved.
//

import UIKit
import Cosmos
import ObjectMapper

protocol JobCompletedPopupViewControllerDelegate {
    func didTappedSubmitButton(rating: Int)
}

class JobCompletedPopupViewController: UIViewController {

    // MARK: - Variables & Constants
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var earningTitleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var submitButton: RoutehiveButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var earningLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var customerRatingView: CosmosView!
    @IBOutlet weak var rateView: CosmosView!
    
    var delegate: JobCompletedPopupViewControllerDelegate?
    var dataSource = Mapper<Package>().map(JSONObject: [:])!
    var homeDataSource = Mapper<UnRatedPackage>().map(JSONObject: [:])!
    var isFromHome = false
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.roundCorners(uiViewCorners: .top, radius: 20)
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupViewControllerUI() {
        LocalizableJobCompleted.setLanguage(viewController: self)
        populateData()
    }
    
    // MARK: - Private Methods
    
    func populateData() {
        
        if isFromHome {
            earningLabel.text = homeDataSource.currency + " " + String(format: "%.2f", homeDataSource.spEarnings)
            nameLabel.text = homeDataSource.userData.userName
            ratingLabel.text = String(format: "%.1f", homeDataSource.userData.avgRating)
            customerRatingView.rating = homeDataSource.userData.avgRating
            
            if let url = URL(string: homeDataSource.userData.profileImage) {
                profileImageView.af_setImage(withURL: url)
            }
            
            SocketIOManager.sharedInstance.markUnretdPackageAsRated(packageId: homeDataSource.packageId)
            
        } else {
            earningLabel.text = dataSource.currency + " " + String(format: "%.2f", dataSource.spEarnings)
            nameLabel.text = dataSource.userData.firstName + " " + dataSource.userData.lastName
            ratingLabel.text = String(format: "%.1f", dataSource.userData.avgRating)
            customerRatingView.rating = dataSource.userData.avgRating
            
            if let url = URL(string: dataSource.userData.profileImage) {
                profileImageView.af_setImage(withURL: url)
            }
        }
    }
    
    func rateUser() {
        let source = Mapper<PackageDetails>().map(JSONObject: [:])!
        
        source.rateUser(packageId: homeDataSource.packageId, rating: Int(rateView.rating), viewController: self) { (result, error) in
            
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        if isFromHome {
            rateUser()
            
        } else {
            dismiss(animated: true, completion: nil)
            delegate?.didTappedSubmitButton(rating: Int(rateView.rating))
        }
    }
}
