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

    @IBOutlet weak var routeBtn: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    var c = 0
    
    var boolA = false
    var boolB = false
    var boolC = false
    
    var userLocation:CLLocation!
    
    var a,b,d : CLLocation!
    // variable for fistance masuring in km
    
    var distance1:Double!
    var distance2:Double!
    var distance3:Double!
    
    // variable for showinmg routes
    
    var location1: CLLocationCoordinate2D!
    var location2:CLLocationCoordinate2D!
    var location3 :CLLocationCoordinate2D!
    
    var places = [Place]()
    
    var locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       // map.isZoomEnabled = false
        map.showsUserLocation = true
        
        // hidding button
        routeBtn.isHidden = true
        
        map.delegate = self  // add delegate to self
    
        locManager.delegate = self
        
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locManager.requestWhenInUseAuthorization()
    
        locManager.startUpdatingLocation()
        
        
        let lp = UITapGestureRecognizer(target: self, action: #selector(longPress))
        
        map.addGestureRecognizer(lp)
    }
    
    
    // added action for added button
    @IBAction func findRoute(_ sender: UIButton) {
        
        map.removeOverlays(map.overlays)
         // variable location1, locationb2, locaton3 are created out side the class and valkue assingned  to them in if else statement of
        // objc function of long press check from there
        findRouteFunction(source: location1, destination: location2)
        findRouteFunction(source: location2, destination: location3)
        findRouteFunction(source: location3, destination: location1)
    
        
    }
    
    // this is the function which is called when ever user click on the button
    
    
    func findRouteFunction(source:CLLocationCoordinate2D, destination: CLLocationCoordinate2D){

        
        // after this all the work done accoring to sirs video
        
            let sourceLocation = MKPlacemark(coordinate: source)
            let destinationLocation = MKPlacemark(coordinate: destination)
            
            let directionRequest = MKDirections.Request()
            
            directionRequest.source = MKMapItem(placemark: sourceLocation)
            directionRequest.destination = MKMapItem(placemark: destinationLocation)
            
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                guard let directionResponse = response else {return}
                
                
                let route = directionResponse.routes[0]
                
                self.map.addOverlay(route.polyline, level: .aboveRoads)

                let rect = route.polyline.boundingMapRect

                self.map.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
    }
}
    
    
    
    @objc  func longPress(gesture:UITapGestureRecognizer){
                
        let touch = gesture.location(in: map)
        let coordinate = map.convert(touch, toCoordinateFrom: map)
        gesture.numberOfTapsRequired = 2
        let anno = MKPointAnnotation()
         c += 1
       
        if c == 1{
            
            anno.coordinate = coordinate
            a = CLLocation(latitude: anno.coordinate.latitude, longitude: anno.coordinate.longitude)
            places.append(Place(title:anno.title, coordinate:anno.coordinate))

            anno.title = ("A")
            map.addAnnotation(anno)
            
            
            location1 = coordinate
            routeBtn.isHidden = true
        }else if c == 2{
            anno.title = "B"
            anno.coordinate = coordinate
            places.append(Place(title:anno.title, coordinate:anno.coordinate))
            
            b = CLLocation(latitude: anno.coordinate.latitude, longitude: anno.coordinate.longitude)
            map.addAnnotation(anno)
            routeBtn.isHidden = true
            location2 = coordinate
           
        }else if c == 3 {
            anno.title = "C"
            anno.coordinate = coordinate
            places.append(Place(title:anno.title, coordinate:anno.coordinate))
            
            d = CLLocation(latitude: anno.coordinate.latitude, longitude: anno.coordinate.longitude)
            
            map.addAnnotation(anno)
            addPolygon()
            
            // showing button on droping pin
            routeBtn.isHidden = false
            location3 = coordinate
            
           
        }else if c == 4 {
            map.removeAnnotations(map.annotations) // remove all annotations
            map.removeOverlays(map.overlays) // remove all overlays
            places.removeAll() // empty the places array
            c = 1 // setting c to zero
            
          
            // setting marker to A on fouyrth tap
            anno.title = "A"
            anno.coordinate = coordinate
            places.append(Place(title:anno.title, coordinate:anno.coordinate))
            map.addAnnotation(anno)
            
            routeBtn.isHidden = true
            location1 = coordinate
            
        }
        
        
    }
    
    
    func removeSinglePin(){
        for anno in map.annotations{
            if anno.title == "You Are Here"{
                map.removeAnnotation(anno)
            }
        }
    }
    // added polygon to the markers
    func addPolygon(){
        let coordinates = places.map{
            $0.coordinate
        }
        let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        map.addOverlay(polygon)
        
    }
    
    
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        if c > 3{
        removeSinglePin()
        }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        userLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        displayLocation(lat: latitude, long: longitude, title: "You Are here")
    }
    
    func displayLocation(lat: CLLocationDegrees,
                         long: CLLocationDegrees,
                         title:String){
        
        let latDelta:CLLocationDegrees = 0.1
        let longDelta:CLLocationDegrees = 0.1
        
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

extension ViewController:MKMapViewDelegate{
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.subtitle)
        if view.annotation?.title == "A"{
            boolA = true
            boolB = false
            boolC = false
            
            distance1 = a.distance(from: userLocation)
        }
        if view.annotation?.title == "B"{
                   boolA = false
                   boolB = true
                   boolC = false
            distance2 = b.distance(from: userLocation)
               }
        if view.annotation?.title == "C"{
                   boolA = false
                   boolB = false
                   boolC = true
            distance3 = d.distance(from: userLocation)
               }
        
    }
    
    // also add lines from 255 to 259
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon{
            let rend = MKPolygonRenderer(overlay: overlay)
            rend.strokeColor = UIColor.green
            rend.fillColor = UIColor.red.withAlphaComponent(0.5)
            rend.lineWidth = 2
            return rend
        } else if overlay is MKPolyline{ // to show route you should add poly line rendere
            let rend = MKPolylineRenderer(overlay: overlay)
            rend.strokeColor = UIColor.red
            rend.lineWidth = 2
            return rend
        }
        return MKOverlayRenderer()
    }
 
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation is MKUserLocation{
            return nil
        }
        
       let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pinIdentifier")
        marker.tintColor = UIColor.green
        marker.canShowCallout = true
        marker.detailCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return marker
    }
    
    // just oeee
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if boolA == true {
            let alert = UIAlertController(title: "Distance To Your Location", message: String(format: "%.2f", distance1 ," KM"), preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelBtn)
        present(alert, animated: true , completion: nil)
    }
        else if boolB == true {
            let alert = UIAlertController(title: "Distance To Your Location", message: String(format: "%.2f", distance1 ," KM"), preferredStyle: .alert)
            let cancelBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelBtn)
            present(alert, animated: true , completion: nil)
        }
   
    
    }
}

