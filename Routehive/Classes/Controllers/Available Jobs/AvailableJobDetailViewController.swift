//
//  AvailableJobDetailViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/28/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireImage

class AvailableJobDetailViewController: UIViewController {

    // MARK: - Variables & Constants
    
    @IBOutlet weak var tableView: UITableView!
    
    var isFirstLoad = true
    var jobId = 0
    var dataSource = Mapper<PackageDetails>().map(JSONObject: [:])!
    
    var expressLabel = ""
    var pickupByLabel = ""
    
    var jobPostedByLabel = ""
    var offerSubmittedLabel = ""
    var pickupLabel = ""
    var dropoffLabel = ""
    var quantityLabel = ""
    var offerToDriveButtonTitle = ""
    var cancelButtonTitle = ""
    var itemValLabel = ""
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableAvailableJobDetailScreen.setLanguage(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViewControllerUI()
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupViewControllerUI() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        loadData()
    }
    
    // MARK: - Private Methods
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    func loadData() {
        
        dataSource.fetchPackageDetails(viewController: self, packageId: jobId) { (result, error) in
            
            if error == nil {
                self.dataSource = result
                self.isFirstLoad = false
                print(result.package.packageLocations.count)
                
                for loca in result.package.packageLocations {
                    
                    print(loca.items.count)
                }
                
                self.tableView.reloadData()
                self.scrollToTop()
            }
        }
    }
    
    func sendOffer(proposal: String) {
        
        dataSource.sendOffer(viewController: self, packageId: jobId, proposal: proposal) { (result, error) in
            
            if error == nil {
                let successfullPopupViewController = SuccessfullPopupViewController()
                successfullPopupViewController.modalPresentationStyle = .overCurrentContext
                successfullPopupViewController.isOfferSubmittedPopup = true
                successfullPopupViewController.delegate = self
                self.present(successfullPopupViewController, animated: true, completion: nil)
            }
        }
    }
}

extension AvailableJobDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFirstLoad {
            return 0
        }
        return dataSource.package.packageLocations.count + 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 || section == 2 {
            return 1
        }
        
        if section == 1 {
            
            if dataSource.package.isOfferSent {
                return 2
            }
            return 1
        }
        
        if section == dataSource.package.packageLocations.count + 2 {
            return 1
        }
        
        return dataSource.package.packageLocations[section-2].items.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = MapViewTableViewCell.cellForTableView(tableView: tableView)
            cell.configureCell(packageData: dataSource.package, pickupLabel: pickupLabel)
            return cell
        }
        
        if indexPath.section == 1 {
            
            switch indexPath.row {
                
            case 0:
                let cell = AvailableJobDetailTopTableViewCell.cellForTableView(tableView: tableView)
                cell.delegate = self
                
                if dataSource.package.deliveryType == 1 {
                    cell.pickupTimeLabel.text = expressLabel
                    
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mm a, d MMM"
                    cell.pickupTimeLabel.text = pickupByLabel + " " + dataSource.package.scheduledTime.timeStringFromUnixTime(dateFormatter: dateFormatter)
                }
                cell.jobPostedByLabel.text = jobPostedByLabel
                cell.configureCell(data: dataSource.package)
                return cell
                
            default:
                let cell = OfferSubmittedTableViewCell.cellForTableView(tableView: tableView)
                cell.offerSubmittedLabel.text = offerSubmittedLabel
                cell.nameLabel.text = Driver.shared.firstName.capitalized + " " + Driver.shared.lastName.capitalized
                cell.detailLabel.text = dataSource.package.offerProposal
                cell.timeLabel.text = dataSource.package.offerTimePassed
                
                if let url = URL(string: Driver.shared.profileImage) {
                    let filter = AspectScaledToFillSizeFilter(size: cell.profileImageView.frame.size)
                    cell.profileImageView.af_setImage(withURL: url, placeholderImage: nil, filter: filter)
                }
                
                return cell
            }
        }
        
        if indexPath.section == 2 {
            let cell = AvailableJobsDetailAddressTableViewCell.cellForTableView(tableView: tableView)
            cell.addressLabel.text = dataSource.package.packageLocations[0].primaryAddress
            cell.dotsView.isHidden = false
            return cell
        }
        
        if indexPath.section == dataSource.package.packageLocations.count + 2 {
            let cell = ViewTransactionButtonTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell.delegate = self
            
            if !dataSource.package.isOfferSent {
                
                cell.viewTransactionButton.setTitle(offerToDriveButtonTitle, for: .normal)
                cell.ViewTransactionTopConstraint.constant = 30.0
                cell.viewTransactionButton.backgroundColor = #colorLiteral(red: 0.8392156863, green: 0, blue: 0.03137254902, alpha: 1)
                cell.viewTransactionButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                return cell
                
            } else {
                cell.viewTransactionButton.setTitle(cancelButtonTitle, for: .normal)
                cell.viewTransactionButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.viewTransactionButton.setTitleColor(#colorLiteral(red: 0.5058823529, green: 0.5215686275, blue: 0.631372549, alpha: 1), for: .normal)
                cell.ViewTransactionTopConstraint.constant = 30.0
                return cell
            }
        }
        
        if indexPath.row == 0 {
            let cell = AvailableJobsDetailAddressTableViewCell.cellForTableView(tableView: tableView)
            
            if indexPath.section == dataSource.package.packageLocations.count + 1 {
                cell.dotsView.isHidden = true
                
            } else {
                cell.dotsView.isHidden = false
            }
            cell.addressLabel.text = dataSource.package.packageLocations[indexPath.section - 2].primaryAddress
            return cell
        }
        
        let cell = ItemsTableViewCell.cellForTableView(tableView: tableView)
        cell.itemDetailLabel.text = dataSource.package.packageLocations[indexPath.section - 2].items[indexPath.row - 1].name
        cell.itemQuantityLabel.text = dataSource.package.packageLocations[indexPath.section - 2].items[indexPath.row - 1].packageSize + " - \(quantityLabel): " + String(dataSource.package.packageLocations[indexPath.section - 2].items[indexPath.row - 1].quantity)
        cell.priceLabel.text = "\(itemValLabel)\(dataSource.package.packageLocations[indexPath.section - 2].items[indexPath.row - 1].estimatedPrice)"
//        cell.priceLabel.text = itemValLabel + "\(dataSource.package.currency) " + String(format: "%.2f", dataSource.package.packageLocations[indexPath.section - 2].items[indexPath.row - 1].estimatedPrice)
        
        if let url = URL(string: dataSource.package.packageLocations[indexPath.section - 2].items[indexPath.row - 1].image) {
            cell.profileImageView.af_setImage(withURL: url)
        }
        
        if indexPath.section == dataSource.package.packageLocations.count + 1 {
            cell.dotsView.isHidden = true
            
        } else {
            cell.dotsView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 || section == 1 {
            return UIView()
        }
        let header = PickupSectionTableViewCell.cellForTableView(tableView: tableView)
        header.tag = section
        header.delegate = self
        
        if section == 2 {
            
            header.locationIndexView.isHidden = true
            header.confirmationTimeLabel.isHidden = true
            header.tickImageView.isHidden = true
            header.viewAddressButton.isHidden = false
            header.pickupView.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.5215686275, blue: 0.631372549, alpha: 1)
            header.pickupLabel.text = pickupLabel
            return header
        }
        
        header.locationIndexView.isHidden = false
        header.confirmationTimeLabel.isHidden = true
        header.tickImageView.isHidden = true
        header.viewAddressButton.isHidden = false
        header.locationIndexView.backgroundColor = #colorLiteral(red: 0.8392156863, green: 0, blue: 0.03137254902, alpha: 1)
        header.pickupView.backgroundColor = #colorLiteral(red: 0.8392156863, green: 0, blue: 0.03137254902, alpha: 1)
        
        header.pickupLabel.text = dropoffLabel
        header.locationIndexLabel.text = points[section - 3]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 || section == 1 {
            return 0
        }
        
        if section == dataSource.package.packageLocations.count + 2 {
            return 0
        }
        return 31
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension AvailableJobDetailViewController: ViewTransactionButtonTableViewCellDelegate, SuccessfullPopupViewControllerDelegate, SendOfferPopupViewControllerDelegate, CancelPopupViewControllerDelegate, AvailableJobDetailTopTableViewCellDelegate, PickupSectionTableViewCellDelegate {
    
    // MARK: - PickupSectionTableViewCellDelegate
    
    func didTappedViewAddressButton(cell: PickupSectionTableViewCell) {
        let viewAddressViewControllerPopup = ViewAddressViewControllerPopup()
        viewAddressViewControllerPopup.modalPresentationStyle = .overCurrentContext
        
        
        if cell.tag == 2 {
            print(dataSource.package.packageLocations[0].primaryAddress)
            viewAddressViewControllerPopup.isPickup = true
            viewAddressViewControllerPopup.address = dataSource.package.packageLocations[0].primaryAddress
            
        } else {
            print(dataSource.package.packageLocations[cell.tag - 2].primaryAddress)
            viewAddressViewControllerPopup.isPickup = false
            viewAddressViewControllerPopup.address = dataSource.package.packageLocations[cell.tag - 2].primaryAddress
        }
        self.present(viewAddressViewControllerPopup, animated: true, completion: nil)
    }
    
    // MARK: - AvailableJobDetailTopTableViewCellDelegate
    
    func didTappedMessageButton() {
        let chatViewController = CustomChatViewController()
        chatViewController.addCustomBackButton()
        chatViewController.jobId = jobId
        chatViewController.userName = dataSource.package.userData.firstName + " " + dataSource.package.userData.lastName
        chatViewController.userImage = dataSource.package.userData.profileImage
        chatViewController.receiverId = dataSource.package.userId
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    // MARK: - ViewTransactionButtonTableViewCellDelegate
    
    func didTappedViewTransactionButton(cell: ViewTransactionButtonTableViewCell) {
        
        if !dataSource.package.isOfferSent {
            let sendOfferPopupViewController = SendOfferPopupViewController()
            sendOfferPopupViewController.modalPresentationStyle = .overCurrentContext
            sendOfferPopupViewController.delegate = self
            self.present(sendOfferPopupViewController, animated: true, completion: nil)
            
        } else {
            let cancelPopupViewController = CancelPopupViewController()
            cancelPopupViewController.modalPresentationStyle = .overCurrentContext
            cancelPopupViewController.delegate = self
            self.present(cancelPopupViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - SendOfferPopupViewControllerDelegate
    
    func didTappedSubmitButton(viewController: SendOfferPopupViewController, proposal: String) {
        sendOffer(proposal: proposal)
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - SuccessfullPopupViewControllerDelegate
    
    func didTappedContinueButton(viewController: SuccessfullPopupViewController) {
        viewController.dismiss(animated: true, completion: nil)
        loadData()
    }
    
    // MARK: - CancelPopupViewControllerDelegate
    
    func didTappedYesButton() {
        
        dataSource.cancelOffer(packageId: jobId, viewController: self) { (result, error) in
            
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AvailableJobDetailViewController: ApplicationMainDelegate {
    
    func didReceiveJobAccecptedEvent() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didReceiveOfferCancelledEvent(packageId: Int) {
        
        if packageId == jobId {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func didReceiveEmergencyPackageAssignedEvent() {
        loadData()
    }
    
    func didReceiveNewMessage(message: Message) {
        
        if message.packageId == jobId {
            dataSource.package.messageCount += 1
            tableView.reloadData()
        }
    }
    
    func reloadChat(packageId: Int) {
        
        if packageId == jobId {
            loadData()
        }
    }
}
