//
//  DataViewController.swift
//  barleybreak
//
//  Created by Dmitry Belyaev on 01/11/2019.
//  Copyright © 2019 Dmitry Belyaev. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    var design: Design?
    var index: Int?
    
    private var screenWidth: CGFloat = 0
    private var screenHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenWidth = view.frame.size.width
        screenHeight = view.frame.size.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.6, height: screenWidth * 0.6)
        imageView.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        imageView.frame.origin.y -= (UIApplication.shared.statusBarFrame.height + screenWidth * 0.1 + 30)
        imageView.image = design?.image
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                               action: #selector(onClick(sender:)))
        
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func onClick(sender: UITapGestureRecognizer) {
        Utils.setCurrentDesign(value: design?.name ?? Utils.designNames[0])
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    

}
