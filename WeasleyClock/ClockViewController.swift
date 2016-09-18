//
//  ClockViewController.swift
//  WeasleyClock
//
//  Created by Michelle Mabuyo on 2016-09-17.
//  Copyright © 2016 Michelle Mabuyo. All rights reserved.
//

import UIKit

class ClockViewController: UIViewController {
    
    // user LEDs
    // user#_clocknumber
    @IBOutlet weak var user1_12: ClockHandView!
    @IBOutlet weak var user2_12: ClockHandView!
    @IBOutlet weak var user1_3: ClockHandView!
    @IBOutlet weak var user2_3: ClockHandView!
    @IBOutlet weak var user1_6: ClockHandView!
    @IBOutlet weak var user2_6: ClockHandView!
    @IBOutlet weak var user1_9: ClockHandView!
    @IBOutlet weak var user2_9: ClockHandView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get locations of users
        // hardcoded user1 at 12, user2 at 3
        user1_12.userColor = UIColor.green
        user2_3.userColor = UIColor.blue
        
        // Customize navbar
        
        self.navigationItem.title = "Clock"
        
        let locationsButton = UIBarButtonItem(title: "Locations", style: .plain, target: self, action: #selector(locationsButtonPressed))
        self.navigationItem.setLeftBarButton(locationsButton, animated: true)
        

        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonPressed))
        self.navigationItem.setRightBarButton(settingsButton, animated: true)
        
        
    }

    func locationsButtonPressed() {
        NSLog("Locations pressed")
        let locationsView =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationsTableViewController")
        //present(locationsView, animated: true, completion: nil)
        show(locationsView, sender: nil)
    }
    
    func settingsButtonPressed() {
        NSLog("Settings button pressed")
        let settingsView =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController")
        present(settingsView, animated: true, completion: nil)
        
        //show(settingsView, sender: nil)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
