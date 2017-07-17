//
//  ViewController.swift
//  iClock
//
//  Created by Marcelo Siqueira on 14/07/17.
//  Copyright © 2017 Marcelo Siqueira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var hourField: UILabel!
    
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hourField.translatesAutoresizingMaskIntoConstraints = true
        hourField.adjustsFontSizeToFitWidth = true
        
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
        let seconds = calendar.component(.second, from: date)
        
        // display
        let output = String.localizedStringWithFormat("%02d:%02d:%02d", hour, minutes, seconds)
        hourField.text = output
        
    }

}

