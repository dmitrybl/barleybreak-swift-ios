//
//  MainViewController.swift
//  barleybreak
//
//  Created by Dmitry Belyaev on 14/08/2019.
//  Copyright © 2019 Dmitry Belyaev. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var modePanel: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var designChooseButton: UIButton!
    
    private var screenWidth: CGFloat = 0
    private var screenHeight: CGFloat = 0
    
    private let modes: [String] = ["3x3", "4x4", "5x5", "6x6"]
    private var modeLabels: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Utils.UserDefaultsExists() {
            Utils.initializeUserDefault()
        }
        
        screenWidth = self.view.bounds.size.width
        screenHeight = self.view.bounds.size.height
        
        playButton.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.35, height: screenWidth * 0.35)
        playButton.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        playButton.setBackgroundImage(UIImage(named: "button_play.png"), for: .normal)
        playButton.setBackgroundImage(UIImage(named: "button_play_active.png"), for: .highlighted)
        
        designChooseButton.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.2, height: screenWidth * 0.2)
        designChooseButton.setBackgroundImage(UIImage(named: "design1.png"), for: .normal)
        designChooseButton.frame.origin.x = screenWidth - designChooseButton.frame.width - 15
        designChooseButton.frame.origin.y = UIApplication.shared.statusBarFrame.height + 10
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.7, height: playButton.frame.size.height / 2)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont(name: "Gilroy", size: titleLabel.frame.size.height)
        titleLabel.center.x = screenWidth / 2
        titleLabel.text = "Пятнашки"
        titleLabel.textAlignment = .center
        titleLabel.frame.origin.y = playButton.frame.origin.y - titleLabel.frame.size.height - 30
        
        modePanel.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.7, height: playButton.frame.size.height)
        modePanel.center.x = screenWidth / 2
        modePanel.frame.origin.y = playButton.frame.origin.y + playButton.frame.size.height + 20
        
        let labelModeWidth = modePanel.frame.size.width / 2
        let labelModeHeight = modePanel.frame.size.height / 2
        
        for i in 0...3 {
            let label = UILabel()
            label.text = modes[i]
            modePanel.addSubview(label)
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: 0, width: labelModeWidth, height: labelModeHeight)
            label.frame.origin.x = modePanel.bounds.origin.x + CGFloat((i % 2)) * labelModeWidth
            label.frame.origin.y = modePanel.bounds.origin.y + CGFloat((i / 2)) * labelModeHeight
            label.font = UIFont(name: "Gilroy", size: label.frame.size.height * 0.6)
            label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            label.isUserInteractionEnabled = true
            label.tag = i + 3
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MainViewController.modePanelClicked)))
            modeLabels.append(label)
        }
        
        highlightModes(highlightedMode: Utils.getMode())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setMode(mode: Int) {
        Utils.setMode(value: mode)
        highlightModes(highlightedMode: mode)
    }
    
    private func highlightModes(highlightedMode: Int) {
        for label in modeLabels {
            if label.tag == highlightedMode {
                label.textColor = UIColor.white
            } else {
                label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            }
        }
    }
    
    @objc func modePanelClicked(sender: UITapGestureRecognizer) {
        let clickedObj = sender.view as! UILabel
        setMode(mode: clickedObj.tag)
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        let mode = Utils.getMode()
        let size = "\(mode)x\(mode)"
        let progress = Utils.getProgress(size: size)
        if progress.isEmpty {
            startGame()
        } else {
            
            let alert = UIAlertController(title: "Продолжить игру", message: "Хотите продолжить последнюю сохраненную игру", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
                self.startGame()
            }))
            
            alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { action in
                Utils.setProgress(size: size, value: "")
                self.startGame()
            }))
            
            self.present(alert, animated: true)
            
        }
        
    }
    
    private func startGame() {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
        self.navigationController?.pushViewController(gameVC!, animated: true)
    }
    
    @IBAction func openChooseDesign(_ sender: Any) {
       let chooseDesignVC = self.storyboard?.instantiateViewController(withIdentifier: "ChooseDesignViewController")
       self.navigationController?.pushViewController(chooseDesignVC!, animated: true)
    }
    

}
