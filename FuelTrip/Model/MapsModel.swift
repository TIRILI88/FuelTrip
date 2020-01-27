//
//  MapsModel.swift
//  FuelTrip
//
//  Created by Tim Riedesel on 1/26/20.
//  Copyright © 2020 Tim Riedesel. All rights reserved.
//

import Foundation

struct MapsModel {
    var name: String = "Tester"
    var distance: Float = 0.00
    let fuelRange = 32.000 //Average of 32 Miles per Gallon
    let fuelPrice = 2.29 //Input of actual Gasprice on a later state
    var gasStops = "5"
    var distanceMiles: Float = 0.00
    var gas: Double = 0.0
    
    func meterToMiles(_ distance: Float) -> Float {
        let distanceMiles = distance * 0.000621371
        return distanceMiles
    }
    
    
    func calculateStops() -> Double {
        let gas = Double(distance) / Double(fuelRange)
        return gas
    }
    
}



