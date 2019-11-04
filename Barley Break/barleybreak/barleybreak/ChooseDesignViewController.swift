//
//  ChooseDesignViewController.swift
//  barleybreak
//
//  Created by Dmitry Belyaev on 01/11/2019.
//  Copyright © 2019 Dmitry Belyaev. All rights reserved.
//

import UIKit

class ChooseDesignViewController: UIViewController {
    
    let dataSource = [
        Design(image: UIImage(named: "design1.png"), name: Utils.designNames[0]),
        Design(image: UIImage(named: "design2.png"), name: Utils.designNames[1]),
        Design(image: UIImage(named: "design3.png"), name: Utils.designNames[2]),
        Design(image: UIImage(named: "design4.png"), name: Utils.designNames[3]),
        Design(image: UIImage(named: "design5.png"), name: Utils.designNames[4]),
        Design(image: UIImage(named: "design6.png"), name: Utils.designNames[5])
    ]
    
    var currentViewControllerIndex = 0

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    private var screenWidth: CGFloat = 0
    private var screenHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenWidth = view.frame.size.width
        screenHeight = view.frame.size.height

        backButton.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.1,
                                  height: screenWidth * 0.1)
        
        backButton.frame.origin.x = screenWidth * 0.05
        backButton.frame.origin.y = UIApplication.shared.statusBarFrame.height + 10
        
        let contentViewYPos = backButton.frame.origin.y + backButton.frame.size.height + 20
        let contentViewHeight = screenHeight - contentViewYPos - screenHeight * 0.05
        contentView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: contentViewHeight)
        
        contentView.frame.origin.x = 0
        contentView.frame.origin.y = contentViewYPos
        
        let currentDesign = Utils.getCurrentDesign()
        switch currentDesign {
            case Utils.designNames[0]:
                currentViewControllerIndex = 0
                break
            case Utils.designNames[1]:
                currentViewControllerIndex = 1
                break
            case Utils.designNames[2]:
                currentViewControllerIndex = 2
                break
            case Utils.designNames[3]:
                currentViewControllerIndex = 3
                break
            case Utils.designNames[4]:
                currentViewControllerIndex = 4
                break
            case Utils.designNames[5]:
                currentViewControllerIndex = 5
                break
            default:
                currentViewControllerIndex = 0
        }
        
        configurePageViewController()
        
    }
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configurePageViewController() {
        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: "CustomPageViewController") as? CustomPageViewController
            else {
            return
        }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
    
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        pageViewController.view.frame.size.height -= pageViewController.view.frame.size.height * 0.2
        
        contentView.addSubview(pageViewController.view)
        
        guard let startingViewController = detailViewControllerAt(index: currentViewControllerIndex) else {
            return
        }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
        
    }
    
    private func detailViewControllerAt(index: Int) -> DataViewController? {
        
        if index >= dataSource.count || dataSource.count == 0 {
            return nil
        }
        
        guard let dataViewController = storyboard?.instantiateViewController(withIdentifier: "DataViewController") as? DataViewController else {
            return nil
        }
        
        dataViewController.index = index
        dataViewController.design = dataSource[index]
        
        return dataViewController
    }
    
}

extension ChooseDesignViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let dataViewController = viewController as? DataViewController
        
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let dataViewController = viewController as? DataViewController
        
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        
        if currentIndex == dataSource.count {
            return nil
        }
        
        currentIndex += 1
        currentViewControllerIndex = currentIndex
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataSource.count
    }
    
}
