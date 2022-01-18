//
//  WeeklyTransactionsViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/26/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper

class WeeklyTransactionsViewController: UIViewController {

    // MARK: - Variables & Constants
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = Mapper<WeeklyTransactions>().map(JSONObject: [:])!
    var weekNumber: Int = 0
    var weekYear: Int = 0
    var isFirstLoad = true
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableWeeklyTransactionScreen.setLanguage(viewController: self)
        loadData()
    }
    
    func loadData() {
        
        dataSource.getEarnings(viewController: self, weekNumber: weekNumber, year: weekYear) { (result, error) in
            
            if error == nil {
                self.dataSource = result
                self.isFirstLoad = false
                self.tableView.reloadData()
            }
        }
    }
}

extension WeeklyTransactionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFirstLoad {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.weeklyTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WeeklyTransactionTableViewCell.cellForTableView(tableView: tableView)
        cell.configureCell(data: dataSource.weeklyTransactions[indexPath.row])
        return cell
    }
    
    // MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transactionDetailsViewController = TransactionDetailsViewController()
        transactionDetailsViewController.packageId = dataSource.weeklyTransactions[indexPath.row].packageId
        transactionDetailsViewController.addCustomBackButton()
        self.navigationController?.pushViewController(transactionDetailsViewController, animated: true)
    }
}
