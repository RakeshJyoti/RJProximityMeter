//
//  RadiousMeter.swift
//  DemoMenu
//
//  Created by Rakesh Jyoti on 12/8/17.
//  Copyright © 2017 RJ. All rights reserved.
//

import UIKit
import GoogleMaps


protocol delegateRadious: class {
    
    func didProximityChangedTo(angle: Float, zoomScale: Float)
}




let selectedColor: UIColor = UIColor.init(red: 83.0/255.0, green: 161.0/255.0, blue: 254.0/255.0, alpha: 1.0)
let normalColor: UIColor = UIColor.init(red: 170.0/255.0, green: 177.0/255.0, blue: 178.0/255.0, alpha: 1.0)



class RadiousMeter: UIView
{

    @IBOutlet weak var viewHalfCircle: UIView!
    @IBOutlet weak var viewHalfPointer: UIView!
    @IBOutlet weak var cnstCenterX: NSLayoutConstraint!
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var imgMarker: UIImageView!

    weak var delegate: delegateRadious?
    
    var googleCamera: GMSCameraPosition!
    var googleMapView: GMSMapView!
    
    let minZoom: Float = 8.0
    
    
    var isTouchedOnPointer: Bool = false
    var shapeLayer = CAShapeLayer()

    let paddingAngle: Float = 7

    
    var currentLocationGlobal: CLLocation?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    class func initWitXibWith() -> RadiousMeter
    {
        let radiousMeterr = UINib.init(nibName: "RadiousMeter", bundle: nil).instantiate(withOwner: self, options: nil).first as! RadiousMeter
        
        
        return radiousMeterr
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rotatePointerWith(angle: 90.0)
        viewHalfCircle.cornorRadious = viewHalfCircle.frame.size.width/2
        viewHalfCircle.borderWidth = 12
        viewHalfCircle.borderUIColor = normalColor
    }
    
    
    func addGoogleMap(currentLocation: CLLocation?)
    {
        currentLocationGlobal = currentLocation
        if currentLocationGlobal == nil
        {
            currentLocationGlobal = LocationUpdater.shared.locationManager.location
        }
        if currentLocationGlobal == nil
        {
            currentLocationGlobal = CLLocation.init(latitude: 0.00000, longitude: 0.00000)
        }
        
        
        if googleMapView == nil
        {
            googleCamera = GMSCameraPosition.camera(withLatitude: (currentLocationGlobal?.coordinate.latitude)!, longitude: (currentLocationGlobal?.coordinate.longitude)!, zoom: minZoom)
            googleMapView = GMSMapView.map(withFrame: viewMap.bounds, camera: googleCamera)

            rotatePointerWith(angle: 90.0)

            viewMap.addSubview(googleMapView)
            googleMapView.center = CGPoint.init(x: googleMapView.center.x+20, y: googleMapView.center.y)
            googleMapView.isMyLocationEnabled = true
//            googleMapView
            googleMapView.isUserInteractionEnabled = false
            
            do {
//                // Set the map style by passing the URL of the local file.
//                if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
//                    let styleJSONStr = styleJSON()
//                    googleMapView.mapStyle = try GMSMapStyle.init(jsonString: styleJSONStr)
//                } else {
//                    NSLog("Unable to find style.json")
//                }

                
//                NSString *filePath = [[NSBundle mainBundle] pathForResource:@"filename" ofType:@"json"];
//                NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];

                
                if let filePath = Bundle.main.url(forResource: "Style", withExtension: "json") {
                    
                    googleMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: filePath)

                } else {
                    NSLog("Unable to find style.json")
                }
                
//                let styleJSONStr = self.styleJSON()
//                googleMapView.mapStyle = try GMSMapStyle.init(jsonString: styleJSONStr)
            
            } catch {
                NSLog("One or more of the map styles failed to load. \(error)")
            }
        }
    }
    
    
    func zoomCamera(withRespectTo angle: Float) {
        
        if currentLocationGlobal != nil
        {
            let maxZoom: Float = 16.0
            let zoomPerDegree = Float(maxZoom - minZoom) / Float(180 - 2*paddingAngle)
            
            let zoom = minZoom + (zoomPerDegree * (angle - paddingAngle))
            googleCamera = GMSCameraPosition.camera(withLatitude: (currentLocationGlobal?.coordinate.latitude)!, longitude: (currentLocationGlobal?.coordinate.longitude)!, zoom: zoom)
            
            googleMapView.camera = googleCamera
            
            delegate?.didProximityChangedTo(angle: angle, zoomScale: zoom)
        }
    }
    
    
    func setFrame(frame: CGRect)
    {
        self.frame = frame
        cnstCenterX.constant = -(frame.size.width/2)
        viewHalfCircle.layer.cornerRadius = viewHalfCircle.frame.size.width/2
   
        self.layoutIfNeeded()
//        rotatePointerWith(angle: -10.0)
    }
    
    
    //MARK: -
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
//        let touch = touches.first
        for touch in touches
        {
            let view = touch.view
            if view == imgMarker
            {
                isTouchedOnPointer = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if isTouchedOnPointer
        {
            let touch = touches.first!
            let location = touch.location(in: self)
            
            let centerHalfCircle = viewHalfCircle.center
            
            
            let angle = getAngleFromPoints(first: CGPoint.init(x: centerHalfCircle.x, y: 0), second: centerHalfCircle, third: location)
            
            rotatePointerWith(angle: angle)
        }
    }
    
    
    func rotatePointerWith(angle: CGFloat)
    {
        print("angleDegree: %.1f°, ", angle);
        
        let angleLocal = -1 * fabsf(Float(angle))

        if fabsf(Float(angleLocal)) > paddingAngle && fabsf(Float(angleLocal)) < (Float(180.0) - paddingAngle)
        {
            zoomCamera(withRespectTo: fabsf(Float(angleLocal)))
            
            let actualAngle = angleLocal * Float(Double.pi / 180)
            //        actualAngle = actualAngle - CGFloat(Double.pi / 2)
            
            viewHalfPointer.transform = CGAffineTransform.init(rotationAngle: CGFloat(-actualAngle));
            
            
            /////////////////// draw circle///////////////////
            let startAngle = CGFloat(Double.pi / 2)
            let endAngle = fabsf(actualAngle) - Float(startAngle)
            
            let circlePath = UIBezierPath(arcCenter: viewHalfCircle.center, radius: viewHalfCircle.frame.size.width/2 - viewHalfCircle.borderWidth/2, startAngle: startAngle, endAngle:CGFloat(endAngle), clockwise: true)
            
            shapeLayer.path = circlePath.cgPath
            
            //change the fill color
            shapeLayer.fillColor = UIColor.clear.cgColor
            //you can change the stroke color
            shapeLayer.strokeColor = selectedColor.cgColor
            //you can change the line width
            shapeLayer.lineWidth = viewHalfCircle.borderWidth
            
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isTouchedOnPointer = false
    }
    
    
    //MARK: -
    
    func getAngleFromPoints(first: CGPoint, second: CGPoint, third: CGPoint) -> CGFloat
    {
        let vec1: CGVector = CGVector.init(dx: first.x - second.x, dy: first.y - second.y)
        let vec2: CGVector = CGVector.init(dx: third.x - second.x, dy: third.y - second.y)
        
        let theta1: CGFloat = CGFloat(atan2f(Float(vec1.dy), Float(vec1.dx)));
        let theta2: CGFloat = CGFloat(atan2f(Float(vec2.dy), Float(vec2.dx)));
        
        let angleRadien: CGFloat = theta1 - theta2;
        let angleDegree: CGFloat = angleRadien * CGFloat(180 / Double.pi)
        
//        print("angleRadien: %.1f°,", angleRadien);
//        
//        print("angleDegree: %.1f°, ", angleDegree);
        
        return angleDegree
        
    }
}



