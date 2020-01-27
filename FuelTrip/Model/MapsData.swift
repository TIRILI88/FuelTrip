//
//  MapsData.swift
//  FuelTrip
//
//  Created by Tim Riedesel on 1/26/20.
//  Copyright © 2020 Tim Riedesel. All rights reserved.
//

import Foundation

struct MapsData: Codable {
    let name: String
    let routes: Routes
}

struct Routes: Codable {
    let legs: Legs
}

struct Legs: Codable {
    let summary: Summary
    let points: [Points]
}

struct Summary: Codable {
    let lengthInMeters: String
    let travelTimeInSeconds: String
}

struct Points: Codable {
    let latitude: String
    let longitude: String
}
