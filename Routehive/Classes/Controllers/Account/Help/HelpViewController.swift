//
//  HelpViewController.swift
//  asas
//
//  Created by Umair Afzal on 21/09/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    var titles = [String]()
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableHelpViewController.setLanguage(viewController: self)
        tableView.reloadData()
    }
}

extension HelpViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableView Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.appThemeFontWithSize(17.0)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    // MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0:
            let userGuide = UserGuideViewController()
            userGuide.addCustomBackButton()
            userGuide.titleLabel = titles[indexPath.row]
            userGuide.type = WebViewType.userGuide.rawValue
            self.navigationController?.pushViewController(userGuide, animated: true)
            
        case 1:
            let contactUsViewController = ContactUsViewController()
            contactUsViewController.addCustomBackButton()
            self.navigationController?.pushViewController(contactUsViewController, animated: true)
            
        case 2:
            let fAQViewController = UserGuideViewController()
            fAQViewController.type = WebViewType.faqs.rawValue
            fAQViewController.titleLabel = titles[indexPath.row]
            fAQViewController.addCustomBackButton()
            self.navigationController?.pushViewController(fAQViewController, animated: true)
            
        case 3:
            let termsConditionsViewController = UserGuideViewController()
            termsConditionsViewController.addCustomBackButton()
            termsConditionsViewController.titleLabel = titles[indexPath.row]
            termsConditionsViewController.type = WebViewType.termsConditions.rawValue
            self.navigationController?.pushViewController(termsConditionsViewController, animated: true)
            
        default:
            let privacyPolicyViewController = UserGuideViewController()
            privacyPolicyViewController.addCustomBackButton()
            privacyPolicyViewController.titleLabel = titles[indexPath.row]
            privacyPolicyViewController.type = WebViewType.privacyPolicy.rawValue
            self.navigationController?.pushViewController(privacyPolicyViewController, animated: true)
        }
    }
}
