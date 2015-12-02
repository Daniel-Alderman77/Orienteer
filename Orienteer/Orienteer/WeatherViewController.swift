//
//  WeatherViewController.swift
//  Orienteer
//
//  Created by Hannah Svensson on 2015-11-30.
//  Copyright © 2015 COMP3222. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=53.8073&lon=-1.5517&appid=2de143494c0b295cca9337e1e96b00e0&units=metric")
        
        let getRequest = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let response = (NSString(data: data!, encoding: NSUTF8StringEncoding))
            print(response)
            self.getData(response)
        }
        getRequest.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(response: NSString?) {
        let jsonData = response!.dataUsingEncoding(NSUTF8StringEncoding)
        
        var locationName: String?
        
        if let json: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
            if let value = json["name"] as? String {
                locationName = value
            }
        }
        
        print(locationName!)
    }

}
