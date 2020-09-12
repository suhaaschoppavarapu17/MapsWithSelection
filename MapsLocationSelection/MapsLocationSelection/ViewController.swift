//
//  ViewController.swift
//  MapsLocationSelection
//
//  Created by Suhaas Choppavarapu on 9/11/20.
//  Copyright © 2020 Suhaas Choppavarapu. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties
    var locationServiceManager : CLLocationManager!
    
    var latitudes = [[42.3560, 42.3602, 42.3394, 42.354954, 42.346268],
                     [41.8826,41.878876, 41.892654, 41.8800, 41.86],
                     [37.8199, 37.801945, 37.809326, 37.8024, 37.7958],
                     [40.785091,40.6892, 40.7580, 40.7061, 40.7483]]
    var longitudes = [[-71.0541, -71.0551, -71.0940, -71.065489, -71.095764],
                      [-87.6226, -87.635918, -87.610168, -87.6200, -87.64],
                      [-122.4783, -122.418892, -122.409981, -122.4058, -122.3938],
                      [-73.968285, -74.0445, -73.9855, -73.9969, -74.0050]]
    var titles = [["Freedom Trail", "Faneuil Hall Marketplace","Museum of Fine Arts", "Boston Common", "Fenway Park"],
                  ["Millennium Park", "Willis Tower","Navy Pier", "Cloud Gate", "Skydeck Chicago"],
                  ["Golden Gate Bridge", "Lombard Street","Pier 39", "Coit Tower", "Ferry Building"],
                  ["Central Park", "Statue of Liberty","Times Square", "Brooklyn Bridge", "The High Line"]]
    var subTitles = [["Downtown", "Government Center","Downtown", "Downtown", "Kenmore Square"],
                     ["Loop Community Area", "Downtown","Lake Michigan", "Loop Community Area", "Downtown"],
                     ["San Francisco Bay", "Downtown","Downtown", "Telegarph Hill", "San Francisco Bay"],
                     ["Manhattan", "New York Harbor","Midtown Manhattan", "Manhattan and Brooklyn", "Manhattan"]]
    
    var rowCount: Int = 0
    var sectionCount: Int = 0
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationServiceManager = CLLocationManager()
        locationServiceManager.delegate = self
        searchTextField.delegate = self
        searchTextField.layer.cornerRadius = 8.0
        requestLocationAccess()
    }
    
    //MARK:- Helper Methods
    func requestLocationAccess() {
        locationServiceManager.requestAlwaysAuthorization()
        locationServiceManager.requestWhenInUseAuthorization()
    }
    func setupLocationManager() {
        locationServiceManager.desiredAccuracy = kCLLocationAccuracyBest
        locationServiceManager.startUpdatingLocation()
    }
    
    //MARK:- UITextFieldDelegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tableView.isHidden = false
        textField.inputView = UIView()
        return true
    }
    
    //MARK:- CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            mapView.showsUserLocation = true
            return
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            return
        case .denied:
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Give Acces to provide better service",
                                                    preferredStyle: UIAlertController.Style.alert)
            
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            return
        default:
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Give Acces to provide better service",
                                                    preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            return
        }
    }
}

//MARK:- UITableViewDataSource Methods
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        latitudes.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        latitudes[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FirstTableViewCell.identifier) as? FirstTableViewCell else {
            return UITableViewCell()
        }
        cell.label.text = titles[indexPath.section][indexPath.row]
        return cell
    }
}

//MARK:- UITableViewDelegate Methods
extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headertitle: String?
        switch section {
        case 0:
            headertitle = "Boston"
            return headertitle
        case 1:
            headertitle = "Chicago"
            return headertitle
        case 2:
            headertitle = "San Francisco"
            return headertitle
        default:
            headertitle = "New York"
            return headertitle
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sectionCount = indexPath.section
        rowCount = indexPath.row
        tableView.isHidden = true
        view.endEditing(true)
        
        let center = CLLocationCoordinate2D(latitude: latitudes[sectionCount][rowCount] ,
                                            longitude: longitudes[sectionCount][rowCount] )
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.03,
                                                                               longitudeDelta: 0.03))
        mapView.setRegion(region, animated: true)
        
        let anno = MKPointAnnotation()
        anno.coordinate = center
        anno.title = titles[sectionCount][rowCount]
        anno.subtitle = subTitles[sectionCount][rowCount]
        mapView.addAnnotation(anno)
    }
}

//MARK:- UITableViewCell
class FirstTableViewCell: UITableViewCell {
    static let identifier = "firstCell"
    
    @IBOutlet weak var label: UILabel!
}

