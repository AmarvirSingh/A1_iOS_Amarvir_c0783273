//
//  File.swift
//  A1_iOS_Amarvir_c0783273
//
//  Created by Amarvir Mac on 26/01/21.
//  Copyright © 2021 Amarvir Mac. All rights reserved.
//

import Foundation
import MapKit

class Place: NSObject, MKAnnotation {
var title: String?
var subtitle: String?
var coordinate: CLLocationCoordinate2D

init(title: String?, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.coordinate = coordinate
}

}
