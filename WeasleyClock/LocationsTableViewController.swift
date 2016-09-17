//
//  LocationsTableViewController.swift
//  WeasleyClock
//
//  Created by Michelle Mabuyo on 2016-09-17.
//  Copyright © 2016 Michelle Mabuyo. All rights reserved.
//

import UIKit
import MapKit

struct Location {
    let clock_position: Int
    let name: String
    let region: CLCircularRegion
}

let regionRadius = 100.0

let home_location = Location(clock_position: 1, name: "Home", region: CLCircularRegion(center: CLLocationCoordinate2D(latitude: 73.1234, longitude: 50.1234), radius: regionRadius, identifier: "Home1"))
let work_location = Location(clock_position: 1, name: "Home", region: CLCircularRegion(center: CLLocationCoordinate2D(latitude: 70.1234, longitude: 48.1234), radius: regionRadius, identifier: "Work1"))

var locations = [home_location, work_location]

class LocationsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonPressed))
        self.navigationItem.setRightBarButton(addButton, animated: true)
        
        self.navigationItem.title = "Locations"
        self.navigationItem.backBarButtonItem?.title = "Done"
        self.navigationItem.backBarButtonItem?.image = nil
        
    }
    
    func addButtonPressed() {
        NSLog("add button pressed")
        let addLocationView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController")
       // show(addLocationView, sender: nil)
        self.present(addLocationView, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        let location = locations[indexPath.row]
        cell.textLabel?.text = location.name
        cell.detailTextLabel?.text = String(location.region.center.latitude) + " and " + String(location.region.center.longitude)

        return cell

    }
    
    @IBAction func unwindToLocationList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddLocationViewController, let location = sourceViewController.location {
            let newIndexPath = NSIndexPath(row: locations.count, section: 0)
            locations.append(location)
            tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
        }
    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
