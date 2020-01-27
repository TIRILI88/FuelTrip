//
//  MapsManager.swift
//  FuelTrip
//
//  Created by Tim Riedesel on 1/26/20.
//  Copyright © 2020 Tim Riedesel. All rights reserved.
//

import Foundation
import CoreLocation
import TomTomOnlineUtils
import TomTomOnlineSDKRouting
import TomTomOnlineSDKSearch


protocol MapsManagerDelegate {
    func didUpdateLocation(_ mapsManager: MapsManager, map: MapsModel)
    func didFailWithError(error: Error)
}

struct MapsManager {
    
    let locationManager = CLLocationManager()
    var delegate: MapsManagerDelegate?
    
    
    //    let mapsURL = "https://api.tomtom.com/routing/1/calculateRoute/42.3314,83.0458:52.50274,13.43872/json?instructionsType=text&language=en-US&vehicleHeading=90&sectionType=traffic&report=effectiveSettings&routeType=eco&traffic=false&avoid=unpavedRoads&travelMode=car&vehicleMaxSpeed=120&vehicleCommercial=false&vehicleEngineType=combustion&key=MHKUzZjFRX7YGKlbsJmUc1myIpXkAKfz"
    
    let URLfirst = "https://api.tomtom.com/routing/1/calculateRoute/"
    let URLlast = "/json?instructionsType=text&language=en-US&vehicleHeading=90&sectionType=traffic&report=effectiveSettings&routeType=eco&traffic=false&avoid=unpavedRoads&travelMode=car&vehicleMaxSpeed=120&vehicleCommercial=false&vehicleEngineType=combustion&key=MHKUzZjFRX7YGKlbsJmUc1myIpXkAKfz"
    
    var originLat = "42.32939"
    var originLon = "-83.044933"
    var destinationLat : CLLocationDegrees = 42.32939
    var destinationLon : CLLocationDegrees = -83.044933
    
    
    func fetchOrigin(_ originLat: CLLocationDegrees,_ originLon: CLLocationDegrees) {
        let urlString = "\(URLfirst)\(originLat),\(originLon):\(destinationLat),\(destinationLon)\(URLlast)"
        performRequest(with: urlString)

    }
    
    
    
    func fetchDistance() {
        let urlString = "\(URLfirst)\(originLat),\(originLon):\(destinationLat),\(destinationLon)\(URLlast)"
        print(urlString)
        performRequest(with: urlString)
    }
    

    func performRequest(with urlString: String) {

        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let maps = self.parseJSON(safeData) {
                        self.delegate?.didUpdateLocation(self, map: maps)
                    }
                }
            }
            task.resume()
        }

    }

    func parseJSON(_ mapsData: Data) -> MapsModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MapsData.self, from: mapsData)
            let name = decodedData.name
            let distance = Float(decodedData.routes.legs.summary.lengthInMeters)
            print(name)
            print(distance ?? 0.00)
            let map = MapsModel(name: name, distance: distance ?? 0.00)
            return map
        } catch {
            delegate?.didFailWithError(error: error)
        }
        return nil
    }
    
}


