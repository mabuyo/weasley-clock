//
//  MainViewController.swift
//  WeasleyClock
//
//  Created by Michelle Mabuyo on 2016-09-17.
//  Copyright © 2016 Michelle Mabuyo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBAction func testPhoton(_ sender: AnyObject) {
        // var setupController = SparkSetupMainController()
        // self.present(setupController!, animated: true, completion: nil)
        
        
        // 1
        SparkCloud.sharedInstance().getDevices { (sparkDevicesList: [Any]?, error: Error?) -> Void in
            // 2
            if let sparkDevices = sparkDevicesList as? [SparkDevice]
            {
                NSLog("in sparkdevices")
                // 3
                for device in sparkDevices
                {
                    if device.name == "Weasley_Clock"
                    {
                        // 4
                        // device.callFunction("led", withArguments: ["on"], completion: nil)
                        device.callFunction("setUser", withArguments: ["Michelle"], completion: {(resultCode: NSNumber?, error: Error?) -> Void in
                            if (resultCode == 1) {
                                NSLog("setUser successful")
                                device.callFunction("update", withArguments: ["Home"], completion: {
                                    (resultCode: NSNumber?, error: Error?) -> Void in
                                    if (resultCode == 1) {
                                        NSLog("Update successful")
                                        device.getVariable("userLoc", completion: {(result:Any?, error:Error?) -> Void in
                                            if let e=error {
                                                NSLog("error!!!")
                                                NSLog(e.localizedDescription)
                                            }
                                            else {
                                                NSLog("getVariable successful")
                                                if let temp = result as? String {
                                                    NSLog("user is \(temp)")
                                                }
                                            }
                                            
                                        })
                                    } //endif
                                    
                                }) //end callFunction Update
                                
                            } //endif
                        })
                        
                        /*
                         let myDeviceVariables : Dictionary? = device.variables as? Dictionary<String,String>
                         NSLog("MyDevice first Variable is called \(myDeviceVariables!.keys.first) and is from type \(myDeviceVariables?.values.first)")
                         
                         let myDeviceFunction = device.functions
                         NSLog("MyDevice first function is called \(myDeviceFunction.first)")
                         */
                        
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
