//
//  ViewController.swift
//  iClock
//
//  Created by Marcelo Siqueira on 14/07/17.
//  Copyright © 2017 Marcelo Siqueira. All rights reserved.
//

import UIKit

let userDefaults: UserDefaults = .standard
let wasLaunchedBefore: Bool = userDefaults.bool(forKey: "firstLaunch")

let colorBlue:UIColor = UIColor.init(red: 31/255, green: 178/255, blue: 193/255, alpha: 0.9)
let colorPink:UIColor = UIColor.init(red: 217/255, green: 92/255, blue: 94/255, alpha: 0.9)
let colorGreen:UIColor = UIColor.init(red: 12/255, green: 212/255, blue: 156/255, alpha: 0.9)
let colorAmber:UIColor = UIColor.init(red: 255/255, green: 179/255, blue: 71/255, alpha: 0.9)
let totalColors:Int = 4
var deviceScreen:UIScreen = UIScreen()
var minDisplayAlpha:CGFloat = 0.3

class ViewController: UIViewController {
    
    @IBOutlet weak var hourField: UILabel!
    
    var timer = Timer()
    var currentColor:UIColor = colorBlue
    var currentColorIndex:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // manage display alpha
        let deviceScreenBrightness = UIScreen.main.brightness
        hourField.alpha = deviceScreenBrightness >= minDisplayAlpha ? deviceScreenBrightness : minDisplayAlpha
        print("starting with alpha: ", hourField.alpha)
        NotificationCenter.default.addObserver(self, selector: #selector(screenBrightnessDidChange(notification:)), name: .UIScreenBrightnessDidChange, object: nil)
        
        // don't let the device sleep
        UIApplication.shared.isIdleTimerDisabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.changeColorValue(_:)))
        hourField.addGestureRecognizer(tapGesture)
        
        setSavedColor()
        updateCounting()
        scheduledTimerWithTimeInterval()
        
    }

    func scheduledTimerWithTimeInterval(){
        
        // Scheduling timer to Call the function **Countdown** with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
        
    }
    
    func updateCounting(){
        
        // time
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        //let seconds = calendar.component(.second, from: date)
        
        // display
        //let output = String.localizedStringWithFormat("%02d:%02d:%02d", hour, minutes, seconds)
        let limitedOutput = String.localizedStringWithFormat("%02d:%02d", hour, minutes)
        hourField.text = limitedOutput
        
    }
    
    func changeColorValue(_ sender: UITapGestureRecognizer) {

        let currentColorIndex = UserDefaults.standard.integer(forKey: "colorIndex")
        var index = 1
        
        if currentColorIndex < totalColors {
            
            index  = currentColorIndex + 1
            
        }
        
        userDefaults.set(index, forKey: "colorIndex")
        hourField.textColor = getColorByIndex(index: index)
        
        //self.displayReviewAlert()
        
    }
    
    func setSavedColor() {
        
        if !wasLaunchedBefore {
            
            // set launched flag
            userDefaults.set(true, forKey: "firstLaunch")
            
            // init default color
            userDefaults.set(1, forKey: "colorIndex")
            
        }
        
        let savedColorIndex = UserDefaults.standard.integer(forKey: "colorIndex")
        
        //hourField.adjustsFontSizeToFitWidth = true
        hourField.textColor = getColorByIndex(index: savedColorIndex)
        
    }
    
    func getColorByIndex(index: Int) -> UIColor {
        
        switch index {
            
        case 2:
            currentColor = colorPink
            
        case 3:
            currentColor = colorGreen
            
        case 4:
            currentColor = colorAmber
            
        default:
            currentColor = colorBlue
            
        }
        
        return currentColor
        
    }
    
    func screenBrightnessDidChange(notification: NSNotification) {
        
        //print("screenBrightnessDidChange")
        
        if let deviceScreen = notification.object {
            
            let deviceScreenBrightness = (deviceScreen as! UIScreen).brightness
            hourField.alpha = deviceScreenBrightness >= minDisplayAlpha ? deviceScreenBrightness : minDisplayAlpha
            //print("setting alpha: ", hourField.alpha, " for brightness: ", deviceScreenBrightness)
        }
        
    }
    
    func displayReviewAlert() {
        
        let alert = UIAlertController(title: "Hey! Did you like this clock?", message: "Share a review", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
            
            let reviewURL = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\("1260851662")&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
            if let checkURL = NSURL(string: reviewURL) {
                UIApplication.shared.openURL(checkURL as URL)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }

}










































