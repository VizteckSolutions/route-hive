
//

import UIKit
import ObjectMapper

protocol ConfirmDropoffPopupViewControllerDelegate {
    func didTappedConfirmButton(isPickupCode: Bool, code: String, imageUrl: String)
}

class ConfirmDropoffPopupViewController: UIViewController {

    // MARK: - Variables & Constants
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var addPhotoView: UIView!
    @IBOutlet weak var addCodeTextField: RoutehiveTextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var triesLeftLabel: UILabel!
    
    var delegate: ConfirmDropoffPopupViewControllerDelegate?
    var dataSource = Mapper<SignIn>().map(JSONObject: [:])!
    
    var isAddPickupCode = false
    var triesLeft = ""
    var locationIndex = ""
    var photoImageUrl = ""
    
    var errorEmptyPhoto = ""
    var errorUploadPhoto = ""
    var errorEmptyCode = ""
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.roundCorners(uiViewCorners: .top, radius: 20)
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupViewControllerUI() {
        self.dismissOnTap()
        addCodeTextField.textFieldDelegate = self
        triesLeftLabel.text = triesLeft
        triesLeftLabel.isHidden = true
        addCodeTextField.isHidden = true
        
        if isAddPickupCode {
            addPhotoView.isHidden = true
            stackViewTopConstraint.constant = 0
            LocalizablePickupPopup.setLanguage(viewController: self)
            
        } else {
            LocalizableDropoffPopup.setLanguage(viewController: self)
            titleLabel.text?.append(" (\(locationIndex))")
        }
    }
    
    // MARK: - Private Methods
    
    func uploadImage(pickedImage: UIImage) {
        Utility.showLoading(viewController: self)
        
        dataSource.uploadImage(viewController: self, type: .dropOffCode, pickedImage: pickedImage) { (success, url) in
            Utility.hideLoading(viewController: self)
            
            if success {
                self.photoImageView.image = pickedImage
                self.photoImageUrl = url
                
            } else {
                NSError.showErrorWithMessage(message: self.errorUploadPhoto, viewController: self)
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
//        if addCodeTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
//            addCodeTextField.showErrorView(errorMessage: errorEmptyCode)
//            confirmButton.shake()
//            addCodeTextField.becomeFirstResponder()
//            return
//        }
        
        if !isAddPickupCode {
            
            if photoImageUrl == "" {
                NSError.showErrorWithMessage(message: errorEmptyPhoto, viewController: self)
                confirmButton.shake()
                return
            }
        }

        dismiss(animated: true, completion: nil)
        delegate?.didTappedConfirmButton(isPickupCode: isAddPickupCode, code: "", imageUrl: photoImageUrl)
    }
    
    @IBAction func uploadPhotoButtonTapped(_ sender: Any) {
        Utility.presentImagePicker(viewController: self)
    }
}

extension ConfirmDropoffPopupViewController: RoutehiveTextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadImage(pickedImage: pickedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - RoutehiveTextFieldDelegate
    
    func shouldChangeCharecter(_ textField: UITextField) {
        
        if let customTextfield = textField as? RoutehiveTextField {
            customTextfield.hideErrorView()
        }
    }
}
