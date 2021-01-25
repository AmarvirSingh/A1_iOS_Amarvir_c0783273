//
//  ViewController.swift
//  A1_iOS_Amarvir_c0783273
//
//  Created by Amarvir Mac on 26/01/21.
//  Copyright © 2021 Amarvir Mac. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    var c = 0
    
    var locManager = CLLocationManager()
    var nameArray = ["A","B","C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        map.isZoomEnabled = false
    
        locManager.delegate = self
        
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locManager.requestWhenInUseAuthorization()
    
        locManager.startUpdatingLocation()
        
        
        let lp = UITapGestureRecognizer(target: self, action: #selector(longPress))
        
        map.addGestureRecognizer(lp)
    }
    
    @objc  func longPress(gesture:UITapGestureRecognizer){
                
        let touch = gesture.location(in: map)
        let coordinate = map.convert(touch, toCoordinateFrom: map)
        gesture.numberOfTapsRequired = 2
        let anno = MKPointAnnotation()
         c += 1
        print(c)
        if c == 1{
            anno.title = "A"
            anno.coordinate = coordinate
            map.addAnnotation(anno)
        }else if c == 2{
            anno.title = "B"
            anno.coordinate = coordinate
            map.addAnnotation(anno)
        }else if c == 3 {
            anno.title = "C"
            anno.coordinate = coordinate
            map.addAnnotation(anno)
        }
        
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        displayLocation(lat: latitude, long: longitude, title: "You Are here")
    }
    
    func displayLocation(lat: CLLocationDegrees,
                         long: CLLocationDegrees,
                         title:String){
        
        let latDelta:CLLocationDegrees = 0.010
        let longDelta:CLLocationDegrees = 0.010
        
        let zoom = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let region = MKCoordinateRegion(center: location, span: zoom)
        
        map.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = location
        
        map.addAnnotation(annotation)
        
    }
    

}

