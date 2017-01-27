//
//  CompassViewController.swift
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Location services not authorized by the user
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
        locManager.activityType = .fitness
        locManager.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locManager.stopUpdatingHeading()
    }
    
    // Get Coordinates of the User's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("Updated location")
        
        let location = locations.last as CLLocation!
        
        let coord = location?.coordinate
        
        // Set to labels to show coordinates
        latitudeLabel.text = String(round((coord?.latitude)!))
        longitudeLabel.text = String(round((coord?.longitude)!))
        
        stopTrying()
    }
    
    func couldBeLocatable() -> Bool {
        
        if !CLLocationManager.locationServicesEnabled() {
            // Location services not enabled but might be in future
            return true
        }
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .notDetermined:
            // Ask user for permission
            locManager.requestWhenInUseAuthorization()
            return true
        case .restricted, .denied:
            return false
        }
    }
    
    // Stop Updating location
    func stopTrying() {
        locManager.stopUpdatingLocation()
        tryingToLocate = false
    }
}
