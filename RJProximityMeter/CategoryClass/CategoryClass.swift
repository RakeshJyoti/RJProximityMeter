//
//  CategoryFiles.swift
//  DemoMenu
//
//  Created by Rakesh Jyoti on 12/8/17.
//  Copyright © 2017 RJ. All rights reserved.
//
import Foundation
import UIKit



extension UIView {
    
    
    // OUTPUT 1
    @IBInspectable var dropShadow: Bool {
        set {
            if newValue
            {
                dropShadow()
            }else
            {
                dropShadow(color: UIColor.clear)
            }
        }
        
        get {
            return false
        }
    }
    
    
    @IBInspectable var shadowColor: UIColor {
        set {
            self.layer.shadowColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
    }
    
    
    @IBInspectable var shadowOffset: CGSize {
        set {
            self.layer.shadowOffset = newValue
        }
        
        get {
            return layer.shadowOffset
        }
    }
    
    
    
    // OUTPUT 2
    func dropShadow(color: UIColor = UIColor.black, opacity: Float = 0.7, offSet: CGSize = CGSize(width: 2, height: 2), radius: CGFloat = 4, scale: Bool = true)
    {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        //        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        //        self.layer.shouldRasterize = true
        //        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    @IBInspectable var cornorRadious: CGFloat {
        
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
        
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var borderUIColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat{
        set {
            self.layer.borderWidth = newValue
        }
        
        get {
            return self.layer.borderWidth
        }
    }
    
    func addTransparentMask() {
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.black.cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 0.85, 1.0]

        self.layer.mask = gradientLayer
    }
    
    func addTransparentMaskTopAndBottom() {
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor,
            UIColor.black.cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 0.15, 0.85, 1.0]
        
        self.layer.mask = gradientLayer
    }

}

extension UITableView {
    
    
    // OUTPUT 1
    @IBInspectable var contentInsectSet: UIEdgeInsets {
        set {

            self.contentInset = newValue
        }
        
        get {
            return self.contentInset
        }
    }

}


