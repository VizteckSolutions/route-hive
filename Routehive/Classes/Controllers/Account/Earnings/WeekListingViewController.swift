//
//  WeekListingViewController.swift
//  TT-Driver
//
//  Created by Umair Afzal on 02/08/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper

protocol WeekListingViewControllerDelegate {
    func didSelectWeek(weekNumber: Int, weekYear: Int)
}

class WeekListingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var dataSource = Mapper<Weeks>().map(JSON: [:])!
    var delegate: WeekListingViewControllerDelegate?
    
    var errorNoWeeks = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableWeekListingScreen.setLanguage(viewController: self)
        loadData()
    }

    // MARK: - Private Methods

    func loadData() {

        dataSource.getWeeksListing(viewController: self) { (result, error) in

            if error == nil {
                self.dataSource = result
                
                if result.weeks.count == 0 {
                    Utility.emptyTableViewMessage(message: self.errorNoWeeks, viewController: self, tableView: self.tableView)
                    
                } else {
                    self.tableView.backgroundView = UIView()
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension WeekListingViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.weeks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WeekListingTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        cell.earningLabel.text = ""
        cell.weekLabel.text = dataSource.weeks[indexPath.row].title
        return cell
    }

    // MARK: - UITableView Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectWeek(weekNumber: dataSource.weeks[indexPath.row].weekNumber, weekYear: dataSource.weeks[indexPath.row].weekYear)
        self.navigationController?.popViewController(animated: true)
    }
}
