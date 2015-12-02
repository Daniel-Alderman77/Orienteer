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
        var windSpeed: Double?
        var windDirection: Int?
        var tempMin: Int?
        var tempMax: Int?
        var temp: Int?
        var humidity: Int?
        var sunrise: Int?
        var sunset: Int?
        var weatherDesc: String?
        
        if let json: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
            if let name = json["name"] as? String {
                locationName = name
            }
            if let wind = json["wind"] as? NSDictionary {
                windSpeed = wind["speed"] as? Double
                windDirection = wind["deg"] as? Int
            }
            if let main = json["main"] as? NSDictionary {
                tempMin = main["temp_min"] as? Int
                tempMax = main["temp_max"] as? Int
                temp = main["temp"] as? Int
                humidity = main["humidity"] as? Int
            }
            if let sys = json["sys"] as? NSDictionary {
                sunrise = sys["sunrise"] as? Int
                sunset = sys["sunset"] as? Int
            }
            
            if let weatherArray = json["weather"] as? NSArray {
                if let weather = weatherArray[0] as? NSDictionary {
                    weatherDesc = weather["main"] as? String
                }
            }
        }
        
        print(locationName!)
        print(windSpeed!)
        print(windDirection!)
        print(tempMin!)
        print(tempMax!)
        print(temp!)
        print(humidity!)
        print(sunrise!)
        print(sunset!)
        print(weatherDesc!)
    }

}
