//
// OptionsViewController.swift
//  JellyPop
//
//  Created by Syafa Sofiena on 28/4/2023.
//

import UIKit

// Controller for game settings
class OptionsViewController: UIViewController {
    
    @IBOutlet weak var playerNameText: UITextField!
    @IBOutlet weak var timeLimitSlider: UISlider!
    @IBOutlet weak var timeLimitLabel: UILabel!
    @IBOutlet weak var maxBubblesSlider: UISlider!
    @IBOutlet weak var maxBubblesLabel: UILabel!
    
    // User defaults object and default values for settings
    let userDefaults = UserDefaults.standard
    let defaultPlayerName = "Zhang Hao"
    let defaultTimeLimit = 60
    let defaultMaxBubbles = 15

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialising UI components with stored or default values
        let initTimeLimit = Float(userDefaults.value(forKey: "timeLimit") as? Int ?? defaultTimeLimit)
        let initMaxBubble = Float(userDefaults.value(forKey: "maxBubbles") as? Int ?? defaultMaxBubbles)
        playerNameText.text = userDefaults.value(forKey: "playerName") as? String ?? defaultPlayerName
        timeLimitSlider.setValue(initTimeLimit, animated: true)
        timeLimitLabel.text = String(Int(initTimeLimit))
        maxBubblesSlider.setValue(initMaxBubble, animated: true)
        maxBubblesLabel.text = String(Int(initMaxBubble))
    
    }
    
    // User interaction handlers
    @IBAction func changeTimeLimit(_ sender: Any) {
        timeLimitLabel.text = String(Int(timeLimitSlider.value))
    }
    
    @IBAction func changeMaxBubbles(_ sender: Any) {
        maxBubblesLabel.text = String(Int(maxBubblesSlider.value))
    }
    
    @IBAction func changeMusicSetting(_ sender: UISwitch) {
        if sender.isOn {
            MusicPlayer.shared.restartBackgroundMusic()
        } else {
            MusicPlayer.shared.stopBackgroundMusic()
        }
    }
    
    @IBAction func saveSetting(_ sender: Any) {
        userDefaults.set(playerNameText.text, forKey: "playerName")
        userDefaults.set(Int(timeLimitSlider.value), forKey: "timeLimit")
        userDefaults.set(Int(maxBubblesSlider.value), forKey: "maxBubbles")
        // Back to home
        let vc = storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
        vc.navigationItem.setHidesBackButton(true, animated: true)
    }
}
