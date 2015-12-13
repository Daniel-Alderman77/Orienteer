//
//  SecondViewController.swift
//  Orienteer
//
//  Created by Hannah Svensson on 2015-11-30.
//  Copyright © 2015 COMP3222. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    let u = UpdateLocation()
    
    func getManager()->CLLocationManager{ //since a function is needed to call UpdateLocation's locManager.
        let manager = u.locManager
        return manager
    }
    
    override func viewDidAppear(animated: Bool) { //start updating the location when view appears.
        u.startUpdatingLocation()

        print("Updating Location")
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Stop updating location
        super.viewWillDisappear(animated)
        u.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            let manager = getManager() //gets the locManager
            let locArray = u.getLocation(manager, didUpdateLocations: [""]) //gets the array with lat and lon
            mapView.mapType = .Satellite //type of map is a satellite one
            mapView.pitchEnabled = false
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(locArray[0] as! NSNumber), longitude: CLLocationDegrees(locArray[1] as! NSNumber)) //using the lat and lon and converting them to NSNumbers
            let region = MKCoordinateRegionMakeWithDistance(location, 1000.0, 1000.0)
            mapView.setRegion(region, animated: true)
            let dropPin = MKPointAnnotation() //Create a drop pin
            dropPin.coordinate = location //drop pin should be at the current location
            mapView.addAnnotation(dropPin) //drop pin being placed
        }
    }
    
}
