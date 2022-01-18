//
//  MapViewTableViewCell.swift
//  test
//
//  Created by Mac on 9/23/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps
import ObjectMapper

class MapViewTableViewCell: UITableViewCell, GMSMapViewDelegate {

    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var distances = [Double]()
    var durations = [Double]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    class func cellForTableView(tableView: UITableView) -> MapViewTableViewCell {
        let kMapViewTableViewCellIdentifier = "kMapViewTableViewCellIdentifier"
        tableView.register(UINib(nibName: "MapViewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kMapViewTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kMapViewTableViewCellIdentifier) as! MapViewTableViewCell
        return cell
    }

    func configureCell(packageData: Package, pickupLabel: String) {
        
        UIView.animate(withDuration: 0.1) {
            self.etaLabel.text = String(packageData.estimatedTime) + " Mins - " + String(format: "%.0f", packageData.estimatedDistance) + " " + packageData.distanceUnit
        }
        
        APIClient.shared.getdistanceFromGoogleMap(data: packageData.packageLocations) { (result, error) in
            
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
                        var minTime = 0.0
                        var pos = 0
                        
                        for index in 0..<self.distances.count {
                            
                            if mindist > self.distances[index] {
                                mindist = self.distances[index]
                                minTime = self.durations[index]
                                pos = index
                            }
                        }
                        self.showPath(polyStr: data.routes[pos].polyline.points)
                        
                        for index in 0..<packageData.packageLocations.count {
                            //via:
                            if packageData.packageLocations[index].locationType != 1 {
                                let marker = GMSMarker()
                                marker.position = CLLocationCoordinate2D(latitude: packageData.packageLocations[index].latitude, longitude: packageData.packageLocations[index].longitude)
                                marker.icon = Utility.drawText(text: points[index - 1] as NSString, inImage: #imageLiteral(resourceName: "icon_dropoff_2"))
//                                dropoffMarkers.append(marker)
                                marker.map = self.mapView
                                
                            } else {
                                let marker = GMSMarker()
                                marker.position = CLLocationCoordinate2D(latitude: packageData.packageLocations[index].latitude, longitude: packageData.packageLocations[index].longitude)
                                let markerView = SourceMarkerIconView.instanceFromNib()
                                markerView.titleLabel.text = pickupLabel
                                markerView.frame = CGRect(x: 0, y: 0, width: 58, height: 20)
                                marker.iconView = markerView
                                marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                                marker.map = self.mapView
                            }
                        }
                        
                    } else {
                        self.showPath(polyStr: "")
                    }
                }
            }
        }
    }
    
    func showPath(polyStr :String) {
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = #colorLiteral(red: 0.5098039216, green: 0.5215686275, blue: 0.6352941176, alpha: 1)
        polyline.map = mapView // Your map view
        mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: polyline.path!), withPadding: 20))
    }
}
