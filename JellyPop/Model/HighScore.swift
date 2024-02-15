//
//  HighScore.swift
//  JellyPop
//
//  Created by Syafa Sofiena on 28/4/2023.
//

import Foundation

struct HighScore: Codable{
    // Struct for maintaining high scores
    // Codable to store in UserDefaults
    var name: String
    var score: Float
}
