//
//  ViewController.swift
//  RJProximityMeter
//
//  Created by Rakesh Jyoti on 12/8/17.
//  Copyright © 2017 RJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func didTapStart(_ sender: UIButton) {
        
        let vc = SetProximityVC.initWithXib()
        self.navigationController?.pushViewController(vc, animated: true)

    }

}

