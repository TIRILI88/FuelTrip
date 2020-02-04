//
//  MapsManager.swift
//  FuelTrip
//
//  Created by Tim Riedesel on 1/26/20.
//  Copyright © 2020 Tim Riedesel. All rights reserved.
//

import Foundation

protocol MapsManagerDelegate {
    func fetchData(_ mapsManager: MapsManager, model: MapsModel)
    func didFailWithError(error: Error)
}

struct MapsManager {
    
    var delegate: MapsManagerDelegate?
    
    static var destinationName = ""
    static var lengthInMeters: String = ""
    
    
    //    mapsURL = https://maps.googleapis.com/maps/api/distancematrix/json?origins=Seattle&destinations=San+Francisco&key=
    
    let URLfirst = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
    let apiKey = ""
    
    func fetchDistance(_ origin: String) {
        let urlString = "\(URLfirst)\(origin)&destinations=\(MapsManager.destinationName)&key=\(apiKey)"
        //print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            print(url)
            let encodedURL = URL(string: url)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: encodedURL!) { (data, response, error) in
                if error != nil {
                    print("urlString didnt work: \(String(describing: error))")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let model = self.parseJSON(mapsData: safeData) {
                        self.delegate?.fetchData(self, model: model)
                        print("Model from performRequest \(model)")
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(mapsData: Data) -> MapsModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MapsData.self, from: mapsData)
            let distance = decodedData.rows[0].elements[0].distance.value
            var distanceMiles: Double {
                return ((Double(distance) * 0.000621371))
            }
            var numberOfGasStops: Int {
                return Int(Double(distanceMiles) / Double(320))
            }
            var costOfTrip: Double {
                return Double(numberOfGasStops) * Double(25.19)
            }
            let model = MapsModel(lengthInMeters: distance, distanceMiles: distanceMiles, costOfTrip: costOfTrip, numberOfGasStops: numberOfGasStops)
            //print(model)
            return model
            
        } catch {
            print(error)
            return nil
        }
    }
}


