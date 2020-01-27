//
//  TargetViewController.swift
//  FuelTrip
//
//  Created by Tim Riedesel on 1/26/20.
//  Copyright © 2020 Tim Riedesel. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class TargetViewController: UIViewController {
    
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var numberOfStopsLabel: UILabel!
    @IBOutlet weak var distanceInMilesLabel: UILabel!
    @IBOutlet weak var moneyForGasLabel: UILabel!
    

    let locationManager = CLLocationManager()
    var mapsManager = MapsManager()
    var mapsModel = MapsModel()
    var finalName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        locationManager.delegate = self
        mapsManager.delegate = self
        destinationLabel.text = mapsModel.name
    }
        
}


//MARK: - Maps Manager Delegate
extension TargetViewController: MapsManagerDelegate, CLLocationManagerDelegate {
  
    func didUpdateLocation(_ mapsManager: MapsManager, map: MapsModel) {
        DispatchQueue.main.async {
            self.destinationLabel.text = map.name
            self.distanceInMilesLabel.text = String(map.distance)
            self.numberOfStopsLabel.text = map.gasStops
            self.moneyForGasLabel.text = String(map.fuelPrice)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}


