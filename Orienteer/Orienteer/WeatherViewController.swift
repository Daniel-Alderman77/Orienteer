//
//  WeatherViewController.swift
//  Orienteer
//
//  Created by Hannah Svensson on 2015-11-30.
//  Copyright © 2015 COMP3222. All rights reserved.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController {
    let u = UpdateLocation()

    
    func getLocation()->NSArray{
        let manager = u.locManager
        let locArray = u.getLocation(manager, didUpdateLocations: [""])
        return locArray
    }

    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        u.startUpdatingLocation()
   
        
        let locArray = getLocation()
        
        let urlLoc = "http://api.openweathermap.org/data/2.5/weather?lat=\(locArray[0])&lon=\(locArray[1])&appid=2de143494c0b295cca9337e1e96b00e0&units=metric"
        
        let url = NSURL(string: urlLoc)
        
        let response = String(data:NSData(contentsOfURL: url!)!, encoding: NSUTF8StringEncoding)
        
        let dictionary = self.getData(response!)
        
        let weather = String(dictionary["weatherDesc"]!)
        switch weather {
        case "Clear": weatherImage.image = UIImage(named: "sun.png")
        case "Clouds": weatherImage.image = UIImage(named: "clouds.png")
        case "Rain": weatherImage.image = UIImage(named: "rain.png")
        case "Thunderstorm": weatherImage.image = UIImage(named: "thunder.png")
        case "Snow": weatherImage.image = UIImage(named: "snow.png")
        case "Mist": weatherImage.image = UIImage(named: "mist.png")
        default: break
        }
        
        descLabel.text = String(dictionary["weatherDesc"]!)
        tempLabel.text = String(dictionary["temp"]!)
        locationLabel.text = String(dictionary["locationName"]!)
        minTempLabel.text = String(dictionary["tempMin"]!)
        maxTempLabel.text = String(dictionary["tempMax"]!)
        windSpeedLabel.text = String(dictionary["windSpeed"]!)
        windDirectionLabel.text = String(dictionary["windDirection"]!)
        sunriseLabel.text = String(dictionary["sunrise"]!)
        sunsetLabel.text = String(dictionary["sunset"]!)
        
        u.stopUpdatingLocation()
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
