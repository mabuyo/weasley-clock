//
//  AddLocationViewController.swift
//  WeasleyClock
//
//  Created by Michelle Mabuyo on 2016-09-17.
//  Copyright © 2016 Michelle Mabuyo. All rights reserved.
//  
//  Source:  https://www.appcoda.com/geo-targeting-ios/
//  https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/

import UIKit
import MapKit

class AddLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate, UISearchBarDelegate {

    // map search stuff
    @IBOutlet weak var searchBar: UISearchBar!
    var resultSearchController: UISearchController? = nil
    var locationSearchTable: LocationSearchTableViewController! = nil
    var locationsTable: LocationsTableViewController! = nil

    // map stuff
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var location: Location!
    
    // user inputs
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var locateOnMapButton: UIButton!
    @IBOutlet weak var locationNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // textfield delegates
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        locationNameTextField.delegate = self
        
        self.locationsTable = storyboard!.instantiateViewController(withIdentifier: "LocationsTableViewController") as! LocationsTableViewController
        
        // search results stuff
        self.locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        self.searchBar.sizeToFit()
        self.searchBar.placeholder = "Search for places"
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        searchBar.delegate = self
        locationSearchTable.mapView = mapView
        locationSearchTable.searchBar = self.searchBar
        
        // setup locationManager
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // setup mapView
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1. status is not determined
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    // Add Location
    @IBAction func addLocationBtnPressed(_ sender: AnyObject) {
        NSLog("Add location button pressed")
        let lat = Double(latitudeTextField.text!)
        let long = Double(longitudeTextField.text!)
        let coord = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        let region = CLCircularRegion(center: coord, radius: regionRadius, identifier: locationNameTextField.text!)
        self.location = Location(clock_position: locations.count + 1, name: locationNameTextField.text!, region: region)
        locationManager.startMonitoring(for: region)
        self.dismiss(animated: true, completion: nil)
    }
    
    // show location on map
    @IBAction func showLocationBtnPressed(_ sender: AnyObject) {
        NSLog("Show location button pressed.")
        self.view.endEditing(true)

        let lat = Double(latitudeTextField.text!)
        let long = Double(longitudeTextField.text!)
        let coord = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        let region = CLCircularRegion(center: coord, radius: regionRadius, identifier: locationNameTextField.text!)
        self.location = Location(clock_position: 3, name: locationNameTextField.text!, region: region)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord;
        annotation.title = "\(title)";
        mapView.addAnnotation(annotation)
        
        // 5. setup circle
        let circle = MKCircle(center: coord, radius: regionRadius)
        mapView.add(circle)
        
        let mkregion = MKCoordinateRegionMakeWithDistance(coord, 900, 900)
        mapView.setRegion(mkregion, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        NSLog("didstart monitoringfor " + region.identifier)
    }
    
    // 1. user enter region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("enter \(region.identifier)")
    }
    
    // 2. user exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit \(region.identifier)")
    }
    
    func addRadiusCircle(location: CLLocation){
        self.mapView.delegate = self
        let circle = MKCircle(center: location.coordinate, radius: 10000 as CLLocationDistance)
        self.mapView.add(circle)
    }
    
    // 6. draw circle
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //let circleRenderer = MKCircleRenderer(overlay: overlay)
        //circleRenderer.strokeColor = UIColor.red
        //circleRenderer.lineWidth = 1.0
        //return circleRenderer
        
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    
    // MARK: UISearchBarDelegate
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NSLog("Search clicked")
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.locationSearchTable?.matchingItems = response.mapItems
            self.locationSearchTable?.tableView.reloadData()
            NSLog("response: ")
        }
        show(locationSearchTable, sender: nil)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSLog("textDidChange with: " + searchText)
     
    }
    
}

