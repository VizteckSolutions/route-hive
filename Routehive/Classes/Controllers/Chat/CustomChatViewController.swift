//
//  ChatViewController.swift
//  CustomChat
//
//  Created by Umair Afzal on 2/13/18.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import UIKit
import ObjectMapper
import IQKeyboardManagerSwift
import Alamofire
import AlamofireImage

class CustomChatViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Variables & Consrtants

    @IBOutlet weak var pickImageButton: UIButton!
    @IBOutlet weak var inputToolBarView: UIView!
    @IBOutlet weak var inputTextView: PlaceholderTextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputToolbarBottomConstraint : NSLayoutConstraint!
    var messages = [Message]()
    var totalMessages: Int = 0
    let avatarImageView = UIImageView()
    var isAppDelegate = false

    var offSet = 0
    var jobId = 0
    var receiverId = 0
    var userName = ""
    var userImage = ""
    var isPastChat = false
    var shouldAddCloseButton = false
    var isLoadingPreviosChat = false
    var shouldReloadCollectionView = false
    var participentsLabel = UILabel()
    var totalParticipents = 0
    var isFristLoad = false
    var emptyScreenMessage = ""
    
    var currentUserId = 0
    let imagePicker = UIImagePickerController()

    // MARK: - UIVIewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarUI()
        setupViewControllerUI()
        //createChatMembersView()
        loadPreviousChat()
        
        if Driver.shared.id == 0 {
            currentUserId = receiverId

        } else {
            currentUserId = Driver.shared.id
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().enable = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil) // To detect when keyboard is going to dismiss
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Driver.shared.isChatingWithId = Driver.shared.id
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        Driver.shared.isChatingWithId = 0

        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UIViewController Methods

    func setupViewControllerUI() {
        LocalizableChatScreen.setLanguage(viewController: self)
        self.title = userName
//        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInsetAdjustmentBehavior = .automatic
        self.navigationController?.navigationBar.isTranslucent = false
        tableView.keyboardDismissMode = .onDrag
        self.navigationController?.hidesBarsWhenKeyboardAppears = false
        tableView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        pickImageButton.isHidden = true // Not providing media sharing option

        inputTextView.delegate = self
//        inputTextView.layer.cornerRadius = 10
//        inputTextView.layer.borderWidth = 1.0
        inputTextView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 8, right: 5)
//        inputTextView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self

        if isPastChat {
            self.inputToolBarView.isHidden = true
        }
    }

    func setupNavigationBarUI() {
        
        let userImageButton: UIButton = UIButton (type: UIButtonType.custom)
        userImageButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        userImageButton.clipsToBounds = true
        userImageButton.contentMode = .scaleAspectFit
        userImageButton.layer.cornerRadius = userImageButton.frame.height / 2
        
        Alamofire.request(userImage).responseImage { response in
            
            if let image = response.result.value {
//                print("image downloaded: \(image)")
                let size = CGSize(width: 30.0, height: 30.0)
                // Scale image to size disregarding aspect ratio
                let scaledImage = image.af_imageScaled(to: size)
                let circularImage = scaledImage.af_imageRoundedIntoCircle()
                
                userImageButton.setImage(circularImage, for: .normal)
                let barButton2 = UIBarButtonItem(customView: userImageButton)
                self.navigationItem.rightBarButtonItem = barButton2
                
            } else {
                let size = CGSize(width: 30.0, height: 30.0)
                // Scale image to size disregarding aspect ratio
                let scaledImage = #imageLiteral(resourceName: "icon_default_image").af_imageScaled(to: size)
                let circularImage = scaledImage.af_imageRoundedIntoCircle()
                
                userImageButton.setImage(circularImage, for: .normal)
                let barButton2 = UIBarButtonItem(customView: userImageButton)
                self.navigationItem.rightBarButtonItem = barButton2
            }
        }
        
        
        
        if shouldAddCloseButton {
            let saveButton: UIButton = UIButton (type: UIButtonType.custom)
            saveButton.setTitle("Close", for: .normal)
            saveButton.setTitleColor(.white, for: .normal)
            saveButton.addTarget(self, action: #selector(self.closeButtontapped(button:)), for: UIControlEvents.touchUpInside)
            saveButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
            let barButton = UIBarButtonItem(customView: saveButton)
            navigationItem.leftBarButtonItem = barButton
        }
    }

    // MARK: - UIScrollView Delegate

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {

        if self.tableView.contentOffset.y <= 0 {
            // ScrollView is at top, Now call service to get previous messages
            if messages.count < self.totalMessages {
                self.loadEarlierMessages()
            }
        }
    }

    // MARK: - Manage TableView Bottom
    
   
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if self.tableView.contentOffset.y <= 0 {
            // ScrollView is at top, Now call service to get previous messages
            if messages.count < self.totalMessages {
                self.loadEarlierMessages()
            }
        }
    }

    // MARK: - Selectors

    @objc func keyboardWillAppear(_ notification : Notification) {

        if let keyboard = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue , let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            let keyboardHeight = keyboard.cgRectValue.height
            self.inputToolbarBottomConstraint.constant = keyboardHeight
            self.scrollToBttom()
            
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillDisappear(_ notification : Notification) {
        if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            self.inputToolbarBottomConstraint.constant = 0
            
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
       
        
        if inputTextView.text == "" {
            //pickImageButton.isHidden = false
        }
    }

    @objc func closeButtontapped(button : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - IBActions

    @IBAction func sendButtonTapped(_ sender: Any) {
        SocketIOManager.sharedInstance.sendMessage(message: inputTextView.text!, jobId: jobId, reciverId: receiverId)
        inputTextView.text = ""
        self.sendButton.isEnabled = false
        didFinishedSendingMessage()
    }

    @IBAction func pickImageTapped(_ sender: Any) {

        let alert = UIAlertController.init(title: "Select media for image", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)

        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }

        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)

        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)

    }

    // MARK:  Private Methods

    func createChatMembersView() {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: Utility.getScreenWidth(), height: 50))
        participentsLabel = UILabel(frame: CGRect(x: contentView.frame.origin.x + 10, y: 0.0, width: contentView.frame.width-10, height: contentView.frame.height))

        contentView.backgroundColor = UIColor.appThemeColor()
        participentsLabel.textAlignment = .center
        participentsLabel.textColor = UIColor.white
        participentsLabel.font = UIFont.appThemeFontWithSize(15.0)
        participentsLabel.numberOfLines = 0
        participentsLabel.text = "\("Total Members") (\(self.totalParticipents))"

        contentView.addSubview(participentsLabel)
        self.view.addSubview(contentView)
        self.view.bringSubview(toFront: contentView)
    }

    private func loadEarlierMessages() {
        Utility.showLoading(viewController: self)

        APIClient.shared.getPreviousChat(withPackageId: jobId, offset: offSet) { (result, error) in
            Utility.hideLoading(viewController: self)

            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)

                if error?.localizedDescription == "This conversation has been ended." {
                    self.navigationController?.popViewController(animated: true)
                }

            } else {

                if let data = Mapper<Messages>().map(JSONObject: result) {

                    if data.messages.count == 0  && self.messages.count == 0 {
//                        var message = "You can now chat"

//                        if self.isPastChat {
//                            message = "No chat history"
//                        }

                        Utility.emptyTableViewMessage(message: self.emptyScreenMessage, viewController: self, tableView: self.tableView)
                        

                    } else {
                        self.tableView.backgroundView = UIView()
                    }

                    data.messages.append(contentsOf: self.messages)
                    self.messages = data.messages
                    self.offSet += kOffSet
                    self.tableView.reloadData()
                }
            }
        }
    }

    func loadPreviousChat() {

        if isLoadingPreviosChat {
            return
        }

        isLoadingPreviosChat = true

        Utility.showLoading(viewController: self)
        self.inputTextView.isUserInteractionEnabled = false

        APIClient.shared.getPreviousChat(withPackageId: jobId, offset: offSet) { (result, error) in
            Utility.hideLoading(viewController: self)
            self.inputTextView.isUserInteractionEnabled = true
            self.isLoadingPreviosChat = false
            self.isFristLoad = true

            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)

                if error?.localizedDescription == "This conversation has been ended." {
                    self.navigationController?.popViewController(animated: true)
                }

            } else {

                if let data = Mapper<Messages>().map(JSONObject: result) {
                    self.totalParticipents = data.totalParticipant

                    if data.messages.count == 0  && self.messages.count == 0 {
//                        var message = "You can now chat"
//
//                        if self.isPastChat {
//                            message = "No chat history"
//                        }

                        Utility.emptyTableViewMessage(message: self.emptyScreenMessage, viewController: self, tableView: self.tableView)
                        self.tableView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)

                    } else {
                        self.tableView.backgroundView = UIView()
                    }

                    self.messages = []
                    self.totalMessages = data.totalMessages
                    self.messages = data.messages
                    self.offSet += kOffSet
                    self.tableView.reloadData()
                    self.scrollToBttom()
                }
            }
        }
    }

    private func didFinishedSendingMessage() {
        
        // Resize TextView to default size
        DispatchQueue.main.async {
            self.inputTextView.isScrollEnabled = false
            self.inputTextView.text = " "
            //self.inputTextView.resignFirstResponder()
            self.inputTextView.frame.size.height = 45.0
            self.inputToolBarView.layoutIfNeeded()
            self.inputToolBarView.layoutSubviews()
            self.inputToolBarView.setNeedsDisplay()
            self.inputTextView.text = ""
        }
    }

    func scrollToBttom() {

        if messages.count > 0 {
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}

extension CustomChatViewController {

    // MARK: - UITableView DataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if messages.count != 0 {
            self.tableView.backgroundView = UIView()
            self.tableView.backgroundView?.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        }

        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if messages[indexPath.row].senderType == SenderType.user.rawValue { // Other's Messages

            let cell = InComingChatTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell.configureCell(incomingBubbleViewBackgroundColor: #colorLiteral(red: 0.8117647059, green: 0.1882352941, blue: 0.2352941176, alpha: 1), incomingBubbleViewTextColor: .white, shouldShowProfileImage: false, messageFont: UIFont.appThemeFontWithSize(17.0))
            cell.profileImageView.isHidden = true
            cell.nameLabel.text = messages[indexPath.row].senderName
            cell.messageLabel.text = messages[indexPath.row].body
            cell.dateLabel.text = messages[indexPath.row].formattedDate
            return cell

        } else { // My messages

            let cell = OutGoingChatTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell.configureCell(outgoingBubbleViewBackgroundColor: .white, outgoingBubbleViewTextColor: #colorLiteral(red: 0.0431372549, green: 0.007843137255, blue: 0.0431372549, alpha: 1), shouldShowProfileImage: false, messageFont: UIFont.appThemeFontWithSize(17.0))
            cell.profileImageView.isHidden = true
            cell.nameLabel.text = ""
            cell.messageLabel.text = messages[indexPath.row].body
            cell.dateLabel.text = messages[indexPath.row].formattedDate
            return cell
        }
    }
}

extension CustomChatViewController: UITextViewDelegate {

    //  MARK: - UITextView Delegate

    func textViewDidBeginEditing(_ textView: UITextView) {
        pickImageButton.isHidden = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text == "" {
            //pickImageButton.isHidden = false
        }
    }

    func textViewDidChange(_ textView: UITextView) {

        if textView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            self.sendButton.isEnabled = false

        } else {
            self.sendButton.isEnabled = true
        }

        if textView.contentSize.height >= 100 { // Max height of textView
            textView.isScrollEnabled = true

        } else {
            textView.frame.size.height = textView.contentSize.height
            textView.isScrollEnabled = false
            self.view.layoutIfNeeded()
           
        }
    }
}

extension CustomChatViewController: ApplicationMainDelegate {

    // MARK: - ApplicationMainDelegate

    func didReceiveJobCancelledEvent() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func didReceiveOfferCancelledEvent(packageId: Int) {
        
        if packageId == self.jobId {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func didReceiveJobAccecptedEvent() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func didReceiveNewMessage(message: Message) {

        if jobId != message.packageId {
            return
        }
        
        if message.senderType == SenderType.user.rawValue {
            SocketIOManager.sharedInstance.markMessageAsRead(messageId: message.id)
        }
        
        messages.append(message)
        self.tableView.reloadData()
        self.scrollToBttom()
    }

    func reloadChat(packageId: Int) {
        
        if packageId == jobId {
            self.offSet = 0
            self.loadPreviousChat()
        }
    }
    
    func applicationDidBecomeActive() {
        self.offSet = 0
        self.loadPreviousChat()
    }
}

extension CGSize {
    func sizeByDelta(dw:CGFloat, dh:CGFloat) -> CGSize {
        return CGSize(width: self.width + dw, height: self.height + dh)
    }
}

class TriangleView : UIView {

    var fillColor = UIColor.red.cgColor

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
//        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
//        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX), y: rect.minY))

        context.setFillColor(fillColor)
        context.fillPath()
    }
}

