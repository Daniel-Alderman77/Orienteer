//
//  FirstViewController.swift
//  Orienteer
//
//  Created by Hannah Svensson on 2015-11-30.
//  Copyright © 2015 COMP3222. All rights reserved.
//

import UIKit
import CoreLocation

class CompassViewController: UIViewController, CLLocationManagerDelegate {

    var locManager = CLLocationManager()
    
    var tryingToLocate = false

    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if !couldBeLocatable() {
            print("Not authorized!")
            return
        }
        
        if tryingToLocate {
            return
        }
        
        tryingToLocate = true
        
        // Configure location manager and start updating
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.activityType = .Fitness
        locManager.startUpdatingLocation()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locManager.stopUpdatingHeading()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("Updated location")
        
        let location = locations.last as CLLocation!
        
        let coord = location.coordinate
        latitudeLabel.text = String(round(coord.latitude))
        longitudeLabel.text = String(round(coord.longitude))
        
        stopTrying()
    }
    
    func couldBeLocatable() -> Bool {
        
        if !CLLocationManager.locationServicesEnabled() {
            // Location services not enabled but might be in future
            return true
        }
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            return true
        case .NotDetermined:
            // Ask user for permission
            locManager.requestWhenInUseAuthorization()
            return true
        case .Restricted, .Denied:
            return false
        }
    }
    
    func stopTrying() {
        locManager.stopUpdatingLocation()
        tryingToLocate = false
    }

}

