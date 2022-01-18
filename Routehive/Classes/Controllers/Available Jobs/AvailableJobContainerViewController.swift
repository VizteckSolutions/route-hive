//
//  AvailableJobContainerViewController.swift
//  Routehive
//
//  Created by Huzaifa on 10/1/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class AvailableJobContainerViewController: UIViewController {

    // MARK: - Variables & Constants
    
    private var activeViewController: UIViewController? {
        
        didSet {
            removeInactiveViewController(inactiveViewController: oldValue)
            updateActiveViewController()
        }
    }
    
    let jobListButton: UIButton = UIButton (type: UIButtonType.custom)
    
    var jobsMapViewController = AvailableJobsMapViewController()
    var jobsListViewController = AvailableJobsListViewController()
    
    // MARK - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationControllerUI()
        activeViewController = jobsMapViewController
    }
    
    func setupNavigationControllerUI() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        title = tabBarController?.tabBar.items![TabBarModules.availableJobs.rawValue].title
        jobListButton.tag = 0
        jobListButton.setImage(#imageLiteral(resourceName: "btn_list_view"), for: .normal)
        jobListButton.addTarget(self, action: #selector(self.jobListButtonTapped(button:)), for: UIControlEvents.touchUpInside)
        jobListButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: jobListButton)
        navigationItem.rightBarButtonItem = barButton
        
        let searchButton: UIButton = UIButton (type: UIButtonType.custom)
        searchButton.setImage(#imageLiteral(resourceName: "btn_search"), for: .normal)
        searchButton.addTarget(self, action: #selector(self.searchButtonTapped(button:)), for: UIControlEvents.touchUpInside)
        searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let leftBarButton = UIBarButtonItem(customView: searchButton)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    // MARK: - Selectors
    
    @objc func jobListButtonTapped(button: UIButton) {
        
        if jobListButton.tag == 0 {
            jobListButton.setImage(#imageLiteral(resourceName: "btn_map_view"), for: .normal)
            jobListButton.tag = 1
            activeViewController = jobsListViewController
            
        } else {
            jobListButton.setImage(#imageLiteral(resourceName: "btn_list_view"), for: .normal)
            jobListButton.tag = 0
            activeViewController = jobsMapViewController
        }
    }
    
    @objc func searchButtonTapped(button: UIButton) {
        let mapviewController = SearchViewController()
        mapviewController.delegate = self
        mapviewController.modalPresentationStyle = .overCurrentContext
        self.tabBarController?.present(mapviewController, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMove(toParentViewController: nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            addChildViewController(activeVC)
            
            activeVC.view.frame = self.view.bounds
            self.view.addSubview(activeVC.view)
            
            // call before adding child view controller's view as subview
            activeVC.didMove(toParentViewController: self)
        }
    }
}

extension AvailableJobContainerViewController: SearchViewControllerDelegate {
    
    func updateLocation(sourceCoordinates: CLLocationCoordinate2D, destinationCoordinates: CLLocationCoordinate2D) {
        
        if activeViewController == jobsMapViewController {
            jobsMapViewController.isFromSearch = true
            jobsMapViewController.loadData(sourceCoordinate: sourceCoordinates, destinationCoordinate: destinationCoordinates)
            
        } else {
            jobsListViewController.loadData(sourceCoordinate: sourceCoordinates, destinationCoordinate: destinationCoordinates, offset: 0)
        }
    }
}
