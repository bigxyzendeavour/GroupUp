//
//  LocationService.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-19.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import Foundation
import MapKit

typealias JSONDictionary = [String:Any]

class LocationServices {
    
    static let shared = LocationServices()
    let locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    let authStatus = CLLocationManager.authorizationStatus()
    let inUse = CLAuthorizationStatus.authorizedWhenInUse
    let always = CLAuthorizationStatus.authorizedAlways
    
    func getAddress(location: CLLocation, completion: @escaping (_ address: JSONDictionary?, _ error: Error?) -> ()) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            
            if let e = error {
                
                completion(nil, e)
                
            } else {
                
                let placeArray = placemarks as [CLPlacemark]!
                
                var placeMark: CLPlacemark!
                
                placeMark = placeArray?[0]
                
                guard let address = placeMark.addressDictionary as? JSONDictionary else {
                    return
                }
                
                completion(address, nil)
            }
        }
    }
    
    func getLocation(address: String, completion: @escaping (_ location: CLLocation?, _ error: Error?) -> ()) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            
            if let e = error {
                
                completion(nil, e)
                
            } else{
                
                let placeArray = placemarks as [CLPlacemark]!
                
                var placeMark: CLPlacemark!
                
                placeMark = placeArray?.first
                
                let destinationLocation = placeMark.location
                
                completion(destinationLocation, nil)
            }
            
        })
    }
}
