//
//  MapViewController.swift
//  Orienteer
//
//  Created by Hannah Svensson on 2015-11-30.
//  Copyright © 2015 COMP3222. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    let updateLocation = UpdateLocation()
        
    override func viewDidAppear(animated: Bool) { // Start updating the location when view appears.
        updateLocation.startUpdatingLocation()
            
        print("Updating Location")
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Stop updating location
        super.viewWillDisappear(animated)
        updateLocation.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getManager()->CLLocationManager{ // Since a function is needed to call UpdateLocation's locManager.
        let manager = updateLocation.locManager
        return manager
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            let manager = getManager() // Gets the locManager
            let locArray = updateLocation.getLocation(manager, didUpdateLocations: [""]) // Gets the array with lat and lon
            mapView.mapType = .Satellite // Type of map is a satellite one
            mapView.pitchEnabled = false
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(locArray[0] as! NSNumber), longitude: CLLocationDegrees(locArray[1] as! NSNumber)) // Using the lat and lon and converting them to NSNumbers
            let region = MKCoordinateRegionMakeWithDistance(location, 1000.0, 1000.0)
            mapView.setRegion(region, animated: true)
            let dropPin = MKPointAnnotation() // Create a drop pin
            dropPin.coordinate = location // Drop pin should be at the current location
            mapView.addAnnotation(dropPin) // Drop pin being placed
        }
    }
    
}
