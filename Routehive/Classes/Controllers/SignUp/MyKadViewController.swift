//
//  MyKadViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/24/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper

class MyKadViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    
    
    @IBOutlet weak var stepsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sideAImageView: UIImageView!
    @IBOutlet weak var sideBImageView: UIImageView!
    @IBOutlet weak var sideAActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sideBActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sideAButton: UIButton!
    @IBOutlet weak var sideBButton: UIButton!
    
    @IBOutlet weak var nextButton: RoutehiveButton!
    @IBOutlet weak var frontSideLabel: UILabel!
    @IBOutlet weak var backSideLabel: UILabel!
    
    @IBOutlet weak var skckView: UIView!
    @IBOutlet weak var skckTitleLabel: UILabel!
    @IBOutlet weak var skckFrontSideImageView: UIImageView!
    @IBOutlet weak var skckSideAButton: UIButton!
    @IBOutlet weak var skckActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var skckFrontSideLabel: UILabel!
    
    var isUploadingSideAImage = false
    var isUploadingSideBImage = false
    var isUploadingSkckImage = false
    
    var errorUploadingImageA = ""
    var errorUploadingImageB = ""
    var errorImageProgress = ""
    var errorUploadingImageServer = ""
    
    var myKadUrls = MyKadUrls()
    var signIn = Mapper<SignIn>().map(JSON: [:])!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableMyKad.setLanguage(viewController: self)
        sideAActivityIndicator.isHidden = true
        sideBActivityIndicator.isHidden = true
        skckActivityIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Driver.shared.country == CountryType.Indonesia.rawValue {
            skckView.isHidden = false
            
        } else {
            skckView.isHidden = true
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func sideAButtonTapped(_ sender: Any) {
        
        if Driver.shared.country == CountryType.Indonesia.rawValue {
            
            if !isUploadingSideBImage && !isUploadingSkckImage {
                isUploadingSideAImage = true
                isUploadingSideBImage = false
                isUploadingSkckImage = false
                Utility.presentImagePicker(viewController: self)
                
            } else {
                NSError.showErrorWithMessage(message: errorImageProgress, viewController: self)
            }
            
        } else {
            
            if !isUploadingSideBImage {
                isUploadingSideAImage = true
                isUploadingSideBImage = false
                isUploadingSkckImage = false
                Utility.presentImagePicker(viewController: self)
                
            } else {
                NSError.showErrorWithMessage(message: errorImageProgress, viewController: self)
            }
        }
    }
    
    @IBAction func sideBButtonTapped(_ sender: Any) {
        
        if Driver.shared.country == CountryType.Indonesia.rawValue {
            
            if !isUploadingSideAImage && !isUploadingSkckImage {
                isUploadingSideBImage = true
                isUploadingSideAImage = false
                isUploadingSkckImage = false
                Utility.presentImagePicker(viewController: self)
                
            } else {
                NSError.showErrorWithMessage(message: errorImageProgress, viewController: self)
            }
            
        } else {
            
            if !isUploadingSideAImage {
                isUploadingSideBImage = true
                isUploadingSideAImage = false
                isUploadingSkckImage = false
                Utility.presentImagePicker(viewController: self)
                
            } else {
                NSError.showErrorWithMessage(message: errorImageProgress, viewController: self)
            }
        }
    }
    
    @IBAction func skckSideAButtonTapped(_ sender: Any) {
        
        if !isUploadingSideAImage && !isUploadingSideBImage {
            isUploadingSkckImage = true
            isUploadingSideAImage = false
            isUploadingSideBImage = false
            Utility.presentImagePicker(viewController: self)
            
        } else {
            NSError.showErrorWithMessage(message: errorImageProgress, viewController: self)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        if Driver.shared.country == CountryType.Indonesia.rawValue {
            
            if myKadUrls.mykadFronUrl == "" {
                NSError.showErrorWithMessage(message: errorUploadingImageA, viewController: self)
                nextButton.shake()
                return
                
            } else if myKadUrls.mykadBackUrl == "" {
                NSError.showErrorWithMessage(message: errorUploadingImageB, viewController: self)
                nextButton.shake()
                return
                
            } else if myKadUrls.skckUrl == "" {
                NSError.showErrorWithMessage(message: errorUploadingImageA, viewController: self)
                nextButton.shake()
                return
            }
            
        } else {
            
            if myKadUrls.mykadFronUrl == "" {
                NSError.showErrorWithMessage(message: errorUploadingImageA, viewController: self)
                nextButton.shake()
                return
                
            } else if myKadUrls.mykadBackUrl == "" {
                NSError.showErrorWithMessage(message: errorUploadingImageB, viewController: self)
                nextButton.shake()
                return
            }
        }
        
        signIn.uploadMyKad(viewController: self, myKadUrls: myKadUrls) { (result, error) in
            
            if error == nil {
                let drivingLicenseViewController = DrivingLicenseViewController()
                drivingLicenseViewController.addCustomBackButton()
                self.navigationController?.pushViewController(drivingLicenseViewController, animated: true)
            }
        }
    }
    
    // MARK: - Private Methods
    
    func uploadImage(pickedImage: UIImage) {
        
        if isUploadingSideAImage {
            self.sideAActivityIndicator.isHidden = false
            self.sideAActivityIndicator.startAnimating()
            
        } else if isUploadingSideBImage {
            self.sideBActivityIndicator.isHidden = false
            self.sideBActivityIndicator.startAnimating()
            
        } else if isUploadingSkckImage {
            self.skckActivityIndicator.isHidden = false
            self.skckActivityIndicator.startAnimating()
        }
        
        signIn.uploadImage(viewController: self, type: .identityDocumentsImages, pickedImage: pickedImage) { (success, ImageUrl) in
            
            if success {
                
                if self.isUploadingSideAImage {
                    self.isUploadingSideAImage = false
                    self.sideAActivityIndicator.isHidden = true
                    self.frontSideLabel.isHidden = true
                    self.sideAActivityIndicator.stopAnimating()
                    self.sideAImageView.image = pickedImage
                    self.myKadUrls.mykadFronUrl = ImageUrl
                    
                } else if self.isUploadingSideBImage {
                    self.isUploadingSideBImage = false
                    self.sideBActivityIndicator.isHidden = true
                    self.backSideLabel.isHidden = true
                    self.sideBActivityIndicator.stopAnimating()
                    self.sideBImageView.image = pickedImage
                    self.myKadUrls.mykadBackUrl = ImageUrl
                    
                } else if self.isUploadingSkckImage {
                    self.isUploadingSkckImage = false
                    self.skckActivityIndicator.isHidden = true
                    self.skckFrontSideLabel.isHidden = true
                    self.skckActivityIndicator.stopAnimating()
                    self.skckFrontSideImageView.image = pickedImage
                    self.myKadUrls.skckUrl = ImageUrl
                }
                
            } else {
                NSError.showErrorWithMessage(message: self.errorUploadingImageServer, viewController: self)
                
                if self.isUploadingSideAImage {
                    self.isUploadingSideAImage = false
                    self.sideAActivityIndicator.isHidden = true
                    self.sideAActivityIndicator.stopAnimating()
                    
                } else if self.isUploadingSideBImage {
                    self.isUploadingSideBImage = false
                    self.sideBActivityIndicator.isHidden = true
                    self.sideBActivityIndicator.stopAnimating()
                    
                } else if self.isUploadingSkckImage {
                    self.isUploadingSkckImage = false
                    self.skckActivityIndicator.isHidden = true
                    self.skckActivityIndicator.stopAnimating()
                }
            }
        }
    }
}

extension MyKadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.uploadImage(pickedImage: pickedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

class MyKadUrls {
    var mykadFronUrl = ""
    var mykadBackUrl = ""
    var skckUrl = ""
}
