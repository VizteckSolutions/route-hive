

import UIKit
import ObjectMapper

protocol EmergencyConfirmationViewControllerDelegate {
    func emergencyConfirmed()
}

class EmergencyConfirmationViewController: UIViewController {
    
    // MARK: - Variables & Constants
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var addPhotoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: PlaceholderTextView!
    @IBOutlet weak var confirmButton: RoutehiveButton!
    @IBOutlet weak var emergencyReasonTextField: RoutehiveTextField!
    
    var dataSource = Mapper<Emergency>().map(JSONObject: [:])!
    var imageSource = Mapper<SignIn>().map(JSONObject: [:])!
    var delegate: EmergencyConfirmationViewControllerDelegate?
    
    var packageId = 0
    var reasonsPickerView = UIPickerView()
    var selectedReasonIndex = 0
    var photoImageUrl = ""
    
    var errorEmptyReason = ""
    var errorEmptyDescription = ""
    var errorEmptyPhoto = ""
    var errorUploadPhoto = ""
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableEmergency.setLanguage(viewController: self)
        emergencyReasonTextField.textFieldDelegate = self
        emergencyReasonTextField.setImageToRightView(image: #imageLiteral(resourceName: "arrow_down"), width: 15, height: 15)
        emergencyReasonTextField.inputView = reasonsPickerView
        reasonsPickerView.delegate = self
        reasonsPickerView.dataSource = self
        loadData()
    }
    
    // MARK: - Private Methods
    
    func loadData() {
        
        dataSource.getEmergencyReasons(viewController: self) { (result, error) in
            
            if error == nil {
                self.dataSource = result
                self.reasonsPickerView.reloadAllComponents()
            }
        }
    }
    
    func uploadImage(pickedImage: UIImage) {
        Utility.showLoading(viewController: self)
        
        imageSource.uploadImage(viewController: self, type: .dropOffCode, pickedImage: pickedImage) { (success, url) in
            Utility.hideLoading(viewController: self)
            
            if success {
                self.addPhotoImageView.image = pickedImage
                self.photoImageUrl = url
                
            } else {
                NSError.showErrorWithMessage(message: self.errorUploadPhoto, viewController: self)
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        
        if emergencyReasonTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            emergencyReasonTextField.showErrorView(errorMessage: errorEmptyReason)
            confirmButton.shake()
            emergencyReasonTextField.becomeFirstResponder()
            return
            
        } else if descriptionTextView.text?.trimmingCharacters(in: .whitespaces) == "" {
            NSError.showErrorWithMessage(message: errorEmptyDescription, viewController: self)
            return
            
        } else if addPhotoImageView.image == #imageLiteral(resourceName: "icon_default_image") {
            NSError.showErrorWithMessage(message: errorEmptyPhoto, viewController: self)
            return
        }
        
        Driver.shared.getCurrentAddress { (address) in
            
            if address != "" {
                
                self.dataSource.reportEmergency(viewController: self, packageId: self.packageId, emergencyReasonId: self.dataSource.reason[self.selectedReasonIndex].id, description: self.descriptionTextView.text, image: self.photoImageUrl, location: Driver.shared.locationManager.location!, address: address) { (result, error) in
                    
                    if error == nil {
                        self.delegate?.emergencyConfirmed()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func uploadImageButtonTapped(_ sender: Any) {
        Utility.presentImagePicker(viewController: self)
    }
}

extension EmergencyConfirmationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - UIPickerView Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.reason.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource.reason[row].text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if dataSource.reason.count > 0 {
            selectedReasonIndex = row
            emergencyReasonTextField.text = dataSource.reason[row].text
        }
    }
}

extension EmergencyConfirmationViewController: RoutehiveTextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
