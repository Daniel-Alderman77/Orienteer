//
//  SecondViewController.swift
//  Orienteer
//
//  Created by Hannah Svensson on 2015-11-30.
//  Copyright © 2015 COMP3222. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let requiredAccuracy: CLLocationAccuracy = 100.0
    
    var locManager = CLLocationManager()
    
    var tryingToLocate = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        // Update location when view is open
        print("Updating Location")
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Stop updating location
        super.viewWillDisappear(animated)
        locManager.startUpdatingLocation()
        
        locManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func locManager(didUpdateLocations locations: [AnyObject]!) {
        let locValue : CLLocationCoordinate2D = locManager.location!.coordinate;
        let long = locValue.longitude;
        let lat = locValue.latitude;
        print(long);
        print(lat);
    }

    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .Satellite
            mapView.pitchEnabled = false
            let location = CLLocationCoordinate2D(latitude: 53.8073, longitude: -1.5517)
            let region = MKCoordinateRegionMakeWithDistance(location, 1000.0, 1000.0)
            mapView.setRegion(region, animated: true)
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = location
            mapView.addAnnotation(dropPin)
        }
    }
    
}
