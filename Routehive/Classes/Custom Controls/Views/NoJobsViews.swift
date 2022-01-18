//
//  NoJobsViews.swift
//  Labour Choice
//
//  Created by Umair on 07/07/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import UIKit

protocol NoJobsViewsDelegate {
    func didTapViewButton()
}

class NoJobsViews: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var viewButton: RoutehiveButton!
    
    var delegate: NoJobsViewsDelegate?
    
    class func instanceFromNib() -> NoJobsViews {
        return UINib(nibName: "NoJobsViews", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NoJobsViews
    }
    
    @IBAction func viewButtonTapped(_ sender: Any) {
        delegate?.didTapViewButton()
    }
}
