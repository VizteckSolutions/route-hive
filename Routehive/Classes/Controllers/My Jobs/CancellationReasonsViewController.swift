//
//  CancellationReasonsViewController.swift
//  asas
//
//  Created by Umair Afzal on 21/09/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import UIKit
import ObjectMapper

protocol CancellationReasonsViewControllerDelegate {
    func didTappedSubmitButton(isOther: Bool, reasonId: Int, reason: String)
}

class CancellationReasonsViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var otherTextView: PlaceholderTextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: RoutehiveButton!
    
    var dataSource = Mapper<CancellationReasons>().map(JSONObject: [:])!
    var delegate: CancellationReasonsViewControllerDelegate?
    var isSelectOther = false
    var selectedReasonId = 0
    var isFirstLoad = true
    
    var errorEnterReason = ""
    var errorSelectReason = ""
    var otherLabel = ""
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableCancellationReason.setLanguage(viewController: self)
        self.dismissOnTap()
        otherTextView.isUserInteractionEnabled = false
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.roundCorners(uiViewCorners: .top, radius: 20)
    }
    
    // MARK: - Private Methods
    
    func loadData() {
        
        dataSource.fetchCancellationReasons(viewController: self) { (result, error) in
            
            if error == nil {
                self.dataSource = result
                self.isFirstLoad = false
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        if isSelectOther {
            
            if otherTextView.text.trimmingCharacters(in: .whitespaces) == "" {
                NSError.showErrorWithMessage(message: errorEnterReason, viewController: self)
                return
                
            } else {
                self.dismiss(animated: true, completion: nil)
                delegate?.didTappedSubmitButton(isOther: isSelectOther, reasonId: 0, reason: otherTextView.text)
                return
            }
        }
        
        for data in dataSource.reasons {
            
            if data.isSelected {
                self.dismiss(animated: true, completion: nil)
                delegate?.didTappedSubmitButton(isOther: isSelectOther, reasonId: data.id, reason: data.text)
                return
            }
        }
        
        NSError.showErrorWithMessage(message: errorSelectReason, viewController: self)
    }
}

extension CancellationReasonsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableView Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFirstLoad {
            return 0
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return dataSource.reasons.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            let cell = CancellationReasonTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell.leftLabel.text = dataSource.reasons[indexPath.row].text
            cell.rightLabel.text = ""
            
            if dataSource.reasons[indexPath.row].isSelected {
                cell.tickImageView.isHidden = false
                cell.leftLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                isSelectOther = false
                
            } else {
                cell.tickImageView.isHidden = true
                cell.leftLabel.textColor = #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.631372549, alpha: 1)
            }
            
            return cell
            
        default:
            
            let cell = CancellationReasonTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell.leftLabel.text = otherLabel
            cell.rightLabel.text = ""
            
            if isSelectOther {
                cell.leftLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.tickImageView.isHidden = false
                
            } else {
                cell.tickImageView.isHidden = true
                cell.leftLabel.textColor = #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.631372549, alpha: 1)
            }
            
            return cell
        }
    }
    
    // MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {

            for data in dataSource.reasons {
                data.isSelected = false
            }
            
            otherTextView.isUserInteractionEnabled = false
            isSelectOther = false
            dataSource.reasons[indexPath.row].isSelected = true
            
        } else {
            
            let _ = dataSource.reasons.map {
                $0.isSelected = false
            }
            
            otherTextView.isUserInteractionEnabled = true
            isSelectOther = true
        }
        
        tableView.reloadData()
    }
}
