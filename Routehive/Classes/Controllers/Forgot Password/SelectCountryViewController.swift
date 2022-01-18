//
//  SelectCountryViewController.swift
//  TaxiTaxi
//
//  Created by Umair Afzal on 29/05/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireImage

protocol SelectCountryViewControllerDelegate {
    func didSelectCuontry(code: String, flag: UIImage)
}

class SelectCountryViewController: UIViewController {

    // MARK: - Variables & Constants

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var selectCountryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var delegate: SelectCountryViewControllerDelegate?
    var countryList = Mapper<CountryList>().map(JSON: [:])!

    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        loadData()
    }

    // MARK: - IBActions

    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Private Methods

    func loadData() {

        countryList.loadData(viewController: self) { (list, error) in
            self.countryList = list
            self.tableView.reloadData()
        }
    }
}

extension SelectCountryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CountryTableViewCell.cellForTableView(tableView: tableView)
        cell.countryLabel.text = countryList.countries[indexPath.row].name
        cell.flageImageView.image = #imageLiteral(resourceName: "flag_empty")

        cell.flageImageView.af_setImage(withURL:URL(string: countryList.countries[indexPath.row].imageUrl)!, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false, completion: {response in
            
        })
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        DispatchQueue.main.async {
            
            if let cell = tableView.cellForRow(at: indexPath) as? CountryTableViewCell {
                self.delegate?.didSelectCuontry(code: self.countryList.countries[indexPath.row].code, flag: (cell.flageImageView.image)!)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
