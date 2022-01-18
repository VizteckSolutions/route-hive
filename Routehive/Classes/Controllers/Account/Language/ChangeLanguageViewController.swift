//
//  ChangeLanguageViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/26/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper

class ChangeLanguageViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var tableView: UITableView!
    let applyButton: UIButton = UIButton (type: UIButtonType.custom)
    var dataSource = Mapper<Languages>().map(JSON: [:])!
    var selectedLanguageCode = Driver.shared.languageCode
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Driver.shared.shouldChangeLanguage = false
        setupNavigationControllerUI()
        LocalizableLanguageScreen.setLanguage(viewController: self)
        laodData()
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupNavigationControllerUI() {
        applyButton.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0, blue: 0.03529411765, alpha: 1), for: .normal)
        applyButton.titleLabel?.font = UIFont.appThemeFontWithSize(17.0)
        applyButton.addTarget(self, action: #selector(self.applyButtonTapped(button:)), for: UIControlEvents.touchUpInside)
        applyButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        let barButton = UIBarButtonItem(customView: applyButton)
        navigationItem.rightBarButtonItem = barButton
    }
    
    // MARK: - Selectors
    
    @objc func applyButtonTapped(button: UIButton) {
        updateLanguage()
    }
    
    // MARK: - Private Methods
    
    func laodData() {
        
        dataSource.fetchLanguages(viewController: self) { (data, error) in
            self.dataSource = data
            self.selectedLanguageCode = Driver.shared.languageCode
            self.tableView.reloadData()
        }
    }
    
    func updateLanguage() {
        Driver.shared.languageCode = selectedLanguageCode
        APIClient.shared.resetApiClient()
        
        Utility.showLoading(viewController: self)
        APIClient.shared.fetchTranslations(lastUpdatedTime: 0) { (result, error) in
            
            if error == nil {
                
                if let data = result as? [String: AnyObject] {
                    
                    if let innerData = data["translations"] as? [String:String] {
                        
                        CoreDataHelper.clearLocalDB(completion: { (success, error) in
                            
                            if error == nil {
                                
                                CoreDataHelper.insertLanguage(usingDictionary: innerData, completion: { (success, error) in
                                    Utility.hideLoading(viewController: self)
                                    
                                    if error == nil {
                                        Utility.saveLanguageCodeInDefaults(languageCode: Driver.shared.languageCode)
                                        Utility.setupHomeViewController()
                                        
                                    } else {
                                        Utility.getLanguageCodeDefaults()
                                        APIClient.shared.resetApiClient()
                                    }
                                })
                            }
                        })
                    }
                }
            }
        }
    }
}

extension ChangeLanguageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChangeLanguageTableViewCell.cellForTableView(tableView: tableView)
        cell.titleLabel.text = dataSource.languages[indexPath.row].name
        
        if dataSource.languages[indexPath.row].code == selectedLanguageCode.replacingOccurrences(of: "/", with: "") {
            cell.titleLabel.textColor = #colorLiteral(red: 0.1450980392, green: 0.137254902, blue: 0.1450980392, alpha: 1)
            cell.tickImageView.isHidden = false
            
        } else {
            cell.titleLabel.textColor = #colorLiteral(red: 0.7098039216, green: 0.7058823529, blue: 0.7098039216, alpha: 1)
            cell.tickImageView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguageCode = dataSource.languages[indexPath.row].code + "/"
        tableView.reloadData()
    }
}
