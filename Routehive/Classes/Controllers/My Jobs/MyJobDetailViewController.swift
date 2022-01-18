//
//  MyJobDetailViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/27/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation

class MyJobDetailViewController: UIViewController {

    // MARK: - Variables & Constants
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationBlockView: UIView!
    @IBOutlet weak var locationBlockLabel: UILabel!
    
    var isFirstLoad = true
    var dataSource = Mapper<PackageDetails>().map(JSONObject: [:])!
    var locationManager = CLLocationManager()
    var dateFormatter = DateFormatter()
    var jobId = 0
    var isComingFromBackupDriverInfo = false
    
    var localizeable = LocalizedKeys()
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        
        if isComingFromBackupDriverInfo {
            isComingFromBackupDriverInfo = false
            loadData()
        }
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupViewControllerUI() {
        LocalizableMyJobDetailScreen.setLanguage(viewController: self)
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        dateFormatter.dateFormat = "h:mm a, dd MMM, yyyy"
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
                self.locationBlockView.isHidden = true
                self.tableView.reloadData()
                
                if result.package.packageLocations[0].isLocationBlocked {
                    self.locationBlockView.isHidden = false
                    self.locationBlockLabel.text = self.localizeable.locationBlockedMessagePickup
                }
                
                let isDropoffBlocked = result.package.packageLocations.filter{$0.isLocationBlocked == true}.count > 0 ? true : false
                
                if isDropoffBlocked {
                    self.locationBlockView.isHidden = false
                    self.locationBlockLabel.text = self.localizeable.locationBlockedMessageDropoff
                }
                
                if result.package.isEmergencyReported && result.package.isSameSP {
                    self.scrollToTop()
                }
            }
        }
    }
    
    func startJob() {
        
        dataSource.startJob(packageId: jobId, viewController: self) { (result, error) in
            
            if error == nil {
                self.loadData()
            }
        }
    }
    
    func arrivedAt(type: PickupDropoffType) {
        
        dataSource.arrivedAt(WithType: type, packageId: jobId, viewController: self) { (result, error) in
            
            if error == nil {
                self.loadData()
            }
        }
    }
    
    func sendCode(isPickupCode: Bool, code: String, imageUrl: String) {
        var type: ConfirmType
        
        if isPickupCode {
            type = .pickup
            
        } else {
            type = .dropoff
        }
        
        if Driver.shared.coordinatesArray.count > 2 {
            NSError.showErrorWithMessage(message: localizeable.errorRouteUpdate, viewController: self)
            
            if SocketIOManager.sharedInstance.socket?.status != .connected && SocketIOManager.sharedInstance.socket?.status != .connecting {
                SocketIOManager.sharedInstance.establishConnection()
            }
            
            if SocketIOManager.sharedInstance.socket?.status == .connected {
                SocketIOManager.sharedInstance.sendLocationToServer()
            }
            return
        }

        
        dataSource.confirm(WithType: type, packageId: jobId, code: code, dropoffImage: imageUrl, viewController: self) { (result, error) in
            self.loadData()
        }
    }
    
    func readyForNextDropoff() {
        
        dataSource.readyForNextDroppff(packageId: jobId, viewController: self) { (result, error) in
            
            if error == nil {
                self.loadData()
            }
        }
    }
    
    func completeJob() {
        
        if Driver.shared.coordinatesArray.count > 2 {
            NSError.showErrorWithMessage(message: localizeable.errorRouteUpdate, viewController: self)
            
            if SocketIOManager.sharedInstance.socket?.status != .connected && SocketIOManager.sharedInstance.socket?.status != .connecting {
                SocketIOManager.sharedInstance.establishConnection()
            }
            
            if SocketIOManager.sharedInstance.socket?.status == .connected {
                SocketIOManager.sharedInstance.sendLocationToServer()
            }
            return
        }
        
        dataSource.completeJob(packageId: jobId, viewController: self) { (result, error) in
            
            if error == nil {
                
                if self.dataSource.package.userType == 1 {
                    let jobCompletedPopupViewController = JobCompletedPopupViewController()
                    jobCompletedPopupViewController.modalPresentationStyle = .overCurrentContext
                    jobCompletedPopupViewController.delegate = self
                    jobCompletedPopupViewController.isFromHome = false
                    jobCompletedPopupViewController.dataSource = self.dataSource.package
                    self.present(jobCompletedPopupViewController, animated: true, completion: nil)
                    
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func rateUser(rating: Int) {
        
        dataSource.rateUser(packageId: jobId, rating: rating, viewController: self) { (result, error) in
            
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension MyJobDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFirstLoad {
            return 0
        }
        return dataSource.package.packageLocations.count + 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 || section == 1 {
            return 1
        }
        
        if section == dataSource.package.packageLocations.count + 1 {
            
            if dataSource.package.status == JobStatus.inProgress.rawValue {
                var isjobCompleted = false
                
                for location in dataSource.package.packageLocations {
                    
                    if location.locationType != 1 {
                        
                        if location.status == 1 {
                            isjobCompleted = false
                            break
                            
                        } else if location.status == 2 {
                            isjobCompleted = false
                            break
                            
                        } else if location.status == 3 {
                            isjobCompleted = false
                            break
                            
                        } else if location.status == 4 {
                            isjobCompleted = true
                        }
                    }
                }
                
                if isjobCompleted {
                    return 0
                }
            }
            
            if dataSource.package.isEmergencyReported || dataSource.package.status == JobStatus.inProgress.rawValue {
                return 0
            }
            
            return 1
        }
        
        return dataSource.package.packageLocations[section-1].items.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = JobDetailTopTableViewCell.cellForTableView(tableView: tableView)
            cell.delegate = self
            cell.configureCell(data: dataSource.package, indexPath: indexPath, localizable: localizeable)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = PickupTableViewCell.cellForTableView(tableView: tableView)
            cell.delegate = self
            cell.configureCell(data: dataSource.package, locationType: 1, indexPath: indexPath, localizable: localizeable)
            return cell
        }
        
        if indexPath.section == dataSource.package.packageLocations.count + 1 {
            
            if dataSource.package.status == JobStatus.inProgress.rawValue {
                let cell = ViewTransactionButtonTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.viewTransactionButton.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.5176470588, blue: 0.631372549, alpha: 1)
                cell.viewTransactionButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                cell.viewTransactionButton.setTitle(localizeable.emergencyButtonTitle, for: .normal)
                cell.ViewTransactionTopConstraint.constant = 20
                cell.delegate = self
                cell.viewTransactionButton.isHidden = true
                return cell
            }

            let cell = ViewTransactionButtonTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell.viewTransactionButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.viewTransactionButton.setTitleColor(#colorLiteral(red: 0.5490196078, green: 0.5607843137, blue: 0.662745098, alpha: 1), for: .normal)
            cell.viewTransactionButton.setTitle(localizeable.cancelButtonTitle, for: .normal)
            cell.ViewTransactionTopConstraint.constant = 20
            cell.delegate = self
            return cell
        }
        
        if indexPath.row == 0 {
            let cell = PickupTableViewCell.cellForTableView(tableView: tableView)
            cell.delegate = self
            cell.callButton.isHidden = false
            cell.configureCell(data: dataSource.package, locationType: 2, indexPath: indexPath, localizable: localizeable)
            return cell
        }
        
        let cell = ItemsTableViewCell.cellForTableView(tableView: tableView)
        cell.configureCell(data: dataSource.package, indexPath: indexPath, localizable: localizeable)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return UIView()
        }
        let header = PickupSectionTableViewCell.cellForTableView(tableView: tableView)
        header.delegate = self
        header.tag = section
        
        if section == 1 {
            
            header.locationIndexView.isHidden = true
            header.pickupLabel.text = localizeable.pickupLabel
            
            if dataSource.package.packageLocations[0].status == 3 {
                header.confirmationTimeLabel.isHidden = true
                header.tickImageView.isHidden = true
                header.viewAddressButton.isHidden = false
                header.pickupView.backgroundColor = #colorLiteral(red: 0, green: 0.6745098039, blue: 0.4078431373, alpha: 1)
                
                return header
                
            } else if dataSource.package.packageLocations[0].status == 4 {
                header.confirmationTimeLabel.isHidden = false
                header.confirmationTimeLabel.text = dataSource.package.packageLocations[0].pickDropTime.timeStringFromUnixTime(dateFormatter: dateFormatter)
                header.tickImageView.isHidden = false
                header.viewAddressButton.isHidden = false
                header.pickupView.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.4039215686, blue: 0.5568627451, alpha: 1)
                return header
                
            } else {
                header.confirmationTimeLabel.isHidden = true
                header.tickImageView.isHidden = true
                header.viewAddressButton.isHidden = false
                header.pickupView.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.4039215686, blue: 0.5568627451, alpha: 1)
                return header
            }
        }

        header.pickupLabel.text = localizeable.dropoffLabel
        header.locationIndexLabel.text = points[section - 2]
        header.locationIndexView.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.4039215686, blue: 0.5568627451, alpha: 1)
        header.locationIndexView.isHidden = false
        
        if dataSource.package.packageLocations[section - 1].status == 1 {
            header.confirmationTimeLabel.isHidden = true
            header.tickImageView.isHidden = true
            header.viewAddressButton.isHidden = false
            header.pickupView.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.4039215686, blue: 0.5568627451, alpha: 1)
            return header
            
        } else if dataSource.package.packageLocations[section - 1].status == 2 || dataSource.package.packageLocations[section - 1].status == 3 {
            header.confirmationTimeLabel.isHidden = true
            header.tickImageView.isHidden = true
            header.viewAddressButton.isHidden = false
            header.pickupView.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.0862745098, blue: 0.09019607843, alpha: 1)
            return header
            
        } else if dataSource.package.packageLocations[section - 1].status == 4 {
            header.confirmationTimeLabel.isHidden = false
            header.confirmationTimeLabel.text = dataSource.package.packageLocations[section - 1].pickDropTime.timeStringFromUnixTime(dateFormatter: dateFormatter)
            header.tickImageView.isHidden = false
            header.viewAddressButton.isHidden = false
            header.pickupView.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.4039215686, blue: 0.5568627451, alpha: 1)
            return header
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 || section == dataSource.package.packageLocations.count + 1 {
            return 0
        }
        
        return 31
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension MyJobDetailViewController: JobDetailTopTableViewCellDelegate, PickupTableViewCellDelegate, ViewTransactionButtonTableViewCellDelegate, ConfirmDropoffPopupViewControllerDelegate, JobCompletedPopupViewControllerDelegate, EmergencyConfirmationViewControllerDelegate, CancellationReasonsViewControllerDelegate, PickupSectionTableViewCellDelegate {
    
    // MARK: - PickupSectionTableViewCellDelegate
    
    func didTappedViewAddressButton(cell: PickupSectionTableViewCell) {
        
        let viewAddressViewControllerPopup = ViewAddressViewControllerPopup()
        viewAddressViewControllerPopup.modalPresentationStyle = .overCurrentContext
        
        
        if cell.tag == 1 {
            print(dataSource.package.packageLocations[0].primaryAddress)
            viewAddressViewControllerPopup.isPickup = true
            viewAddressViewControllerPopup.address = dataSource.package.packageLocations[0].primaryAddress
        } else {
            print(dataSource.package.packageLocations[cell.tag - 1].primaryAddress)
            viewAddressViewControllerPopup.isPickup = false
            viewAddressViewControllerPopup.address = dataSource.package.packageLocations[cell.tag - 1].primaryAddress
        }
        
        self.present(viewAddressViewControllerPopup, animated: true, completion: nil)
    }
    
    // MARK: - JobDetailTopTableViewCellDelegate
    
    func didTappedEmergencyDetailButton() {
        let backupDriverViewController = BackupDriverViewController()
        backupDriverViewController.addCustomBackButton()
        isComingFromBackupDriverInfo = true
        backupDriverViewController.dataSource = dataSource.package
        self.navigationController?.pushViewController(backupDriverViewController, animated: true)
    }
    
    func didTappedCallButton() {
        
        if dataSource.package.isEmergencyReported && !dataSource.package.isSameSP && !dataSource.package.emergencyPickupConfirmed {
            Utility.openDialerWith(number: dataSource.package.spData.phoneNumber)
            
        } else {
            Utility.openDialerWith(number: dataSource.package.userData.phoneNumber)
        }
    }
    
    func didTappedMessageButton() {
        
        if dataSource.package.isEmergencyReported && !dataSource.package.isSameSP && !dataSource.package.emergencyPickupConfirmed {
            Utility.openMapApplication(viewController: self, desitenationLat: String(dataSource.package.emergencyLat), desitenationLong: String(dataSource.package.emergencyLong))
            
        } else {
            let chatViewController = CustomChatViewController()
            chatViewController.addCustomBackButton()
            chatViewController.jobId = jobId
            chatViewController.userName = dataSource.package.userData.firstName + " " + dataSource.package.userData.lastName
            chatViewController.userImage = dataSource.package.userData.profileImage
            chatViewController.receiverId = dataSource.package.userId
            self.navigationController?.pushViewController(chatViewController, animated: true)
        }
    }
    
    func didTappedJobStateButton(cell: JobDetailTopTableViewCell) {
        
        if dataSource.package.isEmergencyReported && !dataSource.package.emergencyPickupConfirmed {
            
            if !dataSource.package.backupSPArrivedAtEmergency {
                
                dataSource.arrivedAtEmergencyLocation(packageId: jobId, viewController: self) { (result, error) in
                    
                    if error == nil {
                        self.loadData()
                    }
                }
                
            } else if !dataSource.package.emergencyPickupConfirmed {
                
                dataSource.confirmEmergencyLocation(packageId: jobId, viewController: self) { (result, error) in
                    
                    if error == nil {
                        self.loadData()
                    }
                }
            }
            
        } else {
            
            if dataSource.package.status == JobStatus.accepted.rawValue {
                startJob()
                
            } else if dataSource.package.status == JobStatus.arriving.rawValue {
                arrivedAt(type: .pickup)
                
            } else if dataSource.package.status == JobStatus.inProgress.rawValue {
                
                var isjobCompleted = false
                
                for location in dataSource.package.packageLocations {
                    
                    if location.locationType != 1 {
                        
                        if location.status == 1 {
                            isjobCompleted = false
                            readyForNextDropoff()
                            break
                            
                        } else if location.status == 2 {
                            isjobCompleted = false
                            arrivedAt(type: .dropoff)
                            break
                            
                        } else if location.status == 4 {
                            isjobCompleted = true
                        }
                    }
                }
                
                if isjobCompleted {
                    completeJob()
                }
            }
        }
    }
    
    // MARK: - PickupTableViewCellDelegate
    
    func didTappedAddCodeButton(cell: PickupTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        
        if dataSource.package.status == JobStatus.arriving.rawValue {
            
            if dataSource.package.packageLocations[0].status == 3 {
                
                if dataSource.package.packageLocations[0].isLocationBlocked {
                    Utility.openDialerWith(number: dataSource.package.contactMobileNumber)
                    
                } else {
                    let confirmDropoffPopupViewController = ConfirmDropoffPopupViewController()
                    confirmDropoffPopupViewController.modalPresentationStyle = .overCurrentContext
                    confirmDropoffPopupViewController.isAddPickupCode = true
                    
                    if dataSource.package.packageLocations[0].codeVerificationTriesLeft == 1 {
                        confirmDropoffPopupViewController.triesLeft = "\(dataSource.package.packageLocations[0].codeVerificationTriesLeft) " + localizeable.tryLeft
                        
                    } else {
                        confirmDropoffPopupViewController.triesLeft = "\(dataSource.package.packageLocations[0].codeVerificationTriesLeft) " + localizeable.triesLeft
                    }
                    
                    confirmDropoffPopupViewController.delegate = self
                    self.present(confirmDropoffPopupViewController, animated: true, completion: nil)
                }
            }
            
        } else if dataSource.package.status == JobStatus.inProgress.rawValue {
            
            if dataSource.package.packageLocations[(indexPath?.section)! - 1].isLocationBlocked {
                Utility.openDialerWith(number: dataSource.package.contactMobileNumber)
                
            } else {
                let confirmDropoffPopupViewController = ConfirmDropoffPopupViewController()
                confirmDropoffPopupViewController.modalPresentationStyle = .overCurrentContext
                confirmDropoffPopupViewController.isAddPickupCode = false
                
                if dataSource.package.packageLocations[(indexPath?.section)! - 1].codeVerificationTriesLeft == 1 {
                    confirmDropoffPopupViewController.triesLeft = "\(dataSource.package.packageLocations[(indexPath?.section)! - 1].codeVerificationTriesLeft) " + localizeable.tryLeft
                    
                } else {
                    confirmDropoffPopupViewController.triesLeft = "\(dataSource.package.packageLocations[(indexPath?.section)! - 1].codeVerificationTriesLeft) " + localizeable.triesLeft
                }
                
                if dataSource.package.packageLocations[(indexPath?.section)! - 1].dropoffNumber > 0 {
                    confirmDropoffPopupViewController.locationIndex = points[dataSource.package.packageLocations[(indexPath?.section)! - 1].dropoffNumber - 1]
                }
                
                confirmDropoffPopupViewController.delegate = self
                self.present(confirmDropoffPopupViewController, animated: true, completion: nil)
            }
        }
    }
    
    func didTappedNavigationButton(cell: PickupTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        
        if indexPath?.section == 1 {
            Utility.openMapApplication(viewController: self, desitenationLat: String(dataSource.package.packageLocations[0].latitude), desitenationLong: String(dataSource.package.packageLocations[0].longitude))
            
        } else {
            Utility.openMapApplication(viewController: self, desitenationLat: String(dataSource.package.packageLocations[(indexPath?.section)! - 1].latitude), desitenationLong: String(dataSource.package.packageLocations[(indexPath?.section)! - 1].longitude))
        }
    }
    
    func didTappedCallButton(cell: PickupTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        
        if dataSource.package.packageLocations[(indexPath?.section)! - 1].personAtLocation == 1 {
            Utility.openDialerWith(number: dataSource.package.userData.phoneNumber)
            
        } else {
            Utility.openDialerWith(number: dataSource.package.packageLocations[(indexPath?.section)! - 1].phoneNumber)
        }
    }
    
    // MARK: - ConfirmDropoffPopupViewControllerDelegate
    
    func didTappedConfirmButton(isPickupCode: Bool, code: String, imageUrl: String) {
        sendCode(isPickupCode: isPickupCode, code: code, imageUrl: imageUrl)
    }
    
    // MARK: - ViewTransactionButtonTableViewCellDelegate
    
    func didTappedViewTransactionButton(cell: ViewTransactionButtonTableViewCell) {
        
        let isDropoffBlocked = dataSource.package.packageLocations.filter{$0.isLocationBlocked == true}.count > 0 ? true : false

        if dataSource.package.packageLocations[0].isLocationBlocked || isDropoffBlocked {
            return
        }
        
        if dataSource.package.status == JobStatus.inProgress.rawValue {
            let emergencyConfirmationViewController = EmergencyConfirmationViewController()
            emergencyConfirmationViewController.delegate = self
            emergencyConfirmationViewController.packageId = jobId
            emergencyConfirmationViewController.addCustomBackButton()
            self.navigationController?.pushViewController(emergencyConfirmationViewController, animated: true)
            
        } else {
            let cancellationReasonsViewController = CancellationReasonsViewController()
            cancellationReasonsViewController.modalPresentationStyle = .overCurrentContext
            cancellationReasonsViewController.delegate = self
            self.present(cancellationReasonsViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - CancellationReasonsViewControllerDelegate
    
    func didTappedSubmitButton(isOther: Bool, reasonId: Int, reason: String) {
        
        dataSource.cancelJob(packageId: jobId, reasonId: reasonId, reason: reason, isOther: isOther, viewController: self) { (result, error) in
            
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - JobCompletedPopupViewControllerDelegate
    
    func didTappedSubmitButton(rating: Int) {
        rateUser(rating: rating)
    }
    
    // MARK: - EmergencyConfirmationViewControllerDelegate
    
    func emergencyConfirmed() {
        loadData()
    }
}

extension MyJobDetailViewController: ApplicationMainDelegate {
    
    func didReceiveJobCancelledEvent() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didReceiveBackupSpArrivedEvent() {
        loadData()
    }
    
    func didReceiveSpSwappedEvent() {
        loadData()
    }
    
    func didReceiveBackupSpConfirmPickupEvent() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didReceiveOfferAssignToAnotherEvent(packageId: Int) {
        
        if packageId == dataSource.package.id {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func didReceiveUnblockPackage() {
        loadData()
    }
}

class LocalizedKeys {
    var expressLabel = ""
    var pickupByLabel = ""
    var yourCustomerLabel = ""
    var messageButtonTitle = ""
    var callButtonTitle = ""
    var pickupLabel = ""
    var dropoffLabel = ""
    var quantityLabel = ""
    var emergencyButtonTitle = ""
    var addPickupCodeButtonTitle = ""
    var confirmDropoffButtonTitle = ""
    var pickupConfirmedButtonTitle = ""
    var dropoffConfirmedButtonTitle = ""
    var startJobButtonTitle = ""
    var arrivedAtPickupButtonTitle = ""
    var reachedAtDropOffButtonTitle = ""
    var readyForNextDropoffButtonTitle = ""
    var tapToCompleteButtonTitle = ""
    var cancelButtonTitle = ""
    
    var emergencyDriverLabel = ""
    var navigateButtonTitle = ""
    var emergencyInfoLabel = ""
    var driverAssignedLabel = ""
    var arrivedAtEmergencyButton = ""
    var confirmEmergencyButton = ""
    var errorRouteUpdate = ""
    var adminAssignedJob = ""
    
    var tryLeft = ""
    var triesLeft = ""
    var locationBlockedMessagePickup = ""
    var locationBlockedMessageDropoff = ""
    var contactAdmin = ""
    var itemValLabel = ""
}
