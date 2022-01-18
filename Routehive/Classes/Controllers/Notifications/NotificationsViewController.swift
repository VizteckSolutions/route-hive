//
//  NotificationsViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/24/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper

class NotificationsViewController: UIViewController {
    
    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    var offSet = 0
    var isFirstLoad = true
    var menuPickerView = UIPickerView()
    var dataSource = Mapper<NotificationsList>().map(JSONObject: [:])!
    let menuButton: UIButton = UIButton (type: UIButtonType.custom)
    
    var localizable = [String:String]()
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationControllerUI()
        Driver.shared.shouldOpenNotifications = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        LocalizableNotificationsScreen.setLanguage(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData(offset: 0)
    }
    
    func setupNavigationControllerUI() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        menuButton.setImage(#imageLiteral(resourceName: "icon_notfication_menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(self.menuButtonTapped(button:)), for: UIControlEvents.touchUpInside)
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let rightBarButton = UIBarButtonItem(customView: menuButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    // MARK: - Selectors
    
    @objc func menuButtonTapped(button: UIButton) {
        
        let alert = UIAlertController.init(title:localizable[LocalizableNotificationsScreen.chooseAction], message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let readAll = UIAlertAction(title:localizable[LocalizableNotificationsScreen.readAll], style: UIAlertActionStyle.default) { (action) in
            self.readAllNotifications()
        }
        
        let deleteAll = UIAlertAction(title:localizable[LocalizableNotificationsScreen.deleteAll], style: UIAlertActionStyle.default) { (action) in
            self.showAlert(message: self.localizable[LocalizableNotificationsScreen.deleteConfirmation] ?? "")
        }
        
        let cancelAction = UIAlertAction(title:localizable[LocalizableNotificationsScreen.cancel], style: UIAlertActionStyle.cancel)
        
        alert.addAction(readAll)
        alert.addAction(deleteAll)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    func readAllNotifications() {
        // type 1 for updating read status for all notifications
        dataSource.actionOnNotification(viewController: self, type: 1, completionBlock: { (result, error) in
          
            if error == nil {
                NSError.showErrorWithMessage(message: self.localizable[LocalizableNotificationsScreen.updateSuccess] ?? "", viewController: self, type: .success)
                self.loadData(offset: 0)
            }
        })
    }
    
    func deleteAllNotifications() {
        // type 2 for archiving/deleting all previous notifications
        dataSource.actionOnNotification(viewController: self, type: 2, completionBlock: { (result, error) in
            
            if error == nil {
                NSError.showErrorWithMessage(message: self.localizable[LocalizableNotificationsScreen.deleteSuccess] ?? "", viewController: self, type: .success)
                self.loadData(offset: 0)
            }
        })
    }
    
    func loadData(offset: Int) {
        
        if offset == 0 {
            self.offSet = 0
        }
        
        if self.offSet == -1 {
            return
        }
        
        dataSource.getNotificationsList(viewController: self, offset: self.offSet) { (result, error) in
            
            if error == nil {
                
                if self.offSet == 0 {
                    self.isFirstLoad = false
                    
                    if result.notificationsList.count == 0 {
                        self.menuButton.isHidden = true
                        Utility.emptyTableViewMessage(message: self.localizable[LocalizableNotificationsScreen.emptyScreenMessage] ?? "", viewController: self, tableView: self.tableView)
                        
                    } else {
                        self.menuButton.isHidden = false
                        self.tableView.backgroundView = UIView()
                    }
                    
                    self.dataSource = result
                    
                } else {
                    self.dataSource.notificationsList.append(contentsOf: result.notificationsList)
                }
                
                if result.notificationsList.count > 0 {
                    
                    if result.notificationsList.count < kOffSet {
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
    
    func showAlert(message: String) {
        
        let alertController = UIAlertController (title: message, message: "", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: localizable[LocalizableNotificationsScreen.yes], style: .default) { (_) -> Void in
            self.deleteAllNotifications()
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: localizable[LocalizableNotificationsScreen.no], style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFirstLoad {
            return 0
        }
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.notificationsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationTableViewCell.cellForTableView(tableView: tableView)
        cell.notificationDetailLabel.attributedText = dataSource.notificationsList[indexPath.row].message.htmlToAttributedString!
        cell.dateTimeLabel.text = dataSource.notificationsList[indexPath.row].timePassed
        
        if let imageUrl = URL(string: dataSource.notificationsList[indexPath.row].image) {
            cell.profileImageView.af_setImage(withURL: imageUrl)
        }
        
        if dataSource.notificationsList[indexPath.row].isRead {
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        } else {
            cell.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        }
        
        return cell
    }
    
    // MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !dataSource.notificationsList[indexPath.row].isRead {
            SocketIOManager.sharedInstance.markNotificationAsRead(notificationId: dataSource.notificationsList[indexPath.row].notificationId)
            dataSource.notificationsList[indexPath.row].isRead = true
            let indexPath = IndexPath(item: indexPath.row, section: 0)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        if dataSource.notificationsList[indexPath.row].status == 5 && dataSource.notificationsList[indexPath.row].shouldNavigate { // Completed status
            
            let transactionDetailsViewController = TransactionDetailsViewController()
            transactionDetailsViewController.addCustomBackButton()
            transactionDetailsViewController.packageId = dataSource.notificationsList[indexPath.row].packageId
            transactionDetailsViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(transactionDetailsViewController, animated: false)
            
        } else if dataSource.notificationsList[indexPath.row].status > 0 && dataSource.notificationsList[indexPath.row].status < 5 && dataSource.notificationsList[indexPath.row].shouldNavigate {
            let myJobDetailViewController = MyJobDetailViewController()
            myJobDetailViewController.addCustomBackButton()
            myJobDetailViewController.jobId = dataSource.notificationsList[indexPath.row].packageId
            myJobDetailViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(myJobDetailViewController, animated: false)
        }
    }
    
    // MARK: - UIScrollView Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            
            if dataSource.notificationsList.count >= kOffSet {
                loadData(offset: self.offSet)
            }
        }
    }
}

extension NotificationsViewController: ApplicationMainDelegate {
    
    func didReceiveJobCancelledEvent() {
        loadData(offset: self.offSet)
    }
    
    func didReceiveJobAccecptedEvent() {
        loadData(offset: self.offSet)
    }
    
    func didReceiveSpSwappedEvent() {
        loadData(offset: self.offSet)
    }
}
