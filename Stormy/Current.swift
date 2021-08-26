//
//  Current.swift
//  Stormy
//
//  Created by Sam Chaudry on 02/10/2014.
//  Copyright (c) 2014 Sam Chaudry. All rights reserved.
//intialisation process or prepearing struct or class in our code
//prep work to get struct up and running
//Only use ? if the return type is either a nil or unknown stops from crashing when we run the struct
//initalisation is 2 phase process
//phase 1 = initially struct is assigned value of 0 and then has option for a custom value. 
//so if we are unsure we use an optional ? value


import Foundation
import UIKit

//struct containing all values we want to use variable and the TYPE of stored property
struct Current{

    var currentTime:String?
    var temprature: Int
    var humidity: Double
    var precipProbability:Double
    var summary:String
    var icon:UIImage?

    //we have to intialise the structs + initial values like an instance method to get the values

    //use designated initialser to get it up and runing it fully initialises the struct -> gets it up and runing
    //pass in our returned data dicitonary as nsdictionary
    
    init(weatherDictionary:NSDictionary){
        
        //create constant and pass in our weather dicitionary retrieving current as nsdictionary
        let currentWeather = weatherDictionary["currently"] as! NSDictionary
        
        
        
        //setting current time as nsdicitonary property "time" and then down casting it as int
       
        // downcasting -> retrun me time from dicitonary and give it to me as an int value
        
        //set our time value into string
       
        temprature = currentWeather["temperature"] as! Int
        humidity = currentWeather["humidity"]as! Double
        precipProbability = currentWeather["precipProbability"] as! Double
        summary = currentWeather["summary"] as! String

        let iconString = currentWeather["icon"]as! String
        icon = weatherIconFromString(stringIcon: iconString)
        
        let currentTimeIntValue = currentWeather["time"] as! Int
        currentTime = dateStringFromUnixtime(unixTime: currentTimeIntValue)
    
    
    }

    func dateStringFromUnixtime(unixTime:Int) -> String{
    
        let timeInseconds = TimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInseconds)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: weatherDate as Date)
        
    }
    
    
    func weatherIconFromString(stringIcon:String) -> UIImage{
    
        var imageName:String
        
        switch stringIcon {
        
        case "clear-day":
            imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleet"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "default"
        }
        
        var iconImage = UIImage(named: imageName)
        
        return iconImage!
        
    }
    
    
}




