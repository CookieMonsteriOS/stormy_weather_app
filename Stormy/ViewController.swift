//
//  ViewController.swift
//  Stormy
//
//  Created by Sam Chaudry on 30/09/2014.
//  Copyright (c) 2014 Sam Chaudry. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController,CLLocationManagerDelegate {
    
    
    //access control for api -> private is used to keep the key private
    
    @IBOutlet weak var iconView: UIImageView!
    
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    
    @IBOutlet weak var tempratureLabel: UILabel!
    
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    @IBOutlet weak var precipitationLabel: UILabel!
    
    
    @IBOutlet weak var sumaryLabel: UILabel!
    
    
    
    @IBOutlet weak var refreshButton: UIButton!
    
    
  
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
   
    
    private let apiKey = "dd7959b4eede5817dbb151fd677a3af7"
    
    
    override func viewDidLoad() {
        
        refreshActivityIndicator.isHidden = true;
        
        
        getCurrentWeatherData()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //URL connection
        //let forecastURL =  "https://api.forecast.io/forecast/dd7959b4eede5817dbb151fd677a3af7/37.8267,-122.423"
    
   
    }


func getCurrentWeatherData() -> Void{
    
        //base url
        let baseURUL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        
        //url with info relative to the base url
        
        //let forecastURL = NSURL(string:userPosition, relativeToURL: baseURUL);
        
    let forecastURL = NSURL(string: "37.8267,-122.423", relativeTo: baseURUL as URL?);

        
        
        //nsurl session allows us to download information or classes/Users/SamChaudry/Desktop/Apps Master/Stormy/Stormy/ViewController.swift
        //singleton restricts instantiation of a class to only one object -> only want one object and use mulitple times
    
        //create session to download information
    let sharedSession = URLSession.shared;
        
        //Returning session object with 3 objects url response and error remeber its coming back as string of data
    let downloadTask: URLSessionDownloadTask = sharedSession.downloadTaskWithURL((forecastURL?)! as URL, completionHandler: { (location:NSURL!, response:NSURLResponse!, error:NSError!) -> Void in
            
            
            if (error == nil) {
            
            
            //check if json data returned
            //var urlContents = NSString.stringWithContentsOfURL(location, encoding:NSUTF8StringEncoding, error:nil);
            
            //parse into  json object from string
            let dataObject = NSData(contentsOfURL: location)
            
            //converting string data into json dicitionary -> we need to be down casting this for storage as nsdictionary
            let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as! NSDictionary
            
            //intialise our current.swift class containing our weather dictionary and current weather details
                let currentWeather = Current(weatherDictionary: weatherDictionary);
            
            //updating our label UI -> using multithread
            
            //first parameter get main thread queue and 2nd is a closeure and thats the ui code we want to add
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.tempratureLabel.text = "\(currentWeather.temprature)"
                self.iconView.image = currentWeather.icon!
                self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                self.humidityLabel.text = "\(currentWeather.humidity)"
                self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                
                
                //stop refresh animation
                self.refreshActivityIndicator.stopAnimating()
                self.refreshActivityIndicator.hidden = true;
                self.refreshButton.hidden = false;
                
            })
            //error handling if network connection
                
            }else {
                
            
                let networkIssueController = UIAlertController(title: "error", message: "Sorry No Connection. No connectivity!", preferredStyle: .Alert)
                
                
                let oKButton = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                networkIssueController.addAction(oKButton)
                
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                networkIssueController.addAction(cancelButton)

                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                //get back onmain thread
                dispatch_async(dispatch_queue_t(), { () -> Void in
                    
                    //stop refresh animation
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true;
                    self.refreshButton.hidden = false;
                    
    
                })
            
            }
            
            })
        //Always use download.resume to get data otherwise it work
        downloadTask.resume()
        
    
    
    

}


    
    
    
    
    @IBAction func refresh() {
        
        getCurrentWeatherData()
    
        refreshButton.isHidden = true
        
        refreshActivityIndicator.isHidden = false
        refreshActivityIndicator.startAnimating()
    
    
    }

    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    
        
        
        // Dispose of any resources that can be recreated.
    }


}

