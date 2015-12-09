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
        u.startLocating()
        
        u.stopLocating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            let manager = u.locManager
            let locArray = u.getLocation(manager, didUpdateLocations: [""])
            mapView.mapType = .Satellite
            mapView.pitchEnabled = false
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(locArray[0] as! NSNumber), longitude: CLLocationDegrees(locArray[1] as! NSNumber))
            let region = MKCoordinateRegionMakeWithDistance(location, 1000.0, 1000.0)
            mapView.setRegion(region, animated: true)
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = location
            mapView.addAnnotation(dropPin)
        }
    }
    
}
