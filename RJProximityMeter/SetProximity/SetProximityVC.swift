//
//  SetProximityVC.swift
//  HelloLithuania
//
//  Created by Rakesh Jyoti on 12/8/17.
//  Copyright © 2017 RJ. All rights reserved.
//

import UIKit
import CoreLocation



internal func degreesToRadians(_ degrees: Double) -> Double
{
    return (degrees) * (.pi / 180.0)
}


class SetProximityVC: UIViewController {

    @IBOutlet weak var viewSub: UIView!
    @IBOutlet weak var viewScale: ProximityScaleView!

    
    let viewRadiuosMeter = RadiousMeter.initWitXibWith()

    
    
    //MARK: -
    
    class func initWithXib() -> SetProximityVC
    {
        let name = String(describing: self)
        let vc = SetProximityVC.init(nibName: name, bundle: Bundle.main)
        
        return vc
    }
    
    //MARK: -

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewRadiuosMeter.setFrame(frame: UIScreen.main.bounds)
        viewSub.addSubview(viewRadiuosMeter)
        viewRadiuosMeter.delegate = self
        
        LocationUpdater.shared.startTracking()
        LocationUpdater.shared.locationManager.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewScale.addTransparentMaskTopAndBottom()
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
    
    
    //MARK: -

    @IBAction func didTapPreviousBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapFinishBtn(_ sender: UIButton) {
        
//        if (self.navigationController?.viewControllers[0].isKind(of: WellComeVC.self))!
//        {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshPlaceList"), object: nil)
//            
//            self.navigationController?.dismiss(animated: true, completion: {
//            })
//            
//        }else
//        {
//            gotoHomeVC()
//        }
        
//        degreesToRadians(<#T##degrees: Double##Double#>)
    }
    
    
    func gotoHomeVC()
    {
        let storyBrd = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let tabBar = storyBrd.instantiateViewController(withIdentifier: "tabBar")
        
        self.navigationController?.pushViewController(tabBar, animated: true)
    }

}


extension SetProximityVC: delegateRadious {

    func didProximityChangedTo(angle: Float, zoomScale: Float) {
        let difference = viewScale.maxRadious - viewScale.minRadious
//        Float(viewScale.minRadious) +
        let distancePerDegree: Float = (Float(difference) / 170.0)
        
        viewScale.setScaleTo(value: (Float(viewScale.maxRadious) - distancePerDegree * angle))
    }
}


extension SetProximityVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let currentLocation: CLLocation = locations.last!
        viewRadiuosMeter.addGoogleMap(currentLocation: currentLocation)
        
        LocationUpdater.shared.stopTracking()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        
    }
    
    
    func calculateDistance(user: CLLocationCoordinate2D, place: CLLocationCoordinate2D) -> Double
    {
        let coordinate₀ = CLLocation.init(latitude: user.latitude, longitude: user.longitude)
        let coordinate₁ = CLLocation.init(latitude: place.latitude, longitude: place.longitude)
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        
        return distanceInMeters
    }
    

    
}



