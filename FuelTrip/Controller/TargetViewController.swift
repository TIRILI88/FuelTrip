//
//  TargetViewController.swift
//  FuelTrip
//
//  Created by Tim Riedesel on 1/26/20.
//  Copyright © 2020 Tim Riedesel. All rights reserved.
//

import UIKit
import CoreLocation

class TargetViewController: UIViewController, MapsManagerDelegate {
    
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var numberOfStopsLabel: UILabel!
    @IBOutlet weak var distanceInMilesLabel: UILabel!
    @IBOutlet weak var moneyForGasLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var mapsManager = MapsManager()
    var finalName = MapsManager.destinationName    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapsManager.delegate = self
        destinationLabel.text = finalName
        locationManager.requestLocation()
        
    }
    
    func fetchData(_ mapsManager: MapsManager, model: MapsModel) {
        print("didFetch before Main Thread fired")
        
        DispatchQueue.main.async {
            print("didFetchCity fired")
            print(model.lengthInMeters)
            self.numberOfStopsLabel.text = String(model.numberOfGasStops)
            self.distanceInMilesLabel.text = String(format: "%.0f", model.distanceMiles)
            self.moneyForGasLabel.text = String(format: "%.2f", model.costOfTrip)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - LocationManager Delegates

extension TargetViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation : CLLocation = locations[0] as CLLocation
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil) {
                print("error reverseGeoCode \(String(describing: error))")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let origin = String((placemark.first?.locality!)!)
                self.mapsManager.fetchDistance(origin)
            }
        }
    }
}

