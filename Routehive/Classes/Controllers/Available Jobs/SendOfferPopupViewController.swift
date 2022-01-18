//
//  SendOfferPopupViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/28/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit

protocol SendOfferPopupViewControllerDelegate {
    func didTappedSubmitButton(viewController: SendOfferPopupViewController, proposal: String)
}

class SendOfferPopupViewController: UIViewController {
    
    // MARK: - Variables & Constants
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var commentsTextView: PlaceholderTextView!
    @IBOutlet weak var submitButton: RoutehiveButton!
    
    var delegate:SendOfferPopupViewControllerDelegate?
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableSendOfferPopup.setLanguage(viewController: self)
        self.dismissOnTap()
        commentsTextView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.roundCorners(uiViewCorners: .top, radius: 20.0)
    }
    
    // MARK: - IBActions
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        delegate?.didTappedSubmitButton(viewController: self, proposal: commentsTextView.text)
    }
}

extension SendOfferPopupViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = (textView.text as NSString?)?.replacingCharacters(in: range, with: text) else { return true }
        let currentLength: Int = currentText.count
        
        if currentLength <= 256 {
            characterCountLabel.text = String(currentLength) + "/256"
            
        } else {
            return false
        }
        
        return true
    }
}
