//
//  ViewTransactionButtonTableViewCell.swift
//  Routehive
//
//  Created by Huzaifa on 9/26/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

protocol ViewTransactionButtonTableViewCellDelegate {
    func didTappedViewTransactionButton(cell: ViewTransactionButtonTableViewCell)
}

class ViewTransactionButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var viewTransactionButton: RoutehiveButton!
    @IBOutlet weak var ViewTransactionTopConstraint: NSLayoutConstraint!
    
    var delegate: ViewTransactionButtonTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> ViewTransactionButtonTableViewCell {
        let kViewTransactionButtonTableViewCellIdentifier = "kViewTransactionButtonTableViewCellIdentifier"
        tableView.register(UINib(nibName: "ViewTransactionButtonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kViewTransactionButtonTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kViewTransactionButtonTableViewCellIdentifier, for: indexPath) as! ViewTransactionButtonTableViewCell
        return cell
    }
    
    @IBAction func viewTransactionButtonTapped(_ sender: Any) {
        delegate?.didTappedViewTransactionButton(cell: self)
    }
}
