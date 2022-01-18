//
//  MapViewController.swift
//  EatenHunt
//
//  Created by yasir on 08/03/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol SearchViewControllerDelegate {
    func updateLocation(sourceCoordinates: CLLocationCoordinate2D, destinationCoordinates: CLLocationCoordinate2D)
}

class SearchViewController: UIViewController, GMSAutocompleteViewControllerDelegate {

    // MARK: - Variables & Constants
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var destinationLocationTextField: RoutehiveTextField!
    @IBOutlet weak var locationTextField: RoutehiveTextField!
    @IBOutlet weak var suggestionsTableView: UITableView!
    @IBOutlet weak var searchButton: RoutehiveButton!
    
    let kLocation = "CurrentLocation"

    var delegate: SearchViewControllerDelegate?
    var fetcher: GMSAutocompleteFetcher?
    var addressArray = [String]()
    var addressIdArray = [String]()
    var latitudeArray = [String]()
    var longitudeArray = [String]()

    var isSelectingSourceLocation = true
    var isSelectingDesinationLocation = false
    var sourceCoordinates = CLLocationCoordinate2D()
    var destinationCoordinates = CLLocationCoordinate2D()

    var errorEmptyFields = ""
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControlllerUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    // MARK: - UIViewController Helper Methods

    func setupViewControlllerUI() {
        LocalizableSearchAvailableJobs.setLanguage(viewController: self)
        
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        suggestionsTableView.estimatedRowHeight = 44.0
        suggestionsTableView.rowHeight = UITableViewAutomaticDimension

        Driver.shared.getCountry { (country) in
            // Set up the autocomplete filter.
            let filter = GMSAutocompleteFilter()
            filter.country = Driver.shared.countryISOCode
            
            // Create the fetcher.
            self.fetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
            self.fetcher?.delegate = self
        }
        
        locationTextField?.autoresizingMask = .flexibleWidth
        destinationLocationTextField?.autoresizingMask = .flexibleWidth
        locationTextField?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        destinationLocationTextField?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        locationTextField.delegate = self
        destinationLocationTextField.delegate = self
    }

    // MARK: - GMSAutocompleteViewControllerDelegate

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        dismiss(animated: true) {
            _ = CGPoint(x: (place.coordinate.latitude), y: (place.coordinate.latitude))
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: - UnComment this line
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    // MARK: - TextFiled Delegate Methods

    @objc func textFieldDidChange(textField: RoutehiveTextField) {

        if (textField.text?.count)! > 0 {
            fetcher?.sourceTextHasChanged(textField.text!)

        } else if textField.text?.count == 0 {
            addressArray.removeAll()
            addressIdArray.removeAll()
            latitudeArray.removeAll()
            longitudeArray.removeAll()
            suggestionsTableView.isHidden = true

        } else {
            addressArray.removeAll()
            addressIdArray.removeAll()
            latitudeArray.removeAll()
            longitudeArray.removeAll()
            suggestionsTableView.isHidden = true
            suggestionsTableView.reloadData()
        }
    }

    // MARK: - IBActions

    @IBAction func crossButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        if locationTextField.text?.trimmingCharacters(in: .whitespaces) == "" && destinationLocationTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            NSError.showErrorWithMessage(message: errorEmptyFields, viewController: self)
            
        } else if sourceCoordinates.latitude == 0.0 && destinationCoordinates.latitude == 0.0 {
            NSError.showErrorWithMessage(message: errorEmptyFields, viewController: self)
            
        } else {
            self.dismiss(animated: false, completion: nil)
            delegate?.updateLocation(sourceCoordinates: sourceCoordinates, destinationCoordinates: destinationCoordinates)
        }
    }
    
    // MARK: - Private Methods

    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()

        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in

            if let address = response?.firstResult() {
                let lines = address.lines!

                if self.isSelectingSourceLocation {
                    self.sourceCoordinates = coordinate
                    self.locationTextField.text = lines.joined(separator: " ")

                } else if self.isSelectingDesinationLocation {
                    self.destinationCoordinates = coordinate
                    self.destinationLocationTextField.text = lines.joined(separator: " ")
                }

                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    func getAddressFromPlaceId()  {
        let placesClient = GMSPlacesClient()

        for placeId in addressIdArray {

            placesClient.lookUpPlaceID(placeId, callback: { (places, error) -> Void in
                print(places as Any)
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }

                guard let place = places else {
                    return
                }

                if self.addressArray.contains("\(place.name ?? ""), \(place.formattedAddress!)") == false {

                    if (place.formattedAddress?.contains(place.name ?? "")) == false {
                        self.addressArray.append("\(place.name ?? ""), \(place.formattedAddress!)")

                    } else {
                        self.addressArray.append("\(place.formattedAddress!)")

                    }
                    self.suggestionsTableView.isHidden = false
                }

                self.latitudeArray.append(String(place.coordinate.latitude))
                self.longitudeArray.append(String(place.coordinate.longitude))
                print("Place name \(place.name ?? "")")
                print("Place address \(String(describing: place.formattedAddress))")
                print("Place placeID \(place.placeID ?? "")")
                print("Place attributions \(String(describing: place.attributions))")

                self.suggestionsTableView.reloadData()
            })
        }
    }

    // MARK: - Selectors

    @objc func deleteButtonTapped(button : UIButton) {
        locationTextField.text = ""
    }
}

extension SearchViewController : UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate, GMSAutocompleteFetcherDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressArray.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LocationCellTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)

        if indexPath.row == addressArray.count {
//            cell.addressLabel.text = "Set location on map"

        } else {
            cell.addressLabel.text = addressArray[indexPath.row]
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == addressArray.count {
            suggestionsTableView.isHidden = true
            locationTextField.resignFirstResponder()
            destinationLocationTextField.resignFirstResponder()
            return
        }

        if isSelectingSourceLocation {
            sourceCoordinates = CLLocationCoordinate2D(latitude: Double(latitudeArray[indexPath.row])!, longitude: Double(longitudeArray[indexPath.row])!)
            locationTextField.text = addressArray[indexPath.row]

        } else if isSelectingDesinationLocation {
            destinationCoordinates = CLLocationCoordinate2D(latitude: Double(latitudeArray[indexPath.row])!, longitude: Double(longitudeArray[indexPath.row])!)
            destinationLocationTextField.text = addressArray[indexPath.row]
        }

        print("\(addressArray[indexPath.row])")
        suggestionsTableView.isHidden = true
        _ = CLLocationCoordinate2D(latitude: Double(latitudeArray[indexPath.row])!, longitude: Double(longitudeArray[indexPath.row])!)
        locationTextField.resignFirstResponder()
        destinationLocationTextField.resignFirstResponder()
    }

    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        let resultsStr = NSMutableString()
        addressIdArray.removeAll()
        addressArray.removeAll()
        latitudeArray.removeAll()
        longitudeArray.removeAll()
        suggestionsTableView.reloadData()

        for prediction in predictions {
            resultsStr.appendFormat("%@\n", prediction.attributedSecondaryText!)
            addressIdArray.append(prediction.placeID)
        }
        getAddressFromPlaceId()
    }

    func didFailAutocompleteWithError(_ error: Error) {
    }

    // MARK: - UItextField Delegate

    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == locationTextField {
            isSelectingSourceLocation = true
            isSelectingDesinationLocation = false

        } else if textField == destinationLocationTextField {
            isSelectingDesinationLocation = true
            isSelectingSourceLocation = false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        suggestionsTableView.isHidden = true
    }
}
