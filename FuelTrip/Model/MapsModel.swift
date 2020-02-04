//
//  MapsModel.swift
//  FuelTrip
//
//  Created by Tim Riedesel on 1/26/20.
//  Copyright © 2020 Tim Riedesel. All rights reserved.
//

import Foundation

struct MapsModel {
    
    var lengthInMeters : Int
    var distanceMiles : Double
    var costOfTrip : Double
    var numberOfGasStops : Int
    
    static let rangePerFill = 320.0 //Average of 32 Miles per Gallon
    static let fuelInTank = 11 //Average consumption per Gasstop (in  Gallon)
    let fuelPrice = 2.29 //Input of actual Gasprice on a later state
    static var pricePerFill = 25.19
    
//    var numberOfGasStops: Double {
//        return (Double(lengthInMeters) / Double(rangePerFill))
//    }
//    var costOfTrip: Double {
//        return (Double(lengthInMeters) * Double(pricePerFill))
//    }
//    var distanceMiles: Double {
//        return ((Double(lengthInMeters) * 0.000621371))
//    }
//
//    func numberOfGasStops(_ lengthInMeters: Int) -> Double {
//        let numberOfGasStops = (Double(lengthInMeters) * Double(pricePerFill))
//        return Double(numberOfGasStops)
//    }
}



