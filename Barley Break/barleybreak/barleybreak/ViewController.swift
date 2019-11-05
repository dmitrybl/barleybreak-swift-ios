//
//  ViewController.swift
//  barleybreak
//
//  Created by Dmitry Belyaev on 09/08/2019.
//  Copyright © 2019 Dmitry Belyaev. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var gameFieldView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bestLabel: UILabel!
    
    private var positions = Array<Int>()
    private var objectsImages = Array<UIImageView>()
    
    private var screenWidth: CGFloat = 0
    private var screenHeight: CGFloat = 0
    
    private var gameFieldSize: CGFloat = 0
    private var elemSize: CGFloat = 0
    
    private var numbersInRow = 4
    private var number = 15
    private var size = "4x4"
    private var empty = 0
    
    private var numSteps = 0
    private var highScore = 0
    
    private var progress = ""
    
    private var currentDesign = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-7476185376948341/7928952521"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7476185376948341/8148444370")
        let request = GADRequest()
        interstitial.load(request)
        
        numbersInRow = UserDefaults.standard.integer(forKey: "mode")
        number = numbersInRow * numbersInRow - 1
        size = "\(numbersInRow)x\(numbersInRow)"
        highScore = Utils.getHighScore(size: size)
        progress = Utils.getProgress(size: size)
        currentDesign = Utils.getCurrentDesign()
        if progress.isEmpty {
            numSteps = 0
        } else {
            numSteps = Utils.getSavedScore(size: size)
        }
        initUI()
        initializeObjectPositions()
    }
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        saveProgress()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func initUI() {
        screenWidth = view.frame.size.width
        screenHeight = view.frame.size.height
        
        backButton.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.1,
                                  height: screenWidth * 0.1)
        
        backButton.frame.origin.x = screenWidth * 0.05
        backButton.frame.origin.y = UIApplication.shared.statusBarFrame.height + 10
        
        scoreLabel.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.2, height: screenWidth * 0.1)
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.font = UIFont(name: "Roboto-Bold", size: scoreLabel.frame.size.height * 0.7)
        scoreLabel.frame.origin.x = backButton.frame.origin.x + backButton.frame.size.width + 20
        scoreLabel.frame.origin.y = backButton.frame.origin.y
        
        scoreLabel.text = "\(numSteps)"
        scoreLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        scoreLabel.textAlignment = .left
        
        bestLabel.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.4,
                                 height: screenWidth * 0.1)
        bestLabel.adjustsFontSizeToFitWidth = true
        bestLabel.font = UIFont(name: "Roboto-Bold", size: scoreLabel.frame.size.height * 0.7)
        bestLabel.frame.origin.x = screenWidth - bestLabel.frame.size.width - 10
        bestLabel.frame.origin.y = backButton.frame.origin.y
        bestLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        bestLabel.textAlignment = .left
        
        if highScore == 0 {
            bestLabel.text = "Лучший: -"
        } else {
            bestLabel.text = "Лучший: \(highScore)"
        }
        
        gameFieldView.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.9, height: screenWidth * 0.9)
        
        gameFieldView.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        
        gameFieldSize = gameFieldView.frame.size.width
        
        elemSize = gameFieldSize / CGFloat(numbersInRow)
       
        for i in 0...number {
            
            let image = UIImage(named: "\(currentDesign)image\(i).png")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: elemSize, height: elemSize)
            objectsImages.append(imageView)
            
            let emptyImage = UIImage(named: "\(currentDesign)image0.png")
            let emptyImageView = UIImageView(image: emptyImage)
            emptyImageView.frame = CGRect(x: 0, y: 0, width: elemSize, height: elemSize)
            emptyImageView.frame.origin.x = elemSize * CGFloat((i % numbersInRow))
            emptyImageView.frame.origin.y = elemSize * CGFloat((i / numbersInRow))
            gameFieldView.addSubview(emptyImageView)
            
        }
        
        for i in 0..<number {
            objectsImages[i + 1].frame.origin.x = elemSize * CGFloat((i % numbersInRow))
            objectsImages[i + 1].frame.origin.y = elemSize * CGFloat((i / numbersInRow))
            gameFieldView.addSubview(objectsImages[i + 1])
        }
        
        let touchGestureRecognizer = SingleTouchDownGestureRecognizer(target: self, action: #selector(onClick(sender:)))
        
        gameFieldView.addGestureRecognizer(touchGestureRecognizer)
 
    }
    
    private func initializeObjectPositions() {
        positions.removeAll()
        if progress.isEmpty {
            for i in 1...number {
                positions.append(i)
            }
            positions.append(0)
            
            var directions = Array<Int>()
            empty = number
            for _ in 0..<250 {
                directions.removeAll()
                switch empty {
                    case number:
                        directions.append(-1 * numbersInRow)
                        directions.append(-1)
                        break
                    case numbersInRow - 1:
                        directions.append(numbersInRow)
                        directions.append(-1)
                        break
                    case 0:
                        directions.append(1)
                        directions.append(numbersInRow)
                        break
                    case number - (numbersInRow - 1):
                        directions.append(1)
                        directions.append(-1 * numbersInRow)
                        break
                    case empty where empty % numbersInRow == 0:
                        directions.append(1)
                        directions.append(numbersInRow)
                        directions.append(-1 * numbersInRow)
                        break
                    case empty where empty % numbersInRow == numbersInRow - 1:
                        directions.append(-1)
                        directions.append(-1 * numbersInRow)
                        directions.append(numbersInRow)
                        break
                    case empty where empty - numbersInRow < 0:
                        directions.append(1)
                        directions.append(-1)
                        directions.append(numbersInRow)
                        break
                    case empty where empty + numbersInRow > number:
                        directions.append(1)
                        directions.append(-1)
                        directions.append(-1 * numbersInRow)
                        break
                    default:
                        directions.append(-1)
                        directions.append(1)
                        directions.append(numbersInRow)
                        directions.append(-1 * numbersInRow)
                    
                }
                
                let randomNumber = Int.random(in: 0..<directions.count)
                let value = positions[empty + directions[randomNumber]]
                positions[empty + directions[randomNumber]] = 0
                positions[empty] = value
                empty += directions[randomNumber]
            
                
            }
            
        } else {
            let list = progress.split(separator: " ")
            
            for i in 0..<list.count {
                let n = Int(list[i])
                if n == 0 {
                    empty = i
                }
                positions.append(n!)
            }
           
        }
        
        for i in positions.indices {
            
            objectsImages[positions[i]].frame.origin.x = gameFieldView.bounds.origin.x
                + elemSize * CGFloat((i % numbersInRow))
            objectsImages[positions[i]].frame.origin.y = gameFieldView.bounds.origin.y
                + elemSize * CGFloat((i / numbersInRow))
            
        }
    }
    
    @objc func onClick(sender: UITapGestureRecognizer) {
        let point = sender.location(in: gameFieldView)
        let x = Int(point.x) / Int(elemSize)
        let y = Int(point.y) / Int(elemSize)
        
        let index = y * numbersInRow + x
        if(index == empty) {
            return
        }
        
    
        if (abs(empty - index) % numbersInRow == 0) {
        
            if (empty < index) {
                while (empty + numbersInRow <= index) {
                    let value = positions[empty + numbersInRow]
                    positions[empty] = value
                    positions[empty + numbersInRow] = 0
                    
                    numSteps += 1
                    scoreLabel.text = "\(numSteps)"
                    
                    let lastElement = objectsImages[positions[empty]]
                    animateView(view: lastElement, direction: "up")
                    empty += numbersInRow
                }
                
                if (checkWin()) {
                    if (numSteps < highScore || highScore == 0) {
                        highScore = numSteps
                        bestLabel.text = "Лучший: \(highScore)"
                        Utils.setHighScore(size: size, value: highScore)
                    }
                    resetProgress()
                    showGameOverDialog()
                }
                
            } else if (empty > index) {
                while (empty - numbersInRow >= index) {
                    let value = positions[empty - numbersInRow]
                    positions[empty] = value
                    positions[empty - numbersInRow] = 0
                    
                    numSteps += 1
                    scoreLabel.text = "\(numSteps)"
                    
                    let lastElement = objectsImages[positions[empty]]
                    animateView(view: lastElement, direction: "down")
                    empty -= numbersInRow
                }
                
                if (checkWin()) {
                    if (numSteps < highScore || highScore == 0) {
                        highScore = numSteps
                        bestLabel.text = "Лучший: \(highScore)"
                        Utils.setHighScore(size: size, value: highScore)
                    }
                    resetProgress()
                    showGameOverDialog()
                }
               
            }
        } else if (empty / numbersInRow == index / numbersInRow) {
            if (empty < index) {
                while (empty + 1 <= index) {
                    let value = positions[empty + 1]
                    positions[empty] = value
                    positions[empty + 1] = 0
                    
                    numSteps += 1
                    scoreLabel.text = "\(numSteps)"
                    
                    let lastElement = objectsImages[positions[empty]]
                    animateView(view: lastElement, direction: "left")
                    empty += 1
                }
                
                if (checkWin()) {
                    if (numSteps < highScore || highScore == 0) {
                        highScore = numSteps
                        bestLabel.text = "Лучший: \(highScore)"
                        Utils.setHighScore(size: size, value: highScore)
                    }
                    resetProgress()
                    showGameOverDialog()
                }
                
            } else if (empty > index) {
                while (empty - 1 >= index) {
                    let value = positions[empty - 1]
                    positions[empty] = value
                    positions[empty - 1] = 0
                    
                    numSteps += 1
                    scoreLabel.text = "\(numSteps)"
                    
                    let lastElement = objectsImages[positions[empty]]
                    animateView(view: lastElement, direction: "right")
                    empty -= 1
                }
                
                if (checkWin()) {
                    if (numSteps < highScore || highScore == 0) {
                        highScore = numSteps
                        bestLabel.text = "Лучший: \(highScore)"
                        Utils.setHighScore(size: size, value: highScore)
                    }
                    resetProgress()
                    showGameOverDialog()
                }
            }
        }
       
    }
    
    private func checkWin() -> Bool {
        if (positions[number] != 0) {
            return false
        }
        for i in 1..<number {
            if (positions[i] - positions[i - 1] != 1) {
                return false
            }
        }
        return true
    }
    
    private func animateView(view: UIView, direction: String) {
        UIView.transition(with: view, duration: 0.2, options: .showHideTransitionViews,
            animations: {
                switch(direction) {
                    case "up":
                        view.frame.origin.y -= self.elemSize
                        break
                    case "down":
                        view.frame.origin.y += self.elemSize
                        break
                    case "left":
                        view.frame.origin.x -= self.elemSize
                        break
                    case "right":
                        view.frame.origin.x += self.elemSize
                        break
                    default: break
            }}, completion: nil)
    }
    
    private func newGame() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
        numSteps = 0
        progress = ""
        resetProgress()
        scoreLabel.text = "\(numSteps)"
        initializeObjectPositions()
    }
    
    private func showGameOverDialog() {
        let alert = UIAlertController(title: "Игра окончена", message: "Вы собрали пятнашки за \(numSteps) ходов. Начать игру сначала?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            self.newGame()
        }))
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
        
    }
    
    private func saveProgress() {
        var progress = ""
        for index in positions {
            progress += "\(index) "
        }
        Utils.setProgress(size: size, value: progress)
        Utils.setSavedScore(size: size, value: numSteps)
    }
    
    private func resetProgress() {
        Utils.setProgress(size: size, value: "")
        Utils.setSavedScore(size: size, value: 0)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
}

