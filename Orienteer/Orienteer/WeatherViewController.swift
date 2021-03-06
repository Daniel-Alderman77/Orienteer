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
    let updateLocation = UpdateLocation() // Make an instance of the UpdateLocation class
   
    var locManager = CLLocationManager()
    
    func getManager()->CLLocationManager{ // Since a function is needed to call UpdateLocation's locManager.
        let manager = updateLocation.locManager
        return manager
    }

    // Creating outlets for the different labels
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
    
    // When view appears the code inside will be executed
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !couldBeLocatable() {
            print("Not authorized!")
            return
        }
        
        updateLocation.startUpdatingLocation() // Get the current location
        let manager = getManager() // Create a location manager
        
        let locArray = updateLocation.getLocation(manager, didUpdateLocations: ["" as AnyObject]) // Call the function in UpdateLocation to get the coordinates for latitude and longitude.
        
        // RestFul URL
        let urlLoc = "http://api.openweathermap.org/data/2.5/weather?lat=\(locArray[0])&lon=\(locArray[1])&appid=0d36745b5dd4db5c7bbd09da97846ff6&units=metric" // Add the lat and lot to the url
        
        let url = URL(string: urlLoc)
        
        // Store Rest response from as String
        let response = String(data:try! Data(contentsOf: url!), encoding: String.Encoding.utf8)
        
        let dictionary = self.getData(response! as NSString?) // The getData function returns a dictionary
        
        let weather = String(describing: dictionary["weatherDesc"]!) // Creating a switch for the weather description so that different images are shown depending on the description.
        switch weather {
        case "Clear": weatherImage.image = UIImage(named: "sun.png")
        case "Clouds": weatherImage.image = UIImage(named: "clouds.png")
        case "Rain": weatherImage.image = UIImage(named: "rain.png")
        case "Thunderstorm": weatherImage.image = UIImage(named: "thunder.png")
        case "Snow": weatherImage.image = UIImage(named: "snow.png")
        case "Mist": weatherImage.image = UIImage(named: "mist.png")
        default: break
        }
        // The labels get their input.
        descLabel.text = String(describing: dictionary["weatherDesc"]!)
        tempLabel.text = String(describing: dictionary["temp"]!)
        locationLabel.text = String(describing: dictionary["locationName"]!)
        minTempLabel.text = "Min: " + String(describing: dictionary["tempMin"]!)
        maxTempLabel.text = "Max: " + String(describing: dictionary["tempMax"]!)
        windSpeedLabel.text = "Speed: " + String(describing: dictionary["windSpeed"]!)
        windDirectionLabel.text = "Direction: " + String(describing: dictionary["windDirection"]!)
        sunriseLabel.text = "Sunrise: " + String(describing: dictionary["sunrise"]!)
        sunsetLabel.text = "Sunset: " + String(describing: dictionary["sunset"]!)
        
        updateLocation.stopUpdatingLocation() //stop locating
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
    
    func getData(_ response: NSString?)-> [String:Any] { // A function to get the data from the weather API
        let jsonData = response!.data(using: String.Encoding.utf8.rawValue)
        
        var locationName: String?
        var windSpeed: Double?
        var windDirection: Double?
        var tempMin: Int?
        var tempMax: Int?
        var temp: Int?
        var humidity: Int?
        var sunrise: String?
        var sunset: String?
        var weatherDesc: String?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        // Taking the variables from a NSDictionary and saving them.
        if let json: NSDictionary = try! JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
            if let name = json["name"] as? String {
                locationName = name
            }
            else {
                print ("Could not deserialise data")
                locationName = "Could not deserialise data"
            }
            if let wind = json["wind"] as? NSDictionary {
                windSpeed = wind["speed"] as? Double
                windDirection = wind["deg"] as? Double
            }
            else {
                windSpeed = 0
                windDirection = 0
            }
            if let main = json["main"] as? NSDictionary {
                tempMin = main["temp_min"] as? Int
                tempMax = main["temp_max"] as? Int
                temp = main["temp"] as? Int
                humidity = main["humidity"] as? Int
            }
            else {
                tempMin = 0
                tempMax = 0
                temp = 0
                humidity = 0
            }
            if let sys = json["sys"] as? NSDictionary {
                let sunriseDouble = sys["sunrise"] as? Double
                let sunriseDate = Date(timeIntervalSince1970: sunriseDouble!)
                sunrise = dateFormatter.string(from: sunriseDate)
                
                let sunsetDouble = sys["sunset"] as? Double
                let sunsetDate = Date(timeIntervalSince1970: sunsetDouble!)
                sunset = dateFormatter.string(from: sunsetDate)
            }
            else {
                sunrise = "HH:mm"
                sunset = "HH:mm"
            }
            
            if let weatherArray = json["weather"] as? NSArray {
                if let weather = weatherArray[0] as? NSDictionary {
                    weatherDesc = weather["main"] as? String
                }
            }
            else {
                weatherDesc = "No weather data available"
            }
        }
        
        let windDirectionStr = getWindDirection(windDirection!) // Use the getWindDirection function to convert the wind direction to a string describing the direction (it is originally a number describing the degrees)
    
        let dictionary: [String:Any] = [ // Creating a dictionary with all of the essential variables.
            "locationName": (locationName)!,
            "windSpeed":(windSpeed)!,
            "windDirection":(windDirectionStr),
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
    
    func getWindDirection(_ windDegree:Double)->String{ // Function to convert the wind degrees to a readable string describing wind direction. Make use of ranges in the cases in the switch.
        var windDirectionDesc = ""
        switch (windDegree){
            case (0...22.5):
                windDirectionDesc = "N"
                break
            case (22.5...67.5):
                windDirectionDesc = "NE"
                break
            case (67.5...112.5):
                windDirectionDesc = "E"
                break
            case (112.5...157.5):
                windDirectionDesc = "SE"
                break
            case (157.5...202.5):
                windDirectionDesc = "S"
                break
            case (202.5...247.5):
                windDirectionDesc = "SW"
                break
            case (247.5...292.5):
                windDirectionDesc = "W"
                break
            case (292.5...337.5):
                windDirectionDesc = "NW"
                break
            case (337.5...360):
                windDirectionDesc = "N"
                break
            default:
                windDirectionDesc = "No data" // Capturing if the wind direction is nil.
        }
        return windDirectionDesc
        
    }
}
