//
//  ViewController.swift
//  FuelTrip
//
//  Created by Tim Riedesel on 1/26/20.
//  Copyright © 2020 Tim Riedesel. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {

    @IBOutlet weak var destinationTextField: UITextField!
    
    let locationManager = CLLocationManager()
    var mapsManager = MapsManager()
    var mapsModel = MapsModel()
    var destinationText = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
 
        destinationTextField.delegate = self
        
    }
}

//MARK: - UITextField Delegate

extension InputViewController: UITextFieldDelegate {
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        //print(locationManager.requestLocation())
        
        
        destinationTextField.endEditing(true)
        locationManager.requestLocation()
        
        performSegue(withIdentifier: "goToTarget", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let destinationVC = segue.destination as! TargetViewController


    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        destinationTextField.endEditing(true)
        destinationTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.text = ""
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if destinationTextField.text != nil {
            destinationTextField.text! = mapsModel.name
            getLatLon(destinationTextField.text!)
            mapsManager.fetchDistance()
        }
        destinationTextField.text = ""
    }
    
    func getLatLon(_ address: String) {
        let geocoder = CLGeocoder()
        let address = address
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                //print("Lat: \(coordinates.latitude), Long: \(coordinates.longitude)")
                self.mapsManager.destinationLat = coordinates.latitude
                self.mapsManager.destinationLon = coordinates.longitude
                
            }
        })
    }
}


//MARK: - LocationManager Delegates

extension InputViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            mapsManager.fetchOrigin(lat, lon)
            //print("lat: \(lat), long: \(lon)")
        }
    }
}



