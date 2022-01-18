//
//  WeekEarningsTableViewCell.swift
//  TT-Driver
//
//  Created by yasir on 19/06/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

protocol WeekEarningsTableViewCellDelegate {
    func didSelectWeek()
}

class WeekEarningsTableViewCell: UITableViewCell {

    @IBOutlet weak var jobsCountLabel: UILabel!
    @IBOutlet weak var earningsLabel: UILabel!
    @IBOutlet weak var selectedWeekButton: UIButton!

    var delegate: WeekEarningsTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> WeekEarningsTableViewCell {
        let kWeekEarningsTableViewCellIdentifier = "kWeekEarningsTableViewCellIdentifier"
        tableView.register(UINib(nibName: "WeekEarningsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kWeekEarningsTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kWeekEarningsTableViewCellIdentifier, for: indexPath) as! WeekEarningsTableViewCell
        return cell
    }

    func configueCell(dataSource: WeeklyEarnings) {
        earningsLabel.text = dataSource.currency + " " + String(format: "%.2f", dataSource.spEarnedAmount)
        selectedWeekButton.setTitle(dataSource.weekTitle, for: .normal)
    }

    @IBAction func selectedWeekButtonTapped(_ sender: Any) {
        delegate?.didSelectWeek()
    }
}
