//
//  EarningsViewController.swift
//  TT-Driver
//
//  Created by yasir on 11/06/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper

class EarningsViewController: UIViewController {

    //MARK: - Variables & Constants
    
    @IBOutlet weak var tableView: UITableView!

    var dataSource = Mapper<WeeklyEarnings>().map(JSON: [:])!
    
    var weekNumber: Int = 0
    var weekYear: Int = 0
    var isFirstLoad = true
    var isCurrentWeek = true
    
    var viewTransactionButtonTitle = ""
    var jobLabel = ""
    var jobsLabel = ""

    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        Driver.shared.shouldOpenEarnings = false
        setupViewControllerUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isFirstLoad {
            let calendar = Calendar(identifier: .iso8601)
            self.weekNumber = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
            self.weekYear = calendar.component(.year, from: Date.init(timeIntervalSinceNow: 0))
        }

        loadData()
    }
    
    // MARK: - UIViewController Helper Methods

    func setupViewControllerUI() {
        LocalizableEarningsScreen.setLanguage(viewController: self)
    }

    func setupNavigationBarUI() {
    }

    // MARK: - Selectors

    // MARK: - Private Methods

    func loadData() {

        if isFirstLoad {
            isFirstLoad = false
        }
        
        dataSource.getEarnings(viewController: self, weekNumber: weekNumber, year: weekYear) { (data, error) in
            self.dataSource = data
            self.tableView.reloadData()
        }
    }
}

extension EarningsViewController: UITableViewDelegate, UITableViewDataSource, WeekEarningsTableViewCellDelegate, WeekListingViewControllerDelegate, ViewTransactionButtonTableViewCellDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {

        case 0:
            let cell = WeekEarningsTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            
            if dataSource.totalJobCount == 1 || dataSource.totalJobCount == 0 {
                cell.jobsCountLabel.text = "(\(dataSource.totalJobCount) \(jobLabel))"
                
            } else {
                cell.jobsCountLabel.text = "(\(dataSource.totalJobCount) \(jobsLabel))"
            }
            cell.configueCell(dataSource: dataSource)
            cell.delegate = self
            return cell

        case 1:
            let cell = ChartTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell.configureCell(dataSource: dataSource, isCurrentWeek: isCurrentWeek, weekNumber: weekNumber, weekYear: weekYear)
            return cell

        default:
            let cell = ViewTransactionButtonTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell.viewTransactionButton.setTitle(viewTransactionButtonTitle, for: .normal)
            
            if dataSource.totalJobCount > 0 {
                cell.viewTransactionButton.isUserInteractionEnabled = true
                cell.viewTransactionButton.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.1607843137, blue: 0.137254902, alpha: 1)
                
            } else {
                cell.viewTransactionButton.isUserInteractionEnabled = false
                cell.viewTransactionButton.backgroundColor = #colorLiteral(red: 0.5882352941, green: 0.5803921569, blue: 0.5882352941, alpha: 1)
            }
            cell.delegate = self
            return cell
        }
    }

    // MARK: - WeekEarningsTableViewCellDelegate

    func didSelectWeek() {
        let weekListingViewController = WeekListingViewController()
        weekListingViewController.delegate = self
        weekListingViewController.addCustomBackButton()
        weekListingViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(weekListingViewController, animated: true)
    }

    // MARK: - WeekListingViewControllerDelegate

    func didSelectWeek(weekNumber: Int, weekYear: Int) {

        // find current week
        let calendar = Calendar(identifier: .iso8601)
        let currentWeek = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        let currentYear = calendar.component(.year, from: Date.init(timeIntervalSinceNow: 0))

        if weekNumber == currentWeek && currentYear == weekYear {
            self.isCurrentWeek = true

        } else {
            self.isCurrentWeek = false
        }

        self.weekNumber = weekNumber
        self.weekYear = weekYear
        loadData()
    }
    
    // MARK: - ViewTransactionButtonTableViewCellDelegate
    
    func didTappedViewTransactionButton(cell: ViewTransactionButtonTableViewCell) {
        let weeklyTransactionsViewController = WeeklyTransactionsViewController()
        weeklyTransactionsViewController.weekNumber = weekNumber
        weeklyTransactionsViewController.weekYear = weekYear
        weeklyTransactionsViewController.addCustomBackButton()
        self.navigationController?.pushViewController(weeklyTransactionsViewController, animated: true)
    }
}
