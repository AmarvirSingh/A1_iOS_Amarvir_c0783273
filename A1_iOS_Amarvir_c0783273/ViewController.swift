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
    
    // variable for distance
    var loc1: CLLocationCoordinate2D!
    var distance: Double = 0.0
    var distance1: Double = 0.0
    var distance2: Double = 0.0
    var userLocationLatitude:CLLocation!
    var userLocationLongitude:Double!
    
    
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
    
    @IBAction func findRoute(_ sender: UIButton) {
        
        map.removeOverlays(map.overlays)
        findRouteFunction(source: location1, destination: location2)
        findRouteFunction(source: location2, destination: location3)
        findRouteFunction(source: location3, destination: location1)
    
        
    }
    
    
    func findRouteFunction(source:CLLocationCoordinate2D, destination: CLLocationCoordinate2D){
        
        
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
        //print(c)
        if c == 1{
            
            anno.coordinate = coordinate
            let loc = CLLocation(latitude: anno.coordinate.latitude, longitude: anno.coordinate.longitude)
            places.append(Place(title:anno.title, coordinate:anno.coordinate))
            distance = loc.distance(from: userLocationLatitude)
            anno.title = ("A")
            map.addAnnotation(anno)
            
            //destination.append(anno.coordinate)  // adding coordinates for destination
            location1 = coordinate
            routeBtn.isHidden = true
        }else if c == 2{
            anno.title = "B"
            anno.coordinate = coordinate
            places.append(Place(title:anno.title, coordinate:anno.coordinate))
            map.addAnnotation(anno)
            routeBtn.isHidden = true
            location2 = coordinate
           // destination.append(coordinate)
        }else if c == 3 {
            anno.title = "C"
            anno.coordinate = coordinate
            places.append(Place(title:anno.title, coordinate:anno.coordinate))
            //print(places[2].title)
            map.addAnnotation(anno)
            addPolygon()
            
            // showing button on droping pin
            routeBtn.isHidden = false
            location3 = coordinate
            
           // destination.append(coordinate)
            //print (destination.count)
        }else if c == 4 {
            map.removeAnnotations(map.annotations) // remove all annotations
            map.removeOverlays(map.overlays) // remove all overlays
            places.removeAll() // empty the places array
            c = 1 // setting c to zero
            
           // destination.removeAll()
            // setting marker to A on fouyrth tap
            anno.title = "A"
            anno.coordinate = coordinate
            places.append(Place(title:anno.title, coordinate:anno.coordinate))
            map.addAnnotation(anno)
            //destination.append(coordinate)
            routeBtn.isHidden = true
            location1 = coordinate
            
        }
        
        
    }
    
    func removeAnnotation (){
        for anno in map.annotations{
            if anno.title != "You Are here"{
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
        removeAnnotation()
        }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        userLocationLatitude = CLLocation(latitude: latitude, longitude: longitude)
        
        displayLocation(lat: latitude, long: longitude, title: "You Are here")
    }
    
    func displayLocation(lat: CLLocationDegrees,
                         long: CLLocationDegrees,
                         title:String){
        
        let latDelta:CLLocationDegrees = 0.5
        let longDelta:CLLocationDegrees = 0.5
        
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
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon{
            let rend = MKPolygonRenderer(overlay: overlay)
            rend.strokeColor = UIColor.green
            rend.fillColor = UIColor.red.withAlphaComponent(0.5)
            rend.lineWidth = 2
            return rend
        } else if overlay is MKPolyline{
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
        marker.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return marker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       
        let alert = UIAlertController(title: "Distance To Your Location", message: String(format: "%.2f", distance/1000), preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelBtn)
        present(alert, animated: true , completion: nil)
    }
   
    
    
}

