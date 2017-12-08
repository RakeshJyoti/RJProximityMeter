//
//  ProximityScale.swift
//  DemoPractice
//
//  Created by Rakesh Jyoti on 12/8/17.
//  Copyright © 2017 RJ. All rights reserved.
//

import UIKit


let proximityRadious: String = "proximityRadious"



class CellScale: UITableViewCell {
    
    var viewScaleMarker: UIView?
    var lblMarkerValue: UILabel?
    
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //
    //        initViews()
    //    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initViews()
    }
    
    
    func initViews() {
        if viewScaleMarker == nil
        {
            self.backgroundColor = UIColor.clear
            viewScaleMarker = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 1))
            self.addSubview(viewScaleMarker!)
            
            lblMarkerValue = UILabel.init(frame: CGRect.zero)
            lblMarkerValue?.textAlignment = .right
            lblMarkerValue?.font = UIFont.systemFont(ofSize: 14)
            lblMarkerValue?.textColor = UIColor.white
            self.addSubview(lblMarkerValue!)
        }
        
        self.colorChange()
    }
    
    
    func smallMarker(width: CGFloat, height: CGFloat) {
        
        var rect: CGRect = viewScaleMarker!.frame
        rect.size.width = 10
        rect.size.height = 1
        rect.origin.x = width - rect.size.width
        rect.origin.y = height/2 - rect.size.height/2
        
        viewScaleMarker?.frame = rect
        viewScaleMarker?.backgroundColor = UIColor.white
        
        lblMarkerValue?.isHidden = true
    }
    
    func mediumMarker(width: CGFloat, height: CGFloat) {
        
        var rect: CGRect = viewScaleMarker!.frame
        rect.size.width = 16
        rect.size.height = 1
        rect.origin.x = width - rect.size.width
        rect.origin.y = height/2 - rect.size.height/2
        
        viewScaleMarker?.frame = rect
        viewScaleMarker?.backgroundColor = UIColor.white
        
        lblMarkerValue?.isHidden = true
    }
    
    func largeMarker(width: CGFloat, height: CGFloat, markerText: String = "") {
        
        var rect: CGRect = viewScaleMarker!.frame
        rect.size.width = 25
        rect.size.height = 2
        rect.origin.x = width - rect.size.width
        rect.origin.y = height/2 - rect.size.height/2
        
        viewScaleMarker?.frame = rect
        viewScaleMarker?.backgroundColor = UIColor.white
        
        lblMarkerValue?.isHidden = false
        
        rect.size.width = width - rect.size.width - 8
        rect.size.height = height
        rect.origin = CGPoint.zero
        lblMarkerValue?.frame = rect
        
        lblMarkerValue?.text = markerText
    }
    
    
    func colorChange(color: UIColor = UIColor.white) {
        
        lblMarkerValue?.textColor = color
        viewScaleMarker?.backgroundColor = color
        
        UIView.animate(withDuration: 0.25) {
            
            if color == UIColor.white {
                self.lblMarkerValue?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            }else {
                
                self.lblMarkerValue?.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            }
        }
    }
}




class ProximityScaleView: UIView {

    var tblScale: UITableView!

    let maxRadious: NSInteger = 15
    let minRadious: NSInteger = 1
    let cellHeight = 12
    var previousCell: CellScale?

    let scaleDivisionPerSingleUnite = 6


    override func awakeFromNib() {
        super.awakeFromNib()
        
        tblScale = UITableView.init(frame: self.bounds)
        tblScale.register(CellScale.self, forCellReuseIdentifier: "proCell")
        tblScale.delegate = self
        tblScale.dataSource = self
        tblScale.separatorStyle = .none
        self.addSubview(tblScale)
        tblScale.backgroundColor = UIColor.clear
        tblScale.reloadData()
        tblScale.bounces = false
        tblScale.showsVerticalScrollIndicator = false
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tblScale.frame = self.bounds
        tblScale.contentInset = UIEdgeInsetsMake(tblScale.frame.size.height/2, 0, tblScale.frame.size.height/2 - 5, 0)

    }
    
    
    func setScaleTo(value: Float) {
        let yPosition = Int((value) * Float(scaleDivisionPerSingleUnite * cellHeight)) - Int(tblScale.contentInset.top + 10)
        let point: CGPoint = CGPoint.init(x: 0, y: yPosition)
        tblScale.setContentOffset(point, animated: true)
    }
}


extension ProximityScaleView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ((maxRadious - minRadious) * scaleDivisionPerSingleUnite) + 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(cellHeight)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "proCell") as? CellScale
        if cell == nil {
            cell = CellScale.init(style: .default, reuseIdentifier: "proCell")
        }
        cell!.initViews()
        
        switch indexPath.row % 6 {
        case 0:
            cell!.largeMarker(width: tblScale.frame.size.width, height: CGFloat(cellHeight), markerText: "\(minRadious + (indexPath.row / 6)) KM")
            
        case 3:
            cell!.mediumMarker(width: tblScale.frame.size.width, height: CGFloat(cellHeight))
            
        default:
            cell!.smallMarker(width: tblScale.frame.size.width, height: CGFloat(cellHeight))
            
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (previousCell != nil) {
            previousCell?.colorChange()
        }
        
        let centerPoint = CGPoint.init(x: tblScale.frame.size.width/2, y: tblScale.frame.size.height/2 + scrollView.contentOffset.y)
        
        
        guard let indexPath: NSIndexPath = tblScale.indexPathForRow(at: centerPoint) as NSIndexPath? else {
            return
        }
        
        let cell = tblScale.cellForRow(at: indexPath as IndexPath) as? CellScale
        
        cell?.colorChange(color: selectedColor)
        
        print("indexPath:::::::Row::::::::\(indexPath.row)")
        
        let totalRadious = 1000 + ((indexPath.row/scaleDivisionPerSingleUnite) * 1000) + ((indexPath.row%scaleDivisionPerSingleUnite) * (1000/scaleDivisionPerSingleUnite))
        print("Radious:::::::::::::::::::::::::::::::::::\(totalRadious)Meter")
        
        UserDefaults.standard.set(totalRadious, forKey: proximityRadious)
        
        
        previousCell = cell
    }
    
}


