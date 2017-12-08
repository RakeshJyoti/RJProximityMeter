//
//  LocationUpdater.swift
//  ARMap
//
//  Created by Rakesh Jyoti on 12/8/17.
//  Copyright © 2017 RJ. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


let refreshDistance: Double = 10


let LAT_LON_FACTOR: CGFloat = 1.33975031663                      // Used in azimuzh calculation, don't change

internal func radiansToDegrees(_ radians: Double) -> Double
{
    return (radians) * (180.0 / .pi)
}




class LocationUpdater
{
    let locationManager = CLLocationManager()
    var tracking: Bool = false
    
    
    static let shared: LocationUpdater =
    {
        let instance = LocationUpdater()
        
        // setup code
        
        instance.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            instance.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            instance.locationManager.distanceFilter = refreshDistance
//            instance.locationManager.startUpdatingLocation()
//            instance.locationManager.startUpdatingHeading()
        }

        
        
        return instance
        
        
    }()
    
    
    func location() -> CLLocation?
    {
       return LocationUpdater.shared.locationManager.location
        
    }
    
    internal func startTracking(notifyLocationFailure: Bool = false)
    {
        // Request authorization if state is not determined
        if CLLocationManager.locationServicesEnabled()
        {
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined
            {
                if #available(iOS 8.0, *)
                {
                    self.locationManager.requestWhenInUseAuthorization()
                }
                else
                {
                    // Fallback on earlier versions
                }
                
            }
        }
        
        // Start motion and location managers
//        self.motionManager.startAccelerometerUpdates()
        self.locationManager.startUpdatingHeading()
        self.locationManager.startUpdatingLocation()
        
        self.tracking = true
        
        // Location search
//        self.stopLocationSearchTimer()
//        if notifyLocationFailure
//        {
//            self.startLocationSearchTimer()
//
//            // Calling delegate with value 0 to be flexible, for example user might want to show indicator when search is starting.
//            self.delegate?.arTrackingManager?(self, didFailToFindLocationAfter: 0)
//        }
    }
    
    /// Stops location and motion manager
    internal func stopTracking()
    {
//        self.reloadLocationPrevious = nil
//        self.userLocation = nil
//        self.reportLocationDate = nil
//
//        // Stop motion and location managers
//        self.motionManager.stopAccelerometerUpdates()
        self.locationManager.stopUpdatingHeading()
        self.locationManager.stopUpdatingLocation()
        
        self.tracking = false
//        self.stopLocationSearchTimer()
    }
    
    
    internal func azimuthFromUserToLocation(_ location: CLLocation) -> Double
    {
        var azimuth: Double = 0
        if self.locationManager.location == nil
        {
            return 0
        }
        
        let coordinate: CLLocationCoordinate2D = location.coordinate
        let userCoordinate: CLLocationCoordinate2D = self.locationManager.location!.coordinate
        
        // Calculating azimuth
        let latitudeDistance: Double = userCoordinate.latitude - coordinate.latitude;
        let longitudeDistance: Double = userCoordinate.longitude - coordinate.longitude;
        
        // Simplified azimuth calculation
        azimuth = radiansToDegrees(atan2(longitudeDistance, (latitudeDistance * Double(LAT_LON_FACTOR))))
        azimuth += 180.0
        
        return azimuth;
    }

//    func location() -> CLLocation?
//    {
//        return LocationUpdater.shared.locationManager.location
//
//    }
    
//    internal func startTracking(notifyLocationFailure: Bool = false)
//    {
//        // Request authorization if state is not determined
//        if CLLocationManager.locationServicesEnabled()
//        {
//            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined
//            {
//                if #available(iOS 8.0, *)
//                {
//                    self.locationManager.requestWhenInUseAuthorization()
//                }
//                else
//                {
//                    // Fallback on earlier versions
//                }
//
//            }
//        }
//
//        // Start motion and location managers
//        //        self.motionManager.startAccelerometerUpdates()
//        self.locationManager.startUpdatingHeading()
//        self.locationManager.startUpdatingLocation()
//
//        self.tracking = true
//
//        // Location search
//        //        self.stopLocationSearchTimer()
//        //        if notifyLocationFailure
//        //        {
//        //            self.startLocationSearchTimer()
//        //
//        //            // Calling delegate with value 0 to be flexible, for example user might want to show indicator when search is starting.
//        //            self.delegate?.arTrackingManager?(self, didFailToFindLocationAfter: 0)
//        //        }
//    }
//
//    /// Stops location and motion manager
//    internal func stopTracking()
//    {
//        //        self.reloadLocationPrevious = nil
//        //        self.userLocation = nil
//        //        self.reportLocationDate = nil
//        //
//        //        // Stop motion and location managers
//        //        self.motionManager.stopAccelerometerUpdates()
//        self.locationManager.stopUpdatingHeading()
//        self.locationManager.stopUpdatingLocation()
//
//        self.tracking = false
//        //        self.stopLocationSearchTimer()
//    }
//
    

}
