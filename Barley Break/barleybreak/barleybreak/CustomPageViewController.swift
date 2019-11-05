//
//  CustomPageViewController.swift
//  barleybreak
//
//  Created by Dmitry Belyaev on 01/11/2019.
//  Copyright © 2019 Dmitry Belyaev. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CustomPageViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func onClick() {
        (self.parent as! ChooseDesignViewController).showAdvertisement()
    }

}
