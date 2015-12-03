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
            let dictionary = self.getData(response)
            print(dictionary)
        }
        getRequest.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(response: NSString?)-> [String:Any] {
        let jsonData = response!.dataUsingEncoding(NSUTF8StringEncoding)
        
        var locationName: String?
        var windSpeed: Double?
        var windDirection: Int?
        var tempMin: Int?
        var tempMax: Int?
        var temp: Int?
        var humidity: Int?
        var sunrise: String?
        var sunset: String?
        var weatherDesc: String?
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let json: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
            if let name = json["name"] as? String {
                locationName = name
            }
            if let wind = json["wind"] as? NSDictionary {
                windSpeed = wind["speed"] as? Double
                windDirection = wind["deg"] as? Int
                if (windDirection == nil) {
                    windDirection = 0
                }
            }
            if let main = json["main"] as? NSDictionary {
                tempMin = main["temp_min"] as? Int
                tempMax = main["temp_max"] as? Int
                temp = main["temp"] as? Int
                humidity = main["humidity"] as? Int
            }
            if let sys = json["sys"] as? NSDictionary {
                let sunriseDouble = sys["sunrise"] as? Double
                let sunriseDate = NSDate(timeIntervalSince1970: sunriseDouble!)
                sunrise = dateFormatter.stringFromDate(sunriseDate)
                
                let sunsetDouble = sys["sunset"] as? Double
                let sunsetDate = NSDate(timeIntervalSince1970: sunsetDouble!)
                sunset = dateFormatter.stringFromDate(sunsetDate)
            }
            
            if let weatherArray = json["weather"] as? NSArray {
                if let weather = weatherArray[0] as? NSDictionary {
                    weatherDesc = weather["main"] as? String
                }
            }
        }
        
    
        
        let dictionary: [String:Any] = [
            "locationName": (locationName)!,
            "windSpeed":(windSpeed)!,
            "windDirection":(windDirection)!,
            "tempMin":(tempMin)!,
            "tempMax":(tempMax)!,
            "temp":(temp)!,
            "humidity":(humidity)!,
            "sunrise":(sunrise)!,
            "sunset":(sunset)!,
            "weatherDesc":(weatherDesc)!
        ]
        
        return dictionary
    }

}
