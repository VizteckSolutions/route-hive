//
//  AvailableJobsMapViewController.swift
//  Routehive
//
//  Created by Huzaifa on 9/24/18.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import ObjectMapper
import GoogleMaps

class AvailableJobsMapViewController: UIViewController {
    
    // MARK: - IBOutlets & Variables
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var dotMarkerImageView: UIImageView!
    @IBOutlet weak var jobPopupBackgroundView: UIView!
    @IBOutlet weak var earningLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var dropoffAddressLabel: UILabel!
    @IBOutlet weak var pickupTimeImageView: UIImageView!
    @IBOutlet weak var pickupTimeLabel: UILabel!
    @IBOutlet weak var itemSizeImageView: UIImageView!
    @IBOutlet weak var itemSizeLabel: UILabel!
    
    var sourceMarker: GMSMarker?
    var jobsMarker = [GMSMarker]()
    var dropoffMarkers = [GMSMarker]()
    var polyline: GMSPolyline?
    var dateFormatter = DateFormatter()
    var distances = [Double]()
    var durations = [Double]()
    var isFromSearch = false
    var localizable = [String: String]()
    var localizableAppVersion = [String: String]()
    
    var dataSource = Mapper<PackageDetails>().map(JSONObject: [:])!
    var unRatedPackage = Mapper<UnRatedPackage>().map(JSONObject: [:])!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalizableAvailableJobsMapScreen.setLanguage(viewController: self)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        
        mapView.settings.myLocationButton = true
        let mapInsets = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
        mapView.padding = mapInsets
        dateFormatter.dateFormat = "h:mm a, d MMM"
        Driver.shared.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        jobPopupBackgroundView.roundCorners(uiViewCorners: .top, radius: 20.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocalizableAppVersionPopup.setLanguage(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        jobPopupBackgroundView.isHidden = true
        sourceMarker = nil
        if let polyl = polyline {
            polyl.map = nil
        }
        jobsMarker.removeAll()
        dropoffMarkers.removeAll()
        mapView.clear()
    }
    
    // MARK: - UIViewController Helper Methods
    
    func setupViewControllerUI() {
        self.dotMarkerImageView.isHidden = false
        mapView.delegate = self
        getTimeZone()
        handlePushTapped()
        self.movCameraPositionWithAnimation(coordinates: Driver.shared.locationManager.location?.coordinate ?? CLLocationCoordinate2D())
    }
    
    // MARK: - Private Methods
    
    func setupViewController() {
        NSLog("SelectedShortcutItem: \(Driver.shared.shouldChangeLanguage)")
        NSLog("SelectedShortcutItem: \(Driver.shared.shouldOpenEarnings)")
        NSLog("SelectedShortcutItem: \(Driver.shared.shouldOpenMyJobs)")
        getUnratedJobs()
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("********* Location Permition AuthorizedAlways **************")
            Driver.shared.startEmittingLocation()
            setupViewControllerUI()
            
        case .denied:
            print("********* Location Permition Denied **************")
            showLocationAlert()
            
        case .notDetermined:
            print("********* Location Permition NotDetermined **************")
            Driver.shared.locationManager.requestAlwaysAuthorization()
            Driver.shared.locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            print("********* Location Permition Restricted **************")
            showLocationAlert()
        }
        
        if Driver.shared.shouldOpenMyJobs {
            self.tabBarController?.selectedIndex = 1
            
        } else if Driver.shared.shouldOpenNotifications {
            self.tabBarController?.selectedIndex = 2
            
        } else if Driver.shared.shouldOpenEarnings || Driver.shared.shouldChangeLanguage {
            self.tabBarController?.selectedIndex = 3
        }
        
        checkAppVersion()
    }
    
    func checkAppVersion() {
        
        APIClient.shared.getAppVersion() { (result,error) in
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                
                if let data = Mapper<AppVersion>().map(JSONObject: result) {
                    Driver.shared.iosRiderAppUrl = data.iosRiderAppUrl
                    Driver.shared.androidRiderAppUrl = data.androidRiderAppUrl
                    let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
                    let version: String = nsObject as? String ?? "1.0"
                    let versionNumber = Int(version.replacingOccurrences(of: ".", with: ""))!
                    
                    if data.version > versionNumber {
                        let alert = UIAlertController(title: "", message: self.localizableAppVersion[LocalizableAppVersionPopup.FORCE_MESSAGE], preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: self.localizableAppVersion[LocalizableAppVersionPopup.FORCE_UPDATE], style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                            let appStoreLink = data.iosRiderAppUrl
                            
                            if let url = URL(string: appStoreLink), UIApplication.shared.canOpenURL(url) {
                                // Attempt to open the URL.
                                UIApplication.shared.open(url, options: [:], completionHandler: {(success: Bool) in
                                    if success {
                                        print("Launching \(url) was successful")
                                    }})
                            }
                        }))
                        
                        self.tabBarController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func movCameraPositionWithAnimation(coordinates: CLLocationCoordinate2D) {
        //marker movement animation
        CATransaction.begin()
        CATransaction.setValue(Int(0.0), forKey: kCATransactionAnimationDuration)
        let position = GMSCameraPosition(target: coordinates, zoom: 16, bearing: 0, viewingAngle: 0)
        self.mapView.animate(to: position)
        CATransaction.commit()
    }
    
    func handlePushTapped() {
        
        if Driver.shared.isFromPush {
            Driver.shared.isFromPush = false
            self.view.layoutIfNeeded()
            
            if Driver.shared.selectedPackageStatus == 1 {
                Driver.shared.selectedPackageStatus = 0
                let navigationController = UINavigationController()
                navigationController.setupAppThemeNavigationBar()
                //navigationController.addCustomCrossButton()
                
                let packageDetailViewController = AvailableJobDetailViewController()
                packageDetailViewController.jobId = Driver.shared.selectedPackageId
                
                navigationController.viewControllers = [packageDetailViewController]
                packageDetailViewController.addCustomCrossButton()
                
                self.present(navigationController, animated: true, completion: nil)
                
            } else {
                let navigationController = UINavigationController()
                navigationController.setupAppThemeNavigationBar()
                //navigationController.addCustomCrossButton()
                
                let packageDetailViewController = MyJobDetailViewController()
                packageDetailViewController.jobId = Driver.shared.selectedPackageId
                
                navigationController.viewControllers = [packageDetailViewController]
                packageDetailViewController.addCustomCrossButton()
                
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    func showLocationAlert() {
        
        let message = localizable[LocalizableAvailableJobsMapScreen.locationPermissionMessage] ?? ""
        
        let alertController = UIAlertController (title: message, message: "", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: localizable[LocalizableAvailableJobsMapScreen.settings] ?? "", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func loadData(sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        if isFromSearch {
            
            if sourceCoordinate.latitude == 0.0 && destinationCoordinate.latitude != 0.0 {
                movCameraPositionWithAnimation(coordinates: destinationCoordinate)
                
            } else if sourceCoordinate.latitude != 0.0 && destinationCoordinate.latitude == 0.0 {
                movCameraPositionWithAnimation(coordinates: sourceCoordinate)
                
            } else {
                let bounds = GMSCoordinateBounds(coordinate: sourceCoordinate, coordinate: destinationCoordinate)
                mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 150))
            }
        }
        
        if sourceCoordinate.latitude == 0.0 && destinationCoordinate.latitude == 0.0 {
            return
        }
        
        dataSource.fetchAvailableJobs(viewController: self, lat: sourceCoordinate.latitude, lng: sourceCoordinate.longitude, destLat: destinationCoordinate.latitude, destLong: destinationCoordinate.longitude, offset: 0) { (result, error) in
            
            if error == nil {
                self.dataSource = result
                self.populateJobMarkers()
                
            } else {
                self.jobsMarker.removeAll()
                self.mapView.clear()
                self.dotMarkerImageView.isHidden = false
                self.jobPopupBackgroundView.isHidden = true
                self.sourceMarker = nil
                
                if let polyl = self.polyline {
                    polyl.map = nil
                }
                
                for dropoff in self.dropoffMarkers {
                    dropoff.map = nil
                }
            }
            self.isFromSearch = false
        }
    }
    
    func getTimeZone() {
        
        APIClient.shared.getTimeZoneFromGoogle(location: Driver.shared.locationManager.location ?? CLLocation()) { (result, error) in
            
            if error == nil {
                
                if let data = Mapper<TimeZoneData>().map(JSONObject: result) {
                    
                    if data.status == "OK" {
                        self.updateTimeZone(timeZoneOffset: data.rawOffset / 60)
                    }
                }
                
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func updateTimeZone(timeZoneOffset: Int) {
        
        APIClient.shared.updateTimeZone(withTimeZoneOffset: timeZoneOffset) { (result, error) in
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
        }
    }
    
    func populateJobMarkers() {
        jobsMarker.removeAll()
        //        dropoffMarkers.removeAll()
        mapView.clear()
        
        for job in dataSource.jobs {
            
            for location in job.packageLocations {
                
                if location.locationType == 1 {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                    
                    if sourceMarker != nil {
                        
                        let data = sourceMarker?.userData as! Package
                        
                        if data.packageId == job.packageId {
                            let markerView = SourceMarkerIconView.instanceFromNib()
                            markerView.frame = CGRect(x: 0, y: 0, width: 58, height: 20)
                            markerView.titleLabel.text = localizable[LocalizableAvailableJobsMapScreen.pickupLabel]
                            marker.zIndex = Int32(location.packageId)
                            marker.iconView = markerView
                            sourceMarker?.iconView = nil
                            
                        } else {
                            let markerView = MarkerIconView.instanceFromNib()
                            markerView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                            markerView.distanceLabel.text = String(format: "%.0f", job.estimatedDistance)
                            markerView.distanceUnit.text = job.distanceUnit
                            marker.zIndex = Int32(location.packageId)
                            marker.iconView = markerView
                            marker.userData = job
                            jobsMarker.append(marker)
                        }
                        
                    } else {
                        let markerView = MarkerIconView.instanceFromNib()
                        markerView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                        markerView.distanceLabel.text = String(format: "%.0f", job.estimatedDistance)
                        markerView.distanceUnit.text = job.distanceUnit
                        marker.zIndex = Int32(location.packageId)
                        marker.iconView = markerView
                        marker.userData = job
                        jobsMarker.append(marker)
                    }
                    marker.map = mapView
                    break
                }
            }
        }
    }
    
    func showJobPopup(jobData: Package) {
        dotMarkerImageView.isHidden = true
        earningLabel.text = jobData.currency + " " + String(format: "%.2f", jobData.spEarnings)
        distanceLabel.text = "(\(jobData.distance) \(jobData.distanceUnit) \(localizable[LocalizableAvailableJobsMapScreen.awayLabel] ?? ""))"
        pickupAddressLabel.text = jobData.pickupAddress
        dropoffAddressLabel.text = jobData.dropoffAddress
        itemSizeLabel.text = jobData.packageItemsString
        
        if jobData.deliveryType == 1 {
            pickupTimeLabel.text = localizable[LocalizableAvailableJobsMapScreen.expressLabel] ?? ""
            
        } else {
            pickupTimeLabel.text = localizable[LocalizableAvailableJobsMapScreen.pickupByLabel] ?? "" + " " + jobData.scheduledTime.timeStringFromUnixTime(dateFormatter: dateFormatter)
        }
        
        if let url = URL(string: jobData.packageImage) {
            profileImageView.af_setImage(withURL: url)
        }
        
        Utility.showLoading(viewController: self)
        
        APIClient.shared.getdistanceFromGoogleMap(data: jobData.packageLocations) { (result, error) in
            Utility.hideLoading(viewController: self)
            
            if error != nil {
                //error?.showErrorBelowNavigation(viewController: self)
                print(error?.localizedDescription ?? "")
                
            } else {
                self.distances.removeAll()
                self.durations.removeAll()
                if let data = Mapper<Route>().map(JSONObject: result) {
                    
                    if data.routes.count > 0 {
                        
                        for route in data.routes {
                            var distance = 0.0
                            var duration = 0.0
                            
                            for leg in route.legs {
                                distance = distance + leg.value
                                duration = duration + leg.durationValue
                            }
                            
                            self.distances.append(distance)
                            self.durations.append(duration)
                        }
                        
                        var mindist = 0.0
//                        var minTime = 0.0
                        var pos = 0
                        
                        for index in 0..<self.distances.count {
                            
                            if mindist > self.distances[index] {
                                mindist = self.distances[index]
//                                minTime = self.durations[index]
                                pos = index
                            }
                        }
                        
                        //self.mapTitle = "\(maxTime/60) mins * \(maxdist/1000) km"
                        //Package.shared.totalKiloMeters = maxdist/1000
                        //self.infoLabel.text = self.mapTitle
                        self.showPath(polyStr: data.routes[pos].polyline.points, data: jobData)
                        
                    } else {
                        //                        NSError.showErrorWithMessage(message: "Unable to find route for your path, please change your drop off", viewController: self, type: .error, topConstraint: 60)
                        self.showPath(polyStr: "", data: nil)
                    }
                }
            }
        }
        
        jobPopupBackgroundView.isHidden = false
    }
    
    func showPath(polyStr :String, data: Package?) {
        
        if data == nil {
            return
        }
        
        let path = GMSPath(fromEncodedPath: polyStr)
        
        if let polyline = polyline {
            polyline.map = nil
        }
        
        polyline = GMSPolyline(path: path)
        polyline?.strokeWidth = 3.0
        polyline?.strokeColor = #colorLiteral(red: 0.5098039216, green: 0.5215686275, blue: 0.6352941176, alpha: 1)
        polyline?.map = mapView // Your map view
        
        if let location = data?.packageLocations {
            
            for index in 1..<location.count {
                //via:
                if location[index].locationType != 1 {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: location[index].latitude, longitude: location[index].longitude)
                    marker.icon = Utility.drawText(text: points[index - 1] as NSString, inImage: #imageLiteral(resourceName: "icon_dropoff_2"))
                    dropoffMarkers.append(marker)
                    marker.map = mapView
                }
            }
        }
        
        mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: self.polyline!.path!), withPadding: 80))
    }
    
    func hideJobPopup() {
        dotMarkerImageView.isHidden = false
        jobPopupBackgroundView.isHidden = true
        sourceMarker = nil
        
        if let polyl = polyline {
            polyl.map = nil
        }
        
        for dropoff in dropoffMarkers {
            dropoff.map = nil
        }
        
        loadData(sourceCoordinate: Driver.shared.lastLocation, destinationCoordinate: CLLocationCoordinate2D())
    }
    
    func getUnratedJobs() {
        
        unRatedPackage.fetchUnRatedJob(viewController: self) { (result, error) in
            
            if error == nil {
                
                if result.isUnratedPackageExist {
                    let jobCompletedPopupViewController = JobCompletedPopupViewController()
                    jobCompletedPopupViewController.modalPresentationStyle = .overCurrentContext
                    jobCompletedPopupViewController.homeDataSource = result
                    jobCompletedPopupViewController.isFromHome = true
                    self.tabBarController?.present(jobCompletedPopupViewController, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func selectedJobButtonTapped(_ sender: Any) {
        let data = sourceMarker?.userData as! Package
        let availableJobDetailViewController = AvailableJobDetailViewController()
        availableJobDetailViewController.addCustomBackButton()
        availableJobDetailViewController.jobId = data.packageId
        availableJobDetailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(availableJobDetailViewController, animated: true)
    }
    
}

extension AvailableJobsMapViewController: GMSMapViewDelegate, DriverDelegate {
    
    // MARK: - DriverDelegate
    
    func didChangeLocationAuthorization() {
        setupViewController()
    }
    
    // MARK: - GMSMapViewDelegate
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        movCameraPositionWithAnimation(coordinates: Driver.shared.lastLocation)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if marker.userData == nil {
            return false
        }
        //        selectedMarker = marker
        
        for dropoff in dropoffMarkers {
            dropoff.map = nil
        }
        
        let data = marker.userData as! Package
        
        if sourceMarker != nil {
            
            for jobmarker in jobsMarker {
                let jobsdata = jobmarker.userData as! Package
                
                if jobsdata.packageId == data.packageId {
                    jobmarker.map = nil
                }
            }
        }
        
        sourceMarker = marker
        populateJobMarkers()
        
        showJobPopup(jobData: data)
        print(data.packageId)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if !jobPopupBackgroundView.isHidden {
            hideJobPopup()
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            if self.jobPopupBackgroundView.isHidden && !self.isFromSearch {
                let centerCoordinate = self.mapView.projection.coordinate(for: self.mapView.center)
                self.loadData(sourceCoordinate: centerCoordinate, destinationCoordinate: CLLocationCoordinate2D())
            }
        }
    }
}

extension AvailableJobsMapViewController: ApplicationMainDelegate {
    
    func didReceiveNewJobEvent() {
        hideJobPopup()
        //        loadData(sourceCoordinate: Driver.shared.lastLocation, destinationCoordinate: CLLocationCoordinate2D())
    }
    
    func didReceiveJobAccecptedEvent() {
        hideJobPopup()
        //        loadData(sourceCoordinate: Driver.shared.lastLocation , destinationCoordinate: CLLocationCoordinate2D())
    }
    
    func applicationDidBecomeActive() {
        setupViewController()
    }
}
