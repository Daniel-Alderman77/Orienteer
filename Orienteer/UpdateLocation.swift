//
//  UpdateLocation.swift
//  Orienteer
//
//  Created by Hannah Svensson on 2015-12-09.
//  Copyright © 2015 COMP3222. All rights reserved.
//

import UIKit
import MapKit
class UpdateLocation: CLLocationManager {
    
    let requiredAccuracy: CLLocationAccuracy = 100.0
    
    var locManager = CLLocationManager()
    var locHeading = CLHeading()
    
    func getLocation(locManager: CLLocationManager, didUpdateLocations locations: [AnyObject]!)->NSArray{
        
        let locValue : CLLocationCoordinate2D = locManager.location!.coordinate
        let long = locValue.longitude
        let lat = locValue.latitude
        let locArray = [lat, long]
        return locArray
    }

    func getDirection(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) -> CLLocationDirection{
        let heading = newHeading.magneticHeading
        return heading
    }
    
    func getHeading() -> Double {
        let direction: CLLocationDirection = getDirection(locManager, didUpdateHeading: locHeading)
        let directionInRadians = direction / 180.0 * M_PI;
        return directionInRadians
    }
}
