//
//  ContactUsBottomTableViewCell.swift
//  Routehive
//
//  Created by Mac on 02/11/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

protocol ContactUsBottomTableViewCellDelegate {
    func didTappedFacebookButton()
    func didTappedTwitterButton()
    func didTappedInstaButton()
}
class ContactUsBottomTableViewCell: UITableViewCell {

    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var followUsLabel: UILabel!
    
    var delegate: ContactUsBottomTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView) -> ContactUsBottomTableViewCell {
        let kContactUsBottomTableViewCellIdentifier = "kContactUsBottomTableViewCellIdentifier"
        tableView.register(UINib(nibName: "ContactUsBottomTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kContactUsBottomTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kContactUsBottomTableViewCellIdentifier) as! ContactUsBottomTableViewCell
        return cell
    }
    
    @IBAction func fbButtonTapped(_ sender: Any) {
        delegate?.didTappedFacebookButton()
    }

    @IBAction func twitterButtonTapped(_ sender: Any) {
        delegate?.didTappedTwitterButton()
    }
    
    @IBAction func instaButtonTapped(_ sender: Any) {
        delegate?.didTappedInstaButton()
    }
}
