//
//  ScoresViewController.swift
//  JellyPop
//
//  Created by Syafa Sofiena on 28/4/2023.
//

import UIKit

// Controller for high scores
class ScoresViewController: UIViewController {
    var currentName: String = ""
    var currentScore: Float = 0
    var gamePLayFlag: Bool = false
    var allScores: [HighScore] = []
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreTable: UITableView!
    @IBOutlet weak var playAgainBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check if the game was played and accordingly update the scores
        if(gamePLayFlag){
            allScores = scoreComparision()
            scoreLabel.text = "You scored \(currentScore)"
        }
        else{
            fetchHighscores()
            scoreLabel.removeFromSuperview()
            playAgainBtn.removeFromSuperview()
        }
    }
    
    // Fetch the high scores stored in UserDefaults
    func fetchHighscores(){
        if let data = UserDefaults.standard.value(forKey:"HighScores") as? Data {
            allScores = try! PropertyListDecoder().decode(Array<HighScore>.self, from: data)
        }
    }
    
    // Compare the current score with existing high scores and update the list
    func scoreComparision() -> [HighScore]{
        let player = HighScore(name: currentName, score: currentScore)
        var fetchedScores: [HighScore] = []
        if let data = UserDefaults.standard.value(forKey:"HighScores") as? Data {
            fetchedScores = try! PropertyListDecoder().decode(Array<HighScore>.self, from: data)
        }
        if (fetchedScores.isEmpty == true){
            fetchedScores.append(player)
        }
        else{
            fetchedScores.sort{$0.score > $1.score}
            let count = fetchedScores.count
            if(count<6){
                fetchedScores.append(player)
            }
            else if(count == 6){
                if(player.score > fetchedScores.last!.score){
                    fetchedScores.removeLast()
                    fetchedScores.append(player)
                }
            }
            fetchedScores.sort{$0.score > $1.score}
        }
        userDefaults.set(try? PropertyListEncoder().encode(fetchedScores), forKey: "HighScores")
        return fetchedScores
    }
}

// Populate the score table with high scores
extension ScoresViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allScores.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "CELL")
        let cellVal = allScores[indexPath.row]
        cell.textLabel?.text = cellVal.name
        cell.detailTextLabel?.text = String(cellVal.score)
        return cell
    }
}
