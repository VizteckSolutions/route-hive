//
//  AccountViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/24/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper

class AccountViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var tableView: UITableView!
    var signIn = Mapper<SignIn>().map(JSON: [:])!
    
    var jobCompletedLabel = ""
    var myProfile = ""
    var earnings = ""
    var help = ""
    var language = ""
    var referDriver = ""
    var logout = ""

    // MARK: - UIviewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        
        if Driver.shared.shouldChangeLanguage {
            let changeLanguageViewController = ChangeLanguageViewController()
            changeLanguageViewController.addCustomBackButton()
            changeLanguageViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(changeLanguageViewController, animated: false)
            
        } else if Driver.shared.shouldOpenEarnings {
            let earningsViewController = EarningsViewController()
            earningsViewController.addCustomBackButton()
            earningsViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(earningsViewController, animated: false)
        }
    }
    
    func setupViewControllerUI() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        LocalizableAccount.setLanguage(viewController: self)
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    
    func loadData() {
        
        signIn.fetchProfile(viewController: self) { (result, error) in
            
            if error == nil {
                self.signIn = result
                Utility.saveDriverDataInDefaults(data: result.spData)
                self.tableView.reloadData()
            }
        }
    }
    
    func doLogout() {
        
        signIn.doLogout(viewController: self) { (result, error) in
            
            if error == nil {
                Utility.clearUser()
                Utility.setupLoginAsRootViewController()
            }
        }
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            let cell = AccountTopTableViewCell.cellForTableView(tableView: tableView)
            
            if Driver.shared.name != "" {
                cell.nameLabel.text = Driver.shared.name.capitalized
                
            } else {
                cell.nameLabel.text = Driver.shared.firstName.capitalized + " " + Driver.shared.lastName.capitalized
            }

            if let url = URL(string: Driver.shared.profileImage) {
                cell.profileImageView.af_setImage(withURL: url)
            }
            
            cell.ratingLabel.text = String(format: "%.1f", Driver.shared.avgRating)
            cell.ratingView.rating = Driver.shared.avgRating
            cell.totalJosLabel.text = "\(Driver.shared.jobsDoneCount) \(jobCompletedLabel)"
            cell.vehicleDetailLabel.text = Driver.shared.vehicleName + ": " + Driver.shared.vehiclePlateNumber
            return cell
            
        case 1:
            let cell = AccountTableViewCell.cellForTableView(tableView: tableView)
            cell.accountTitleLable.text = myProfile
            cell.accountImageView.image = #imageLiteral(resourceName: "tab_account copy")
            return cell
            
        case 2:
            let cell = AccountTableViewCell.cellForTableView(tableView: tableView)
            cell.accountTitleLable.text = earnings
            cell.accountImageView.image = #imageLiteral(resourceName: "act_earning")
            return cell
            
        case 3:
            return UITableViewCell()
//            let cell = AccountTableViewCell.cellForTableView(tableView: tableView)
//            cell.accountTitleLable.text = help
//            cell.accountImageView.image = #imageLiteral(resourceName: "act_help")
//            return cell
            
        case 4:
            return UITableViewCell()
//            let cell = AccountTableViewCell.cellForTableView(tableView: tableView)
//            cell.accountTitleLable.text = language
//            cell.accountImageView.image = #imageLiteral(resourceName: "act_language")
//            return cell
            
        case 5:
            return UITableViewCell()
            let cell = AccountTableViewCell.cellForTableView(tableView: tableView)
            cell.accountTitleLable.text = referDriver
            cell.accountImageView.image = #imageLiteral(resourceName: "act_reffer_driver")
            return cell
            
        default:
            let cell = AccountTableViewCell.cellForTableView(tableView: tableView)
            cell.accountTitleLable.text = logout
            cell.accountImageView.image = #imageLiteral(resourceName: "act_logout")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            return
        }
        
        switch indexPath.row {
            
        case 1:
            let profileViewController = ProfileViewController()
            profileViewController.addCustomBackButton()
            profileViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileViewController, animated: true)
            
        case 2:
            let earningsViewController = EarningsViewController()
            earningsViewController.addCustomBackButton()
            earningsViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(earningsViewController, animated: true)
            
        case 3:
            let helpViewController = HelpViewController()
            helpViewController.addCustomBackButton()
            helpViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(helpViewController, animated: true)
            
        case 4:
            let changeLanguageViewController = ChangeLanguageViewController()
            changeLanguageViewController.addCustomBackButton()
            changeLanguageViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(changeLanguageViewController, animated: true)
            
        case 5:
            let shareRaferralViewController = ShareRaferralViewController()
            shareRaferralViewController.addCustomBackButton()
            shareRaferralViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(shareRaferralViewController, animated: true)
            
        default:
            doLogout()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 4 || indexPath.row == 3 || indexPath.row == 5 {
            return 0
        }
        
        return UITableViewAutomaticDimension
    }
}
