//
//  MainViewController.swift
//  JellyPop
//
//  Created by Syafa Sofiena on 28/4/2023.
//

import UIKit

// Controller for main game
class MainViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var initTimerLabel: UILabel!
    @IBOutlet weak var bubbleViewContainer: UIView!
    
    // Variables to store game state and configuration
        // Player
    var playerName: String = ""
    var gameScore: Float = 0
    var remainingTime: Int = 60
    var maxBubbles: Int = 15
    
        // Timer
    var initTimerCount: Int = 3
    var initTimer = Timer()
    var timer = Timer()
    var initialGameTime: Int = 60
    
        // Highscore
    var highScore: Float = 0
    var highScoreExceededFlag: Bool = false
    
        // Bubbles
    var lastPopped: String!
    var comboLength: Int = 0
    var bubblesRemoved: Int = 0
    var randomBubbles: Int = 0
    var bubblesAvailable: Int = 0

        // User defaults
    let userDefaults = UserDefaults.standard
    let defaultPlayerName = "Zhang Hao"
    let defaultTimeLimit = 60
    let defaultMaxBubbles = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up initial game state and configuration
        playerName = userDefaults.value(forKey: "playerName") as? String ?? defaultPlayerName
        remainingTime = userDefaults.value(forKey: "timeLimit") as? Int ?? defaultTimeLimit
        maxBubbles = userDefaults.value(forKey: "maxBubbles") as? Int ?? defaultMaxBubbles
        initialGameTime = remainingTime
        remainingTimeLabel.text = String(remainingTime)
        scoreLabel.text = String(gameScore)
        fetchHighScore()
        // Set up and start the initialisation timer
        initTimerLabel.text = "Ready?"
        initTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            initTimer in
            self.initCountdown()
        }
    }
    
    // Fetch the high score from UserDefaults
    @objc func fetchHighScore(){
        var fetchedScores: [HighScore]
        if let data = UserDefaults.standard.value(forKey:"HighScores") as? Data {
            fetchedScores = try! PropertyListDecoder().decode(Array<HighScore>.self, from: data)
            if(fetchedScores.isEmpty == false){
                highScore = fetchedScores[0].score
            }
            else{
            highScore = 0
            }
            highScoreLabel.text = String(highScore)
        }
    }
    
    // Handle the initialisation countdown
    @objc func initCountdown(){
        if(initTimerCount>0){
        initTimerLabel.text = String(initTimerCount)
        initTimerCount = initTimerCount - 1
        }
        else if(initTimerCount == 0){
            initTimerLabel.text = "Jelly POP!"
            initTimerCount = initTimerCount - 1
        }
        else{
            initTimerLabel.removeFromSuperview()
            launchGame()
            initTimer.invalidate()
        }
    }
    
    // Launch the game and start the game timer
    @objc func launchGame(){
        userDefaults.set(Int(bubbleViewContainer.frame.width), forKey: "frameWidth")
        userDefaults.set(Int(bubbleViewContainer.frame.height), forKey: "frameHeight")
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.generateBubble()
            self.counting()
            self.removeBubble()
        }
    }
    
    // Update the remaining time and handle game over
    @objc func counting() {
        remainingTime = remainingTime - 1
        remainingTimeLabel.text = String(remainingTime)
        if remainingTime == 0 {
            timer.invalidate()
            let vc = storyboard?.instantiateViewController(identifier: "ScoresViewController") as! ScoresViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.setHidesBackButton(true, animated: true)
            vc.currentName = self.playerName
            vc.currentScore = gameScore
            vc.gamePLayFlag = true
        }
    }
    
    // Randomise bubble image based on probability
    @objc func randomisedImage() -> String {
        var imageName: String
        let number: Int = Int.random(in: 1...100)
        switch number {
        case 1...40:
            imageName = "RedBubble"
            break
        case 41...70:
            imageName = "PinkBubble"
            break
        case 71...85:
            imageName = "GreenBubble"
            break
        case 86...95:
            imageName = "BlueBubble"
            break
        case 95...100:
            imageName = "BlackBubble"
            break
        default:
            imageName = "RedBubble"
            break
        }
        return imageName
    }
    
    // Generate bubbles and add them to the bubble container view
    @objc func generateBubble() {
        if(maxBubbles == bubblesAvailable){
            randomBubbles = 1
        } else {
            randomBubbles = Int.random(in: 1...maxBubbles-bubblesAvailable)
        }
        for _ in 1...randomBubbles {
            let bubble = Bubble()
            bubble.setProperties(imageName: randomisedImage())
            bubble.animation()
            bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
            var intersectionCheck = 0
            for i in bubbleViewContainer.subviews {
                if(bubble.frame.intersects(i.frame) && type(of: i) == Bubble.self) {
                    intersectionCheck = 1
                }
            }
            if(intersectionCheck == 0) {
                bubbleViewContainer.addSubview(bubble)
                bubblesAvailable = bubblesAvailable + 1 // Bubble counter
            }
        }
    }

    // Remove random bubbles from the bubble container view
    @objc func removeBubble(){
        bubblesRemoved = Int.random(in: 1...bubblesAvailable)
        if(bubblesRemoved == bubblesAvailable){
            bubblesRemoved = bubblesRemoved - 1
        }
        for i in bubbleViewContainer.subviews{
            if(type(of: i) == Bubble.self && bubblesRemoved>0){
                i.removeFromSuperview()
                bubblesAvailable = bubblesAvailable - 1
                bubblesRemoved = bubblesRemoved - 1
            }
        }
    }
    
    // Determine the score of a bubble based on its image
    @objc func scoreCard(imageName: String) -> Float {
        var score: Float
        switch imageName {
        case "RedBubble":
            score = 1
            break
        case "PinkBubble":
            score = 2
            break
        case "GreenBubble":
            score = 5
            break
        case "BlueBubble":
            score = 8
            break
        case "BlackBubble":
            score = 10
            break
        default:
            score = 1
            break
        }
        return score
    }
    
    // Update high score if the player exceeds the current high score
    @objc func highScoreUpdate(){
        if(gameScore > highScore){
            if(highScoreExceededFlag == false){
                highScoreExceededFlag = true
            }
            if(highScoreExceededFlag == true){
                highScore = gameScore
                highScoreLabel.text = String(highScore)
            }
        }
    }
    
    // Display the scoring animation when a bubble is popped
    @objc func popTag(cX: Int, cY: Int, score: Float, comboLength: Int){
        let popLabel = UILabel(frame: CGRect(x: cX, y: cY-25, width: 100, height: 20))
        popLabel.textColor = UIColor.red
        popLabel.font = UIFont(name: "Futura-Medium", size: 22)
        popLabel.textAlignment = .center
        if(comboLength == 0){
            popLabel.text = "+ \(score)"
        }
        else{
            popLabel.text = "+ \(1.5 * score)"
        }
        bubbleViewContainer.addSubview(popLabel)
        UIView.animate(withDuration: 0.5, delay: 0.6, options: .curveEaseOut, animations: {
            popLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            popLabel.removeFromSuperview()
        })
        if(comboLength > 0){
            let comboLabel = UILabel(frame: CGRect(x: cX, y: cY-50, width: 100, height: 20))
            comboLabel.textColor = UIColor.red
            comboLabel.font = UIFont(name: "Futura-Medium", size: 22)
            comboLabel.textAlignment = .center
            comboLabel.text = "Combo \(comboLength)!"
            bubbleViewContainer.addSubview(comboLabel)
            
            UIView.animate(withDuration: 0.5, delay: 0.6, options: .curveEaseOut, animations: {
                comboLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                comboLabel.removeFromSuperview()
            })
        }
    }
    
    // Handle the event when a bubble is pressed
    @IBAction func bubblePressed(_ sender: UIButton) {
        let imageName = (sender.backgroundImage(for: .normal)?.accessibilityIdentifier)!
        let popScore = scoreCard(imageName: imageName)

        if(imageName == lastPopped){
            comboLength = comboLength + 1
            gameScore = gameScore + 1.5 * popScore
        } else {
            comboLength = 0
            gameScore = gameScore + popScore
        }
        lastPopped = imageName
        scoreLabel.text = String(gameScore)
        highScoreUpdate()
        sender.removeFromSuperview()
        bubblesAvailable = bubblesAvailable - 1
        bubblesRemoved = bubblesRemoved - 1
        popTag(cX: Int(sender.frame.origin.x),cY: Int(sender.frame.origin.y),score: popScore, comboLength: comboLength)
    }
}
