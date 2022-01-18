//
//  CostBreakDownTableViewCell.swift
//  asas
//
//  Created by Umair Afzal on 21/09/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import UIKit

class CancellationReasonTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> CancellationReasonTableViewCell {
        let kCancellationReasonTableViewCellIdentifier = "kCancellationReasonTableViewCellIdentifier"
        tableView.register(UINib(nibName: "CancellationReasonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kCancellationReasonTableViewCellIdentifier)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kCancellationReasonTableViewCellIdentifier, for: indexPath) as! CancellationReasonTableViewCell
        
        return cell
    }
}
