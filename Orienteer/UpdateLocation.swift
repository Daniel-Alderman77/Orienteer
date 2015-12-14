//
//  UpdateLocation.swift
//  Orienteer
//
//  Created by Hannah Svensson on 2015-12-09.
//  Copyright © 2015 COMP3222. All rights reserved.
//

import UIKit
import CoreLocation

class UpdateLocation: CLLocationManager, CLLocationManagerDelegate {
    
    let requiredAccuracy: CLLocationAccuracy = 100.0
    
    var locManager = CLLocationManager()
    var locHeading = CLHeading()
    
    // Get coordinates for the location
    func getLocation(locManager: CLLocationManager, didUpdateLocations locations: [AnyObject]!)->NSArray{
        let locValue : CLLocationCoordinate2D = locManager.location!.coordinate
        let long = locValue.longitude
        let lat = locValue.latitude
        let locArray = [lat, long]
        return locArray
    }

    // Get direction user is heading in
    func getDirection(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) -> Double {
        var heading = newHeading.magneticHeading
        let heading2 = newHeading.trueHeading // Will have value of -1 if there is no location info
        print("\(heading) \(heading2) ")
        if heading2 >= 0 {
            heading = heading2
        }
        return heading
    }
    
    // Convert heading direction from degrees to radians to render on compass
    func getHeading() -> Double {
        let direction: CLLocationDirection = getDirection(locManager, didUpdateHeading: locHeading)
        let directionInRadians = direction / 180.0 * M_PI;
        print(directionInRadians)
        return directionInRadians
    }
}
