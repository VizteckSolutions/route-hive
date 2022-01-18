//
//  CancelPopupViewController.swift
//  Routehive
//
//  Created by Umair Afzal on 23/09/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import UIKit

protocol CancelPopupViewControllerDelegate {
    func didTappedYesButton()
}

class CancelPopupViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate : CancelPopupViewControllerDelegate?
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissOnTap()
        LocalizableCancelJobPopup.setLanguage(viewController: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.roundCorners(uiViewCorners: .top, radius: 20.0)
    }

    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        delegate?.didTappedYesButton()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
